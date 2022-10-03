#!/usr/local/Cellar/bash/5.1.8/bin/bash #конкретно указана версия bash с поддержкой ассоциативных массивов

#check exiftool and cwebp

CWEBP_H_OUTPUT=$(cwebp -h | wc -l)
EXIFTOOL_H_OUTPUT=$(exiftool -h | wc -l)



if [[ $CWEBP_H_OUTPUT -eq 0 ]]
then
    echo -e "\033[31mОшибка! Не найден инструмент cwebp! \033[0m"
    exit 1
fi
if [[ $EXIFTOOL_H_OUTPUT -eq 0 ]]
then
    echo -e "\033[31mОшибка! Не найден инструмент exiftool! \033[0m"
    exit 1
fi

#full path check

shopt -s globstar

FILES=$(find $1 -name "*.jpg")
#echo $1
MPATH=$1**/*.jpg
for i in $MPATH # Whitespace-safe and recursive
do 
    #FILENAME = $(echo $i | awk -F"/" '{print $NF}' | awk -F"." '{print $1}') 
    
    touch $(echo $i | sed -e "/s/ /_").bbb
    #ditto $i  $2
done

shopt -u globstar