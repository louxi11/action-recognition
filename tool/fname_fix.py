import os

in_dir='testTrainMulti'
out_dir = 'hmdb51_org'
split_dir = 'split1'

def needFix(ss):
    ret = False
    if ss.find('!') > -1:
        ss = ss.replace('!', '')
        ret = True
    if ss.find('(') > -1:
        ss = ss.replace('(', '_')
        ret = True
    if ss.find(')') > -1:
        ss = ss.replace(')', '_')
        ret = True
    if ss.find('[') > -1:
        ss = ss.replace('[', '_')
        ret = True
    if ss.find(']') > -1:
        ss = ss.replace(']', '_')
        ret = True
    if ss.find('#') > -1:
        ss = ss.replace('#', '')
        ret = True
    if ss.find('@') > -1:
        ss = ss.replace('@', '')
        ret = True
    if ss.find('{') > -1:
        ss = ss.replace('{', '')
        ret = True
    if ss.find('}') > -1:
        ss = ss.replace('}', '')
        ret = True
    if ss.find('+') > -1:
        ss = ss.replace('+', '')
        ret = True
    if ss.find('&') > -1:
        ss = ss.replace('&', '')
        ret = True
    if ss.find('~') > -1:
        ss = ss.replace('~', '')
        ret = True
    if ss.find(';') > -1:
        ss = ss.replace(';', '')
        ret = True
    return (ret,ss)


import re
p = re.compile('[a-zA-Z0-9\-\.\_]')
spe_list = []

def findSpec(filename):
    global spe_list
    f = open(os.path.join(in_dir,filename))
    lines = f.readlines()
    f.close()
    for item in lines:
        for x in item:
            if p.match(x) == None and spe_list.count(x)==0:
                spe_list.append(x)
                print x

def fixFname(filename):
    global spe_list
    f = open(os.path.join(in_dir,filename))
    lines = f.readlines()
    f.close()
    dirname = filename.split('_test_split1.txt')[0]
    for item in lines:
        oldName = item.split()[0]
        (bFix,newName) = needFix(oldName)
        if bFix:
            oldName = os.path.join(out_dir,dirname,oldName)
            newName = os.path.join(out_dir,dirname,newName)
            os.rename(oldName, newName)
cnt = 0
def delExtraFile(filename):
    global cnt
    f = open(os.path.join(in_dir,filename))
    lines = f.readlines()
    f.close()
    f = open(os.path.join(split_dir,filename), 'w')
    dirname = filename.split('_test_split1.txt')[0]
    for item in lines:
        oldName = item.split()[0]
        tag = item.split()[1]
        #print tag
        if int(tag) == 0:  # then delete this video
            vid_name = os.path.join(out_dir,dirname,oldName)
            #os.remove(vid_name)
            cnt = cnt + 1
            continue
        (bFix,newName) = needFix(oldName)
        f.write(' '.join([newName,tag])+'\n')
        if bFix:
            oldName = os.path.join(out_dir,dirname,oldName)
            newName = os.path.join(out_dir,dirname,newName)
            #os.rename(oldName, newName)
    f.close()

def checkResult(dirname):
    files = os.listdir(os.path.join(out_dir,dirname))
    global spe_list
    for item in files:
        for x in item:
            if p.match(x) == None and spe_list.count(x)==0:
                spe_list.append(x)
                print x


#dirs=os.listdir(in_dir)
#for item in dirs:
#    fixFname(item)

#spe_list=[]
#for item in dirs:
#    findSpec(item)

dirs=os.listdir(in_dir)
for item in dirs:
    delExtraFile(item)
#print 'total remove ', cnt

# check result
#dirs = os.listdir(out_dir)
#spe_list = []
#for item in dirs:
#    checkResult(item)
