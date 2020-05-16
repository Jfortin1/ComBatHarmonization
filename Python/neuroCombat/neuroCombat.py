# Originally written by Nick Cullen
# Extended and currently maintained by JP Fortin
from __future__ import absolute_import, print_function
import pandas as pd
import numpy as np
import numpy.linalg as la
import math

def neuroCombat(dat,
           covars,
           batch_col,
           categorical_cols=None,
           continuous_cols=None,
           eb=True,
           parametric=True):
    """
    Run ComBat to remove scanner effects in multi-site imaging data

    Arguments
    ---------
    dat : a pandas data frame or numpy array
        neuroimaging data to correct with shape = (features, samples)
        e.g. cortical thickness measurements, image voxels, etc

    covars : a pandas data frame w/ shape = (samples, features)
        demographic/phenotypic/behavioral/batch data 
        
    batch_col : string indicating batch (scanner) variable in covars

    categorical_cols : string or list of strings indicating categorical variables to adjust for
        - e.g. male or female

    continuous_cols : string or list of strings indicating continuous variables to adjust for
        - e.g. age

    eb : should Empirical Bayes be performed?
        - True by default

    parametric : should parametric adjustements be performed?
        - True by default
        
    Returns
    -------
    - A numpy array with the same shape as `dat` which has now been ComBat-harmonized
    """
    ##############################
    ### CLEANING UP INPUT DATA ###
    ##############################
    if not isinstance(covars, pd.DataFrame):
        raise ValueError('covars must be pandas datafraae -> try: covars = pandas.DataFrame(covars)')

    if not isinstance(categorical_cols, (list,tuple)):
        if categorical_cols is None:
            categorical_cols = []
        else:
            categorical_cols = [categorical_cols]
    if not isinstance(continuous_cols, (list,tuple)):
        if continuous_cols is None:
            continuous_cols = []
        else:
            continuous_cols = [continuous_cols]

    covar_labels = np.array(covars.columns)
    covars = np.array(covars, dtype='object') 
    for i in range(covars.shape[-1]):
        try:
            covars[:,i] = covars[:,i].astype('float32')
        except:
            pass

    if isinstance(dat, pd.DataFrame):
        dat = np.array(dat, dtype='float32')
    #dat = dat.T # transpose data to make it (features, samples)... a weird genetics convention..

    ##############################

    # get column indices for relevant variables
    batch_col = np.where(covar_labels==batch_col)[0][0]
    cat_cols = [np.where(covar_labels==c_var)[0][0] for c_var in categorical_cols]
    num_cols = [np.where(covar_labels==n_var)[0][0] for n_var in continuous_cols]

    # conver batch col to integer
    covars[:,batch_col] = np.unique(covars[:,batch_col],return_inverse=True)[-1]
    # create dictionary that stores batch info
    (batch_levels, sample_per_batch) = np.unique(covars[:,batch_col],return_counts=True)
    info_dict = {
        'batch_levels': batch_levels.astype('int'),
        'n_batch': len(batch_levels),
        'n_sample': int(covars.shape[0]),
        'sample_per_batch': sample_per_batch.astype('int'),
        'batch_info': [list(np.where(covars[:,batch_col]==idx)[0]) for idx in batch_levels]
    }

    # create design matrix
    print('[neuroCombat] Creating design matrix')
    design = make_design_matrix(covars, batch_col, cat_cols, num_cols)
    
    # standardize data across features
    print('[neuroCombat] Standardizing data across features')
    s_data, s_mean, v_pool = standardize_across_features(dat, design, info_dict)
    
    # fit L/S models and find priors
    print('[neuroCombat] Fitting L/S model and finding priors')
    LS_dict = fit_LS_model_and_find_priors(s_data, design, info_dict)

    # find parametric adjustments
    if eb:
        if parametric:
            print('[neuroCombat] Finding parametric adjustments')
            gamma_star, delta_star = find_parametric_adjustments(s_data, LS_dict, info_dict)
        else:
            print('[neuroCombat] Finding non-parametric adjustments')
            gamma_star, delta_star = find_non_parametric_adjustments(s_data, LS_dict, info_dict)
    else:
        print('[neuroCombat] Finding L/S adjustments without Empirical Bayes')
        gamma_star, delta_star = find_non_eb_adjustments(s_data, LS_dict, info_dict)

    # adjust data
    print('[neuroCombat] Final adjustment of data')
    bayes_data = adjust_data_final(s_data, design, gamma_star, delta_star, 
                                                s_mean, v_pool, info_dict)

    bayes_data = np.array(bayes_data)

    return bayes_data.T

