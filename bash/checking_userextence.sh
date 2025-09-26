#!/bin/bash
echo "Checking user existence"
read -p " enter the username: " uname
if grep -q "^$uname:" /etc/passwd; then
    echo "Username: '$uname'."
else
    echo "Username: '$uname'."
fi

