#!/bin/bash
# Developed by DevTae@2023

# declare users with username and password

declare -A pwds_normal
pwds_normal["user1"]="password1"
pwds_normal["user2"]="password2"
pwds_normal["user3"]="password3"

declare -A pwds_admin
pwds_admin["admin1"]="password1"
pwds_admin["admin2"]="password2"
pwds_admin["admin3"]="password3"


# create the users using deluser script

echo "the account removing process is starting ..."

for _key in ${!pwds_normal[@]}
do
        deluser $_key
        echo "the user ${_key} is removed."
done

for _key in ${!pwds_admin[@]}
do
        deluser $_key;
        echo "the admin ${_key} is removed."
done

echo "the account removing process is completed."


# the section of removing sudoers.d files

echo "the process of the removing sudoers.d is starting ..."

for _key in ${!pwds_normal[@]}
do
        sudo rm /etc/sudoers.d/$_key 
	sudo rm -r /home/$_key
        echo "the user ${_key}'s sudoers.d file is removed."
done

for _key in ${!pwds_admin[@]}
do
        sudo rm /etc/sudoers.d/$_key
	sudo rm -r /home/$_key
        echo "the admin ${_key}'s sudoers.d file is removed."
done

echo "the process of the removing sudoers.d is completed."
