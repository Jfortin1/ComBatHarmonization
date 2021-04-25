import os
import pandas as pd
import numpy as np
from neuroCombat import neuroCombat
os.chdir('/Users/fortinj2/ComBatHarmonization/testing')
data = np.genfromtxt('inputData/testdata.csv', delimiter=",", skip_header=1)
categorical_cols = ['gender']
batch_col = 'batch'


#covars = {'batch':["a","a","a","a","a","b","b","b","b","b"], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,eb=False)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_noeb_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,eb=False,parametric=False)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_noeb_python.csv', data_combat, delimiter=',')



covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars) 
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,eb=False)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_noeb_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,eb=False,parametric=False)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_noeb_python.csv', data_combat, delimiter=',')


######## Mean only True
# Adjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=True,eb=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_noeb_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False,eb=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_noeb_meanonly_python.csv', data_combat, delimiter=',')


######## Mean only True
# UnAdjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data, covars=covars,batch_col=batch_col,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=True,eb=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_noeb_meanonly_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False,eb=False,mean_only=True)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_noeb_meanonly_python.csv', data_combat, delimiter=',')




############ Reference batch:

##### With reference batch:
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
ref_batch=1
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,eb=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_noeb_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,eb=False,parametric=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_noeb_batchref_python.csv', data_combat, delimiter=',')



covars = {'batch':[1,1,1,1,1,2,2,2,2,2]}
covars = pd.DataFrame(covars) 
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,eb=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_noeb_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,eb=False,parametric=False, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_noeb_batchref_python.csv', data_combat, delimiter=',')


######## Mean only True
# Adjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=True,eb=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_adjusted_noeb_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,categorical_cols=categorical_cols,parametric=False,eb=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_adjusted_noeb_meanonly_batchref_python.csv', data_combat, delimiter=',')


######## Mean only True
# UnAdjusted + Parametric
covars = {'batch':[1,1,1,1,1,2,2,2,2,2], 'gender':[1,2,1,2,1,2,1,2,1,2]} 
covars = pd.DataFrame(covars)   
data_combat = neuroCombat(dat=data, covars=covars,batch_col=batch_col,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=True,eb=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_parametric_unadjusted_noeb_meanonly_batchref_python.csv', data_combat, delimiter=',')
data_combat = neuroCombat(dat=data,covars=covars,batch_col=batch_col,parametric=False,eb=False,mean_only=True, ref_batch=ref_batch)["data"]
np.savetxt('outputData/testdata_combat_nonparametric_unadjusted_noeb_meanonly_batchref_python.csv', data_combat, delimiter=',')