def make_design_matrix(Y, batch_col, cat_cols, num_cols):
    """
    Return Matrix containing the following parts:
        - one-hot matrix of batch variable (full)
        - one-hot matrix for each categorical_cols (removing the first column)
        - column for each continuous_cols
    """
    def to_categorical(y, nb_classes=None):
        if not nb_classes:
            nb_classes = np.max(y)+1
        Y = np.zeros((len(y), nb_classes))
        for i in range(len(y)):
            Y[i, y[i]] = 1.
        return Y
    
    hstack_list = []

    ### batch one-hot ###
    # convert batch column to integer in case it's string
    batch = np.unique(Y[:,batch_col],return_inverse=True)[-1]
    batch_onehot = to_categorical(batch, len(np.unique(batch)))
    hstack_list.append(batch_onehot)

    ### categorical one-hots ###
    for cat_col in cat_cols:
        cat = np.unique(np.array(Y[:,cat_col]),return_inverse=True)[1]
        cat_onehot = to_categorical(cat, len(np.unique(cat)))[:,1:]
        hstack_list.append(cat_onehot)

    ### numerical vectors ###
    for num_col in num_cols:
        num = np.array(Y[:,num_col],dtype='float32')
        num = num.reshape(num.shape[0],1)
        hstack_list.append(num)

    design = np.hstack(hstack_list)
    return design

def standardize_across_features(X, design, info_dict):
    n_batch = info_dict['n_batch']
    n_sample = info_dict['n_sample']
    sample_per_batch = info_dict['sample_per_batch']

    B_hat = np.dot(np.dot(la.inv(np.dot(design.T, design)), design.T), X.T)
    grand_mean = np.dot((sample_per_batch/ float(n_sample)).T, B_hat[:n_batch,:])
    var_pooled = np.dot(((X - np.dot(design, B_hat).T)**2), np.ones((n_sample, 1)) / float(n_sample))

    stand_mean = np.dot(grand_mean.T.reshape((len(grand_mean), 1)), np.ones((1, n_sample)))
    tmp = np.array(design.copy())
    tmp[:,:n_batch] = 0
    stand_mean  += np.dot(tmp, B_hat).T

    s_data = ((X- stand_mean) / np.dot(np.sqrt(var_pooled), np.ones((1, n_sample))))

    return s_data, stand_mean, var_pooled

def aprior(gamma_hat):
    m = np.mean(gamma_hat)
    s2 = np.var(gamma_hat,ddof=1)
    return (2 * s2 +m**2) / float(s2)

def bprior(gamma_hat):
    m = gamma_hat.mean()
    s2 = np.var(gamma_hat,ddof=1)
    return (m*s2+m**3)/s2

def postmean(g_hat, g_bar, n, d_star, t2):
    return (t2*n*g_hat+d_star * g_bar) / (t2*n+d_star)

def postvar(sum2, n, a, b):
    return (0.5 * sum2 + b) / (n / 2.0 + a - 1.0)

def fit_LS_model_and_find_priors(s_data, design, info_dict):
    n_batch = info_dict['n_batch']
    batch_info = info_dict['batch_info'] 
    
    batch_design = design[:,:n_batch]
    gamma_hat = np.dot(np.dot(la.inv(np.dot(batch_design.T, batch_design)), batch_design.T), s_data.T)

    delta_hat = []
    for i, batch_idxs in enumerate(batch_info):
        delta_hat.append(np.var(s_data[:,batch_idxs],axis=1,ddof=1))
    
    gamma_bar = np.mean(gamma_hat, axis=1) 
    t2 = np.var(gamma_hat,axis=1, ddof=1)

    a_prior = list(map(aprior, delta_hat))
    b_prior = list(map(bprior, delta_hat))

    LS_dict = {}
    LS_dict['gamma_hat'] = gamma_hat
    LS_dict['delta_hat'] = delta_hat
    LS_dict['gamma_bar'] = gamma_bar
    LS_dict['t2'] = t2
    LS_dict['a_prior'] = a_prior
    LS_dict['b_prior'] = b_prior
    return LS_dict

