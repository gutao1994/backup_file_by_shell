#!/bin/bash

#################################################
#this program will pull backup file from remote server
#by rsync command,so make sure remote server had installed rsync
#and run aright,and this server shoule also had installed rsync
#and config correctly
#################################################

#command variable
g_mkdir=/bin/mkdir
g_rsync=/usr/bin/rsync
g_ls=/bin/ls
g_wc=/usr/bin/wc
g_rm=/bin/rm
g_mv=/bin/mv

#backup dir variable
backup_dir=/root/test

#import func lib
source $(cd $(dirname $0); pwd)/commonLib.sh

#################################################

####################command inspect###################
if [ $(isBinary $g_rsync) = 'no' ]
then
    echo "rsync command must be binary";exit 1;
fi

##################create sub directory################
if [ ! -d $backup_dir ]
then
    $g_mkdir -p $backup_dir
fi

###########sync file from remote server##########
rsync_remote_host=10.0.10.97
rsync_remote_user=root
rsync_remote_module=backup_dir
rsync_local_pass_file=/root/pass #this file shoule chmod 0600 by root

rsync_var="${rsync_remote_user}@${rsync_remote_host}::${rsync_remote_module}"

$g_rsync -auz --password-file=${rsync_local_pass_file} $rsync_var $backup_dir >/dev/null

#################keep file number################
cur_num=$($g_ls $backup_dir|$g_wc -l)
all_files=($($g_ls -tr $backup_dir))

if [ $cur_num -eq 0 ]
then
    echo "no file";exit 0;
fi

last_file_d=$(getFormatDir ${all_files[0]} d)
last_file_h=$(getFormatDir ${all_files[0]} h)
first_file_h=$(getFormatDir ${all_files[$cur_num-1]} h)

if [ $cur_num -eq 29 ]
then
    if [[ $last_file_h -ne 0 || $last_file_d -ne 1 ]]
    then
        $g_rm -rf $backup_dir/${all_files[0]}
    fi
elif [[ $cur_num -gt 29 && $first_file_h -eq 18 ]]
then
    if [[ $(getFormatDir ${all_files[$(($cur_num-28))]} d) -ne 1 ]]
    then
        tmp_y=$(getFormatDir ${all_files[$((cur_num-29))]} y)
	
	tmp_m=$(getFormatDir ${all_files[$((cur_num-29))]} m)
	if [ ${#tmp_m} -eq 1 ]
        then
            tmp_m="0${tmp_m}"
        fi
	
	tmp_d=$(getFormatDir ${all_files[$((cur_num-29))]} d)
        if [ ${#tmp_d} -eq 1 ]
        then
            tmp_d="0${tmp_d}"
        fi

	$g_rm -rf $backup_dir/${tmp_y}_${tmp_m}_${tmp_d}_00
	$g_rm -rf $backup_dir/${tmp_y}_${tmp_m}_${tmp_d}_06
	$g_rm -rf $backup_dir/${tmp_y}_${tmp_m}_${tmp_d}_12
    elif [ $(getFormatDir ${all_files[$(($cur_num-28))]} d) -eq 1 ]
    then
        tmp_y=$(getFormatDir ${all_files[$((cur_num-29))]} y)

	tmp_m=$(getFormatDir ${all_files[$((cur_num-29))]} m)
	if [ ${#tmp_m} -eq 1 ]
        then
            tmp_m="0${tmp_m}"
        fi
	
	tmp_file=tmp_move_dir_for_pull_backup__
	$g_mv $backup_dir/${tmp_y}_${tmp_m}_01_18 /tmp/$tmp_file
        
	$g_rm -rf $backup_dir/${tmp_y}_${tmp_m}_*
        $g_mv /tmp/$tmp_file $backup_dir/${tmp_y}_${tmp_m}_01_18
        
	now_all_files=($($g_ls -tr $backup_dir))
	now_all_single_days=($(onlySingleDay "${now_all_files[*]}" $backup_dir))
	
	echo ${#now_all_single_days[*]}
	
	if [ ${#now_all_single_days[@]} -eq 12 ]
	then
            $g_rm -rf $backup_dir/${now_all_files[0]}
	fi
    fi
fi

exit 0;










