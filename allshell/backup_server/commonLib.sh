#this file is some function for pull_backup.sh

function isBinary (){
    local res="$(/usr/bin/file -i $1)"

    if [[ "$res" =~ ^.*?(charset=binary).*?$ ]]
    then
        echo yes
    else
        echo no
    fi
}

function inArray (){
    local arr=($1)
    local val=$2
    local is_in=no

    for item in ${arr[*]}
    do
        if [ $item = $val ]
        then
            is_in=yes
            break;
        fi
    done

    echo $is_in
}

function getFormatDir (){
    local L_dir=$1
    local L_format=$2

    case $L_format in
        y)
            echo "$L_dir"|/bin/sed -r 's/^([0-9]{4}).*$/\1/'
	;;
        m)
            local L_m=$(echo "$L_dir"|/bin/sed -r 's/^[0-9]{4}_([0-9]{2}).*$/\1/')
            echo "$L_m"|/bin/sed -r 's/^0([0-9])$/\1/'
	;;
        d)
            local L_d=$(echo "$L_dir"|/bin/sed -r 's/^[0-9]{4}_[0-9]{2}_([0-9]{2}).*$/\1/')
            echo "$L_d"|/bin/sed -r 's/^0([0-9])$/\1/'
	;;
        u)
            local L_date=$(echo "L_dir"|/bin/sed -r 's/^([0-9]{4})_([0-9]{2})_([0-9]{2}).*$/\1-\2-\3/')
            /bin/date -d "$L_date" "+%u"
	;;
	h)
            local L_h=$(echo "$L_dir"|/bin/sed -r 's/.*([0-9]{2})$/\1/')
            echo "$L_h"|/bin/sed -r 's/^0([0-9])$/\1/'
	;;
    esac
}

function isLeapYear (){
    local tmp_y=$1

    if [[ $(($tmp_y%4)) -eq 0 && $(($tmp_y%100)) -ne 0 ]] || [ $(($tmp_y%400)) -eq 0 ]
    then
        echo yes
    else
        echo no
    fi
}

function isLastDayOfMonth (){
    local tmp_y=$1
    local tmp_m=$2
    local tmp_d=$3
    local runyue=(1 3 5 7 8 10 12)

    if [ $(inArray "${runyue[*]}" $tmp_m) = "yes" ]
    then
        if [ $tmp_d -eq 31 ]
	then
            echo yes
	else
            echo no
	fi
    else
        if [ $tmp_m -ne 2 ]
	then
            if [ $tmp_d -eq 30 ]
	    then
                echo yes
	    else
                echo no
	    fi
	else
            if [ $(isLeapYear $tmp_y) = "yes" ]
	    then
                if [ $tmp_d -eq 29 ]
		then
                    echo yes
		else
                    echo no
		fi
	    else
                if [ $tmp_d -eq 28 ]
		then
                    echo yes
		else
                    echo no
		fi
	    fi
	fi
    fi
}

function excludeSingleDay (){
    local L_all_file=($1)
    local L_backup_dir=$2
    local tmp_num=0
    local tmp_str=''
    local tmp_arr=()

    for item in ${L_all_file[@]}
    do
        tmp_str=$(echo "$item"|/bin/sed -r 's/^(.*)_[0-9]{2}$/\1/')
        tmp_num=$(/bin/ls $L_backup_dir/${tmp_str}*|/usr/bin/wc -l)

	if [ $tmp_num -eq 4 ]
	then
            tmp_arr=("${tmp_arr[@]}" $item)
	fi
    done

    echo "${tmp_arr[*]}"
}

function onlySingleDay (){
    local L_all_file=($1)
    local L_backup_dir=$2
    local tmp_num=0
    local tmp_str=''
    local tmp_arr=()

    for item in ${L_all_file[*]}
    do
        tmp_str=$(echo "$item"|/bin/sed -r 's/^(.*)_[0-9]{2}$/\1/')
        tmp_num=$(/bin/ls -d $L_backup_dir/${tmp_str}*|/usr/bin/wc -l)

	if [ $tmp_num -ne 4 ]
	then
            tmp_arr=("${tmp_arr[@]}" $item)
	fi
    done

    echo "${tmp_arr[*]}"
}











