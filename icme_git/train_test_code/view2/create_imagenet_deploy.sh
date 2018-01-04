#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

EXAMPLE=/home/chh/icme/caffe-master/examples/skeleton/skeleton_view2
DATA=/home/chh/icme/data
TOOLS=/home/chh/icme/caffe-master/build/tools

TRAIN_DATA_ROOT=/home/chh/icme/data/
VAL_DATA_ROOT=/home/chh/icme/data/

deploy_dir=/home/chh/icme/data
deploy_filename=test_view2.txt

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi


echo "Creating val lmdb..."


linenum=`wc -l ${deploy_dir}/${deploy_filename} |awk '{print$1}'`
# echo $linenum
Num1=1
FileNum=1
while [ $Num1 -lt $linenum ]
do
	Num2=`expr $Num1 + 999`
	sed -n "${Num1},${Num2}p" ${deploy_dir}/${deploy_filename} > ${deploy_dir}/deploy_view2_${FileNum}.txt
# create lmdb
	GLOG_logtostderr=1 $TOOLS/convert_imageset \
	    --resize_height=$RESIZE_HEIGHT \
	    --resize_width=$RESIZE_WIDTH \
	    --shuffle=0 \
	    $VAL_DATA_ROOT \
	    ${deploy_dir}/deploy_view2_${FileNum}.txt \
	    $EXAMPLE/skeleton_deploy_${FileNum}_lmdb
	Num1=`expr $Num2 + 1`
        FileNum=`expr $FileNum + 1`
done


echo "Done."
