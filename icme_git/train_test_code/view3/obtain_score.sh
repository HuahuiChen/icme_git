#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs


TOOLS=/home/chh/icme/caffe-master/build/tools
VAL_DATA_ROOT=/home/chh/icme/data
DEPLOY_INPUT_DIR=/home/chh/icme/data

SELECT_VIEW=3
EXAMPLE=/home/chh/icme/caffe-master/examples/skeleton/skeleton_view${SELECT_VIEW}  # should exist directory
DEPLOY_INPUT_FILENAME=test_view${SELECT_VIEW}.txt # should exist files
OUTPUT_DIR=deploy_output
WEIGHTS=./skeleton_train_iter_20000.caffemodel





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


if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi


echo "Creating val lmdb..."



mkdir ${OUTPUT_DIR}

linenum=`wc -l ${DEPLOY_INPUT_DIR}/${DEPLOY_INPUT_FILENAME} |awk '{print$1}'`
echo linenum "****************"
Num1=1
FileNum=1
while [ $Num1 -lt $linenum ]
do
	Num2=`expr $Num1 + 999`
	sed -n "${Num1},${Num2}p" ${DEPLOY_INPUT_DIR}/${DEPLOY_INPUT_FILENAME} > ${DEPLOY_INPUT_DIR}/deploy_view${SELECT_VIEW}_${FileNum}.txt 

# create lmdb
	GLOG_logtostderr=1 $TOOLS/convert_imageset \
	    --resize_height=$RESIZE_HEIGHT \
	    --resize_width=$RESIZE_WIDTH \
	    --shuffle=0 \
	    $VAL_DATA_ROOT/ \
	    ${DEPLOY_INPUT_DIR}/deploy_view${SELECT_VIEW}_${FileNum}.txt \
	    $EXAMPLE/skeleton_deploy_${FileNum}_lmdb

# test and create output prob
	cp score.prototxt score_${FileNum}.prototxt # should exist files
	sed -i "s/skeleton_deploy_lmdb/skeleton_deploy_${FileNum}_lmdb/g" score_${FileNum}.prototxt
	/home/chh/icme/caffe-master/build/tools/caffe test --model=./score_${FileNum}.prototxt --weights=${WEIGHTS} -iterations=1 -gpu=0 # should exist files
	mv output.h5 ./${OUTPUT_DIR}/output_view${SELECT_VIEW}_${FileNum}.h5
	Num1=`expr $Num2 + 1`
        FileNum=`expr $FileNum + 1`
done


echo "Done."


