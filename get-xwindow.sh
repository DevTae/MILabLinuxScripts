#!/bin/bash
# Set the xauth cache config of root account to get a user access of the x-window
# Developed by DevTae
#
# <How to Use>
# 1. Login to local user not a root account
# 2. Open the terminal and type 'bash get-xwindow.sh'
# 3. Execute the gui program as like 'sudo virt-manager'

display_split=($(echo $DISPLAY | tr ":." "\n"))
localhost=${display_split[0]}   # localhost
dis_num=${display_split[1]}     # display number
cache=($(echo $(xauth list)))   # get user xauth cache
index=-1

echo "The display number of user is $dis_num"

for ((i=0; ; i++));
do
        cache_split=($(echo ${cache[i*3]} | tr ":" "\n"))
        if [ "${cache_split[1]}" = "${dis_num}" ]
        then
                index=$i
                break
        elif [ "${cache_split[0]}" = "" ]
        then
                echo "Failed to find a user's xauth cache. Log-out the super-user and retry."
                exit 1
        else
                continue
        fi
done

loaded_cache="${cache[index*3]}  ${cache[index*3+1]}  ${cache[index*3+2]}"
if [ $index -ne -1 ]
then
        echo "Success to find your user's cache :"
        echo "$loaded_cache"
        echo
else
        echo "Fail to find your user's cache"
        exit 1
fi

sudo -s xauth add $loaded_cache
echo "The process to add the user's cache to root account is completed."

echo "Below this message, there are contents of the xauth cache file of root."
sudo -s xauth list
echo

echo "This is the end of the prcess to add the user's xauth cache."
echo "Type command like this : sudo virt-manager"
