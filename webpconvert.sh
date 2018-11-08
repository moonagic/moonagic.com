#!/bin/zsh

imageDir="images"
function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            fullfile=$1"/"$file
            fullname=$(basename $fullfile)
            dir=$(dirname $fullfile)
            filename=$(echo $fullname | cut -d . -f1)
            extension=$(echo $fullname | cut -d . -f2)
            # echo $dir , $fullname , $filename , $extension
            cwebp $1"/"$file -o $1"/"$filename".webp" &
        fi
    done
}

read_dir $imageDir
