#!/usr/bin/env python
# -*- coding: utf-8 -*-
import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()
    
setuptools.setup(
  author="Jean-Philippe Fortin, Nick Cullen",
  author_email='fortin946@gmail.com,',
  classifiers=[
    'License :: OSI Approved :: MIT License',
    'Programming Language :: Python :: 3.7',
  ],
  description="ComBat algorithm for harmonizing multi-site imaging data",
  license="MIT license",
  url="https://github.com/fortinj2/ComBatHarmonization/python/neuroCombat",
  project_urls={
    "Source Code": "https://github.com/fortinj2/ComBatHarmonization/python/neuroCombat",
  },
  name='neuroCombat',
  packages=['neuroCombat',],
  version='0.2.0',
  zip_safe=False,
)
