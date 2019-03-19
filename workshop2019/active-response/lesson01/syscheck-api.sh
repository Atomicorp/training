#!/bin/sh
# Test all
# Requirements: none

ACTION=$1
USER=$2
IP=$3

LOCAL=`dirname $0`;
cd $LOCAL
cd ../
PWD=`pwd`
UNAME=`uname`


# Logging the call
echo "`date` $0 $1 $2 $3 $4 $5 field6($6) Filename: ($7) field8($8) field9($9) field10($10)" >> ${PWD}/../logs/active-responses.log



# Adding the ip to hosts.deny
if [ "x${ACTION}" = "xadd" ]; then
   # Null 
   exit 0;


# Deleting from hosts.deny   
elif [ "x${ACTION}" = "xdelete" ]; then   
   exit 0;


# Invalid action   
else
   echo "$0: invalid action: ${ACTION}"
fi       

exit 1;
