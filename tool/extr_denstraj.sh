extr_cmd=/home/wangxz/Tools/dense_traj/release/DenseTrack
input_path=/home/wangxz/dataset/kth/KTH_Videos
output_path=/home/wangxz/dataset/kth/ExtractedFeatures/dense_traj
videos=`ls $input_path/*.avi`
for file in $videos
do
  filename=`echo ${file##*/}`
  tot_cmd="$extr_cmd $file  > $output_path/${filename}.txt"
  eval "$tot_cmd"
done
