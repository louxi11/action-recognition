#!/bin/bash
cmd_path='/home/wangxz/Downloads/dense_traj/release/DenseTrack'
input_path='/home/wangxz/temp/test/'
output_path='/home/wangxz/temp/test/output'

for video in $(find $input_path -name '*.avi')
do
   video_name="${video##*/}"
   video_path=${video%/*}
   par_name="${video_path##*/}"
   des_path=$output_path/$par_name
   #echo $des_path
   if [ ! -e $des_path ];then
       mkdir $des_path
   fi
   #echo 'file' > $des_path/${filename}.txt
   cmd="$cmd_path $video > $des_path/${video_name}.txt"
   eval "$cmd"
done

#videos=`ls $input_path`
#for file in $videos
#do
  #echo $output_path/${file}.txt
  #cmd="$cmd_path $file > $output_path/${file}.txt"
#  eval "$cmd"
#done

