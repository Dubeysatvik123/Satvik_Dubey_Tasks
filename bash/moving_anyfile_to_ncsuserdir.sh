#!/bin/bash 
echo "Create a directory"
read dir
mkdir /home/ncs/$dir
echo "Enter the path of the file which uh wanna move"
read path
mv $path /home/ncs/$dir
