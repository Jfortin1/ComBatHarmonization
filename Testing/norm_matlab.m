%addpath('/users/jfortin/ComBatHarmonization/Matlab/scripts')
addpath('/users/fortinj2/ComBatHarmonization/Matlab/scripts')
data =  csvread('inputData/testdata.csv',1);
batch = [1 1 1 1 1 2 2 2 2 2];
mod = [1 1 1 1 1 1 1 1 1 1 ;2 1 2 1 2 1 2 1 2 1]';
norm = combat(data,batch,mod,1);
dlmwrite('outputData/testdata_combat_parametric_adjusted_matlab.csv',norm,'delimiter',',','precision','%.14f');
norm = combat(data,batch,mod,0);
dlmwrite('outputData/testdata_combat_nonparametric_adjusted_matlab.csv',norm,'delimiter',',','precision','%.14f');
mod = [];
norm = combat(data,batch,mod,1);
dlmwrite('outputData/testdata_combat_parametric_unadjusted_matlab.csv',norm,'delimiter',',','precision','%.14f');
norm = combat(data,batch,mod,0);
dlmwrite('outputData/testdata_combat_nonparametric_unadjusted_matlab.csv',norm,'delimiter',',','precision','%.14f');

% Those examples are supposed to give errors:
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 1 1 1 1 2 2 2 2 2]';
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 1 1 1 1 2 2 2 2 2]';
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 2 1 2 1 2 1 2 1 2]';
%norm = combat(data,batch,mod);