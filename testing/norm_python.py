import os
import pandas as pd
import numpy as np
from combat import combat
os.chdir('/Users/fortinj2/ComBatHarmonization/testing')
data = np.genfromtxt('data/testdata.csv', delimiter=",", skip_header=1)

covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
categorical_cols = ['gender']
batch_col = 'batch'

data_combat = combat(dat=data,
                     covars=covars,
					 batch_col=batch_col,
                     categorical_cols=categorical_cols)
data_combat =np.transpose(data_combat)
np.savetxt('data/testdata_combat_parametric_adjusted_python.csv', data_combat, delimiter=',')

covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars)   
data_combat = combat(dat=data,
                     covars=covars,
					 batch_col=batch_col)
data_combat =np.transpose(data_combat)
np.savetxt('data/testdata_combat_parametric_unadjusted_python.csv', data_combat, delimiter=',')