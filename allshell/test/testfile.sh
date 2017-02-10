#!/bin/bash

g_date=/bin/date
g_ssh=/usr/bin/ssh

remote_user1=root
remote_machine1=10.0.10.97
remote_user2=root
remote_machine2=10.0.10.98

source $(cd $(dirname $0); pwd)/commonLib.sh

###############################################

start_date1="2019-02-27 18:00:00"
start_date2="2019-02-27 18:15:00"

remote1="${remote_user1}@${remote_machine1}"
remote2="${remote_user2}@${remote_machine2}"

while :
do
    $g_ssh $remote1 "$g_date -s \"$start_date1\"" >/dev/null
    $g_ssh $remote1 "sh /root/backup.sh"

    $g_ssh $remote2 "$g_date -s \"$start_date2\"" >/dev/null
    $g_ssh $remote2 "sh /root/pull_backup.sh"

    start_date1="$(goNextSixHour "$start_date1")"
    start_date2="$(goNextSixHour "$start_date2")"

    #sleep 1
done























