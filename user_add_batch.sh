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


# create the users using useradd script

echo "the account creation process is starting ..."

useradd -D -s /bin/bash # Default setting /bin/bash (shell)

for _key in ${!pwds_normal[@]}
do
	pwd=$(perl -e 'print crypt($ARGV[0], "password")' ${pwds_normal[$_key]})
        useradd -m -p "$pwd" $_key # m is option of making home directory
        echo "the user ${_key} is created."
done

for _key in ${!pwds_admin[@]}
do
	pwd=$(perl -e 'print crypt($ARGV[0], "password")' ${pwds_admin[$_key]})
        useradd -m -r -p "$pwd" $_key # r is option of having administrator features
        echo "the admin ${_key} is created."
done

echo "the account creation process is completed."


# the section of setting sudoers.d files

echo "the process of the setting sudoers.d is starting ..."

for _key in ${!pwds_normal[@]}
do
        echo "${_key}	ALL=(ALL) /usr/bin/docker" | sudo tee /etc/sudoers.d/$_key > /dev/null
        echo "the user ${_key}'s sudoers.d file is set."
done

for _key in ${!pwds_admin[@]}
do
        echo "${_key}	ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/$_key > /dev/null
        echo "the admin ${_key}'s sudoers.d file is set."
done

echo "the process of the setting sudoers.d is completed."