#Helper function for parametric adjustements:
def it_sol(sdat, g_hat, d_hat, g_bar, t2, a, b, conv=0.0001):
    n = (1 - np.isnan(sdat)).sum(axis=1)
    g_old = g_hat.copy()
    d_old = d_hat.copy()

    change = 1
    count = 0
    while change > conv:
        g_new = postmean(g_hat, g_bar, n, d_old, t2)
        sum2 = ((sdat - np.dot(g_new.reshape((g_new.shape[0], 1)), np.ones((1, sdat.shape[1])))) ** 2).sum(axis=1)
        d_new = postvar(sum2, n, a, b)

        change = max((abs(g_new - g_old) / g_old).max(), (abs(d_new - d_old) / d_old).max())
        g_old = g_new #.copy()
        d_old = d_new #.copy()
        count = count + 1
    adjust = (g_new, d_new)
    return adjust 



#Helper function for non-parametric adjustements:
def int_eprior(sdat, g_hat, d_hat):
    r = sdat.shape[0]
    gamma_star, delta_star = [], []
    for i in range(0,r,1):
        g = np.delete(g_hat,i)
        d = np.delete(d_hat,i)
        x = sdat[i,:]
        n = x.shape[0]
        j = np.repeat(1,n)
        A = np.repeat(x, g.shape[0])
        A = A.reshape(n,g.shape[0])
        A = np.transpose(A)
        B = np.repeat(g, n)
        B = B.reshape(g.shape[0],n)
        resid2 = np.square(A-B)
        sum2 = resid2.dot(j)
        LH = 1/(2*math.pi*d)**(n/2)*np.exp(-sum2/(2*d))
        LH = np.nan_to_num(LH)
        gamma_star.append(sum(g*LH)/sum(LH))
        delta_star.append(sum(d*LH)/sum(LH))
    adjust = (gamma_star, delta_star)
    return adjust


def find_parametric_adjustments(s_data, LS, info_dict):
    batch_info  = info_dict['batch_info'] 

    gamma_star, delta_star = [], []
    for i, batch_idxs in enumerate(batch_info):
        temp = it_sol(s_data[:,batch_idxs], LS['gamma_hat'][i],
                    LS['delta_hat'][i], LS['gamma_bar'][i], LS['t2'][i], 
                    LS['a_prior'][i], LS['b_prior'][i])

        gamma_star.append(temp[0])
        delta_star.append(temp[1])

    return np.array(gamma_star), np.array(delta_star)

def find_non_parametric_adjustments(s_data, LS, info_dict):
    batch_info  = info_dict['batch_info'] 

    gamma_star, delta_star = [], []
    for i, batch_idxs in enumerate(batch_info):
        temp = int_eprior(s_data[:,batch_idxs], LS['gamma_hat'][i],
                    LS['delta_hat'][i])

        gamma_star.append(temp[0])
        delta_star.append(temp[1])

    return np.array(gamma_star), np.array(delta_star)

def find_non_eb_adjustments(s_data, LS, info_dict):
    return LS['gamma_hat'], LS['delta_hat']

def adjust_data_final(s_data, design, gamma_star, delta_star, stand_mean, var_pooled, info_dict):
    sample_per_batch = info_dict['sample_per_batch']
    n_batch = info_dict['n_batch']
    n_sample = info_dict['n_sample']
    batch_info = info_dict['batch_info']

    batch_design = design[:,:n_batch]

    bayesdata = s_data
    gamma_star = np.array(gamma_star)
    delta_star = np.array(delta_star)

    for j, batch_idxs in enumerate(batch_info):
        dsq = np.sqrt(delta_star[j,:])
        dsq = dsq.reshape((len(dsq), 1))
        denom = np.dot(dsq, np.ones((1, sample_per_batch[j])))
        numer = np.array(bayesdata[:,batch_idxs] - np.dot(batch_design[batch_idxs,:], gamma_star).T)

        bayesdata[:,batch_idxs] = numer / denom

    vpsq = np.sqrt(var_pooled).reshape((len(var_pooled), 1))
    bayesdata = bayesdata * np.dot(vpsq, np.ones((1, n_sample))) + stand_mean

    return bayesdata
