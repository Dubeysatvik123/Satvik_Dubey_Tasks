#!/bin/bash
echo Enter the File name
read file
echo checking file existence of $file
if [ -e $file ];
then
	echo "file exists"
else
	echo "not exists"
fi
