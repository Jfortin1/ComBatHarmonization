import os
import pandas as pd
import numpy as np
from neuroCombat import neuroCombat
from neuroCombat import neuroCombatFromTraining
os.chdir('/Users/fortinj2/ComBatHarmonization/testing')
data = np.genfromtxt('inputData/testdata.csv', delimiter=",", skip_header=1)
batch_col = 'batch'


indices_training = range(10)
indices_test     = [0, 1, 5, 6]
data_training    = data[:, indices_training]
data_test        = data[:, indices_test]


## Scenario 1:
## - no covariates adjustment in training dataset
## - no covariates adjustment in test dataset
## --> Results should be identical
covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars) 
covars_training = covars.loc[indices_training,:]
results_training = neuroCombat(dat=data_training, covars=covars_training, batch_col=batch_col)["data"]
results_training = results_training[:,indices_test]
estimates=neuroCombat(dat=data_training, covars=covars_training, batch_col=batch_col)["estimates"]
results_test = neuroCombatFromTraining(dat=data_test, batch=[1,1,2,2], estimates=estimates)["data"]
# Testing if all equal:
sum(sum(results_test==results_training))==800


# This should generate an error:
results_test = neuroCombatFromTraining(dat=data_test, batch=[4,1,10,2], estimates=estimates)["data"]


## Scenario 2:
## - covariates adjustment in training dataset
## - no covariates adjustment in test dataset
## --> Results should differ
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars) 
categorical_cols = ['gender']
covars_training = covars.loc[indices_training,:]
results_training = neuroCombat(dat=data_training, covars=covars_training, batch_col=batch_col,categorical_cols=categorical_cols)["data"]
results_training = results_training[:,indices_test]
estimates=neuroCombat(dat=data_training, covars=covars_training, batch_col=batch_col,categorical_cols=categorical_cols)["estimates"]
info=neuroCombat(dat=data_training, covars=covars_training, batch_col=batch_col,categorical_cols=categorical_cols)["info"]
results_test = neuroCombatFromTraining(dat=data_test, batch=[1,1,2,2], estimates=estimates)["data"]
# Testing if all equal:
sum(sum(results_test==results_training))==800
np.savetxt('outputData/training_test_scenario2_python.csv', results_test, delimiter=',')
