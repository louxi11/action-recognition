import os
import numpy as np
import scipy.io as sio

in_dir='extra_mbh'
out_dir = 'output'

def process(filename):
    f = open(os.path.join(in_dir,filename))
    lines = f.readlines()
    f.close()
    print 'lines: ', len(lines)
    row_list = []
    for item in lines:
        t = item.split('\t')
        t [0:244] = []
        del t [-1]  # remove \n
        t2 = map(float, t)
        row_list.append(np.array(t2))

    mat =  np.array(row_list)
    print mat.shape
    sio.savemat(out_dir+'/'+filename+'.mat', {'feature':mat})

dirs=os.listdir(in_dir)
print dirs
for item in dirs:
    process(item)
