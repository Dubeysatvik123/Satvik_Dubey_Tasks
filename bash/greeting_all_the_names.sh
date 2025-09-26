#!/bin/bash
echo " printing the name"
read -p "Enter the name " name
for i in $name; do
	echo "Hi $i"
done
