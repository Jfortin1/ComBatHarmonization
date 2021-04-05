import os
from rpy2.robjects import r, numpy2ri, pandas2ri
from rpy2.robjects.packages import importr
numpy2ri.activate()
pandas2ri.activate()
importr('neuroCombat')
importr('BiocParallel')
importr('matrixStats')
neurobase = importr('neurobase')

def readnii(file):
	return neurobase.readnii(file)
def writenii(data, file):
	import nibabel as nib
	import numpy as np
	if type(data) is np.ndarray:
		new_image = nib.Nifti1Image(data, affine=np.eye(4))
		return new_image.to_filename(file)
	else:
		return neurobase.writenii(data, file)


def combatExampleData():
	return r('combatExampleData')

def combatExamplePheno():
	return r('combatExamplePheno')

def combatExampleScanner():
	return r('combatExampleScanner')

def drawPriorDelta(combat_estimates = r('NA'), col = r('NULL'), xlim = None, ylim = None):
	r.assign('combat.estimates', combat_estimates)
	r.assign('col', col)
	if xlim is None:
		xlim = r('c(-0.3, 2)')
	r.assign('xlim', xlim)
	if ylim is None:
		ylim = r('c(0, 3)')
	r.assign('ylim', ylim)
	return r('drawPriorDelta(combat.estimates=combat.estimates, col=col, xlim=xlim, ylim=ylim)')

def drawPriorGamma(combat_estimates = r('NA'), col = r('NULL'), xlim = None, ylim = None):
	r.assign('combat.estimates', combat_estimates)
	r.assign('col', col)
	if xlim is None:
		xlim = r('c(-3, 1.5)')
	r.assign('xlim', xlim)
	if ylim is None:
		ylim = r('c(0, 3)')
	r.assign('ylim', ylim)
	return r('drawPriorGamma(combat.estimates=combat.estimates, col=col, xlim=xlim, ylim=ylim)')

def neuroCombat(dat = r('NA'), batch = r('NA'), mod = r('NULL'), eb = True, parametric = True, mean_only = False, ref_batch = r('NULL'), verbose = True, BPPARAM = None):
	r.assign('dat', dat)
	r.assign('batch', batch)
	r.assign('mod', mod)
	r.assign('eb', eb)
	r.assign('parametric', parametric)
	r.assign('mean.only', mean_only)
	r.assign('ref.batch', ref_batch)
	r.assign('verbose', verbose)
	if BPPARAM is None:
		BPPARAM = r('bpparam("SerialParam")')
	r.assign('BPPARAM', BPPARAM)
	return r('neuroCombat(dat=dat, batch=batch, mod=mod, eb=eb, parametric=parametric, mean.only=mean.only, ref.batch=ref.batch, verbose=verbose, BPPARAM=BPPARAM)')

def neuroCombatFromTraining(dat = r('NA'), batch = r('NA'), estimates = r('NA'), mod = r('NULL'), verbose = True):
	r.assign('dat', dat)
	r.assign('batch', batch)
	r.assign('estimates', estimates)
	r.assign('mod', mod)
	r.assign('verbose', verbose)
	return r('neuroCombatFromTraining(dat=dat, batch=batch, estimates=estimates, mod=mod, verbose=verbose)')
