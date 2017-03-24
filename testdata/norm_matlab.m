addpath('/users/jfortin/ComBatHarmonization/Matlab')
data =  csvread('testdata.csv',1);
batch = [1 1 1 1 1 2 2 2 2 2];
mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2]';
norm = combat(data,batch,mod);
dlmwrite('testdata_combat_matlab.csv',norm,'delimiter',',','precision','%.14f');

% Those examples are supposed to give errors:
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 1 1 1 1 2 2 2 2 2]';
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 1 1 1 1 2 2 2 2 2]';
%mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2; 1 2 1 2 1 2 1 2 1 2]';
%norm = combat(data,batch,mod);