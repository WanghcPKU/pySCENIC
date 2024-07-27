import os, sys
os.getcwd()
#os.chdir()
os.listdir(os.getcwd()) 

import loompy as lp;
import numpy as np;
import scanpy as sc;
x=sc.read_csv("./df.csv");
row_attrs = {"Gene": np.array(x.var_names),};
col_attrs = {"CellID": np.array(x.obs_names)};
lp.create("./df.loom",x.X.transpose(),row_attrs,col_attrs);
