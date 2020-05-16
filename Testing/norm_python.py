import os
import pandas as pd
import numpy as np
from neuroCombat import neuroCombat
os.chdir('/Users/fortinj2/ComBatHarmonization/testing')
data = np.genfromtxt('inputData/testdata.csv', delimiter=",", skip_header=1)
categorical_cols = ['gender']
batch_col = 'batch'



# Adjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
			batch_col=batch_col,
                     categorical_cols=categorical_cols)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_parametric_adjusted_python.csv', data_combat, delimiter=',')


# Unadjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
					 batch_col=batch_col)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_parametric_unadjusted_python.csv', data_combat, delimiter=',')



# NoEB + adjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
					 batch_col=batch_col,
                     categorical_cols=categorical_cols,
                     eb=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_parametric_adjusted_noeb_python.csv', data_combat, delimiter=',')

# NoEB + Unadjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
					 batch_col=batch_col,
					 eb=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_parametric_unadjusted_noeb_python.csv', data_combat, delimiter=',')




# Adjusted + NonParametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   

data_combat = neuroCombat(dat=data,
                     covars=covars,
                     batch_col=batch_col,
                     categorical_cols=categorical_cols,
                     parametric=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_python.csv', data_combat, delimiter=',')




# Unadjusted + NonParametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
                     batch_col=batch_col,
                     parametric=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_python.csv', data_combat, delimiter=',')



# NoEB + adjusted + NonParametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
                                    batch_col=batch_col,
                     categorical_cols=categorical_cols,
                     eb=False,
                     parametric=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_noeb_python.csv', data_combat, delimiter=',')

# NoEB + Unadjusted + NonParametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,
                     covars=covars,
                                    batch_col=batch_col,
                                    eb=False,
                                    parametric=False)
data_combat =np.transpose(data_combat)
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_noeb_python.csv', data_combat, delimiter=',')






