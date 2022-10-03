#!/usr/local/bin/bash
#path for MacOS, change for other OS

#formats from my library
find $PWD -name "*.MTS" > listfiles
find $PWD -name "*.mp4" >> listfiles
find $PWD -name "*.MP4" >> listfiles


if [[ -n $1 ]] 
then
    head -n $1 listfiles > workingfiles
    cat workingfiles > listfiles
fi

ALL_LINES_COUNT=$(wc -l < listfiles)
echo $ALL_LINES_COUNT
let CURRENT_PROGRESS=0
cat listfiles | while read line; 
do 
#echo $line; #uncomment for more info
FN=$(echo "$line" | awk -F/ '{print $NF}' | awk -F'.' '{print $1}' )
FFN=$(echo "$line" | awk -F/ '{print $NF}' )
COUNT=${#FFN}
PATHFILE=${line::-$COUNT}
echo $PATHFILE$FN
ffmpeg -threads 16 -i "$line" -c:v libvpx-vp9 -crf 33 -b:v 0 -c:a libopus "$PATHFILE""$FN".webm &>> logvideo
#echo $line

let CURRENT_PROGRESS++
PERCENT=$(echo $CURRENT_PROGRESS / $ALL_LINES_COUNT *100 | bc -l)
PERCENT=${PERCENT::-16}
echo "$PERCENT%"
rm "$line" #comment if there is no backup
done

rm listfiles

