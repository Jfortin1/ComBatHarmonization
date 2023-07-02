
%data = randn(1000,10);
%batch = [1 1 1 1 1 2 2 2 2 2];
%mod = [1 2 1 2 1 2 1 2 1 2]';



function bayesdata = combat(dat, batch, mod, parametric)
    numData = size(dat,1); 
    [sds] = std(dat,0,2); 
    wh = find(sds==0);
    [ns,ms] = size(wh); %#ok<ASGLU> 
    if ns>0
        error('Error. There are rows with constant values across samples. Remove these rows and rerun ComBat.')
    end
    batchmod = categorical(batch);
    batchmod = dummyvar({batchmod});
    n_batch = size(batchmod,2);
    levels = unique(batch);
    fprintf('[combat] Found %d batches\n', n_batch);

    batches = cell(0);
    for i=1:n_batch
        batches{i}=find(batch == levels(i));
    end
    n_batches = cellfun(@length,batches);
    n_array = sum(n_batches);

    % Creating design matrix and removing intercept:
    design = [batchmod mod];
    numDesignCols = size(design,2); 
    intercept = ones(1,n_array)';
    wh = cellfun(@(x) isequal(x,intercept),num2cell(design,1));
    bad = wh==1; 
    design(:,bad)=[];


    fprintf('[combat] Adjusting for %d covariate(s) of covariate level(s)\n',numDesignCols-size(batchmod,2)); 
    % Check if the design is confounded
    if rank(design)<numDesignCols
        nn = numDesignCols; 
        if nn==(n_batch+1)
  	      error('Error. The covariate is confounded with batch. Remove the covariate and rerun ComBat.')
        end
        if nn>(n_batch+1)
  	      temp = design(:,(n_batch+1):nn);
          if rank(temp) < size(temp,2)
  	        error('Error. The covariates are confounded. Please remove one or more of the covariates so the design is not confounded.')
          else
  	        error('Error. At least one covariate is confounded with batch. Please remove confounded covariates and rerun ComBat.')
          end
        end
    end


    fprintf('[combat] Standardizing Data across features\n')
    %% edit by PNT 6/7/23: check for nans and attempt to replicate R
    % behavior
    if sum(any(isnan(dat)))>0
        B_hat = nan(numDesignCols,numData);
        %loop through rows
        for idx = 1:numData
            yy = dat(idx,:); % this is yy in R
            yy_noNan = yy(~isnan(yy));
            designn = design(~isnan(yy),:); 
            crossDesign = designn'*designn; %crossprod(designn)
            crossDesignY = designn'*yy_noNan'; %crossprod(designn,yy)
            B_hat(:,idx) = crossDesign\crossDesignY; %solve(crossprod(designn),crossprod(designn,yy))
        end
        % now for the pooled variance stuff (copying as closely as possible
        % from R
        grand_mean = (n_batches/n_array)*B_hat(1:n_batch,:); %grand mean can stay the same
        stand_mean = grand_mean'*ones(1,n_array);
        ns = sum(~isnan(dat),2); %ns in R
        factors = ns./(ns-1); %factors in R
        var_pooled = var(dat-(design*B_hat)',0,2,'omitnan')./factors; 
        wh = find(var_pooled==0);
        var_pooled_notzero = var_pooled;
        var_pooled_notzero(wh) = [];
        var_pooled(wh) = median(var_pooled_notzero);
    else
        B_hat = (design'*design)\design'*dat'; 
        %Standarization Model
        grand_mean = (n_batches/n_array)*B_hat(1:n_batch,:);
        var_pooled = ((dat-(design*B_hat)').^2)*repmat(1/n_array,n_array,1);
        stand_mean = grand_mean'*ones(1,n_array); 
        % Making sure pooled variances are not zero:
        wh = find(var_pooled==0);
        var_pooled_notzero = var_pooled;
        var_pooled_notzero(wh) = [];
        var_pooled(wh) = median(var_pooled_notzero);
    end
    if not(isempty(design))
        tmp = design;
        tmp(:,1:n_batch) = 0;
        stand_mean = stand_mean+(tmp*B_hat)';
    end
    s_data = (dat-stand_mean)./(sqrt(var_pooled)*ones(1,n_array));



    %Get regression batch effect parameters
    fprintf('[combat] Fitting L/S model and finding priors\n')
    batch_design = design(:,1:n_batch);
    %% edit by Philip N. Tubiolo PNT 06/06/23: implement missing value support
    if sum(any(isnan(s_data)))>0
        gamma_hat = nan(n_batch,numData);
        %loop through rows
        for idx = 1:numData
            yy = s_data(idx,:); % this is yy in R
            yy_noNan = yy(~isnan(yy));
            designn = batch_design(~isnan(yy),:);
            crossDesign = designn'*designn; %crossprod(designn)
            crossDesignY = designn'*yy_noNan'; %crossprod(designn,yy)
            gamma_hat(:,idx) = crossDesign\crossDesignY; %solve(crossprod(designn),crossprod(designn,yy))
        end
    else
        gamma_hat = ((batch_design'*batch_design)\(batch_design'))*s_data'; 
    end

    delta_hat = nan(n_batch,numData);
    for i=1:n_batch
        indices = batches{i};
        delta_hat(i,:) = transpose(var(s_data(:,indices),0,2,'omitnan'));
    end

    [gamma_star,delta_star] = deal(nan(n_batch,numData)); 
    if parametric
        fprintf('[combat] Finding parametric adjustments\n')
        %Find parametric priors:
        %Moved code block into parametric if statement since it is not
        %necessary for nonparametric adjustments.
        gamma_bar = mean(gamma_hat,2)';
        t2 = var(gamma_hat,0,2)';
        delta_hat_cell = num2cell(delta_hat,2);
        [a_prior, b_prior] = deal(nan(1,n_batch)); 
        for i=1:n_batch
            a_prior(i) = aprior(delta_hat_cell{i});
            b_prior(i) = bprior(delta_hat_cell{i});
        end
        for i=1:n_batch
            indices = batches{i};
            temp = itSol(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:),gamma_bar(i),t2(i),a_prior(i),b_prior(i), 0.001);
            gamma_star(i,:) = temp(1,:); 
            delta_star(i,:) = temp(2,:); 
        end
    end

    if (~parametric)
        fprintf('[combat] Finding non-parametric adjustments\n')
        for i=1:n_batch
            indices = batches{i};
            temp = inteprior(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:)); % Optimized inteprior.m John C. Williams JCW 06/30/2023
            gamma_star(i,:) = temp(1,:); 
            delta_star(i,:) = temp(2,:);
        end
    end

    fprintf('[combat] Adjusting the Data\n')
    bayesdata = s_data;
    j = 1;
    for i=1:n_batch
        indices = batches{i};
        bayesdata(:,indices) = (bayesdata(:,indices)-(batch_design(indices,:)*gamma_star)')./(sqrt(delta_star(j,:))'*ones(1,n_batches(i)));
        j = j+1;
    end
    bayesdata = (bayesdata.*(sqrt(var_pooled)*ones(1,n_array)))+stand_mean;

end

