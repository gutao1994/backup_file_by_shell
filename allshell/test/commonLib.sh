function isLeapYear (){
    local tmp_y=$1

    if [[ $(($tmp_y%4)) -eq 0 && $(($tmp_y%100)) -ne 0 ]] || [ $(($tmp_y%400)) -eq 0 ]
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


function goNextSixHour (){
    local L_date="$1"
    local L_after_date=""

    local L_y=$(echo "$L_date"|/bin/sed -r 's/^([0-9]{4})-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$/\1/')

    local L_m=$(echo "$L_date"|/bin/sed -r 's/^[0-9]{4}-([0-9]{2})-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$/\1/')
    L_m=$(echo "$L_m"|/bin/sed -r 's/^0([0-9])$/\1/')

    local L_d=$(echo "$L_date"|/bin/sed -r 's/^[0-9]{4}-[0-9]{2}-([0-9]{2}) [0-9]{2}:[0-9]{2}:[0-9]{2}$/\1/')
    L_d=$(echo "$L_d"|/bin/sed -r 's/^0([0-9])$/\1/')

    local L_h=$(echo "$L_date"|/bin/sed -r 's/^[0-9]{4}-[0-9]{2}-[0-9]{2} ([0-9]{2}):[0-9]{2}:[0-9]{2}$/\1/')

    L_h=$(echo "$L_h"|/bin/sed -r 's/^0([0-9])$/\1/')
    
    local L_min=$(echo "$L_date"|/bin/sed -r 's/^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:([0-9]{2}):[0-9]{2}$/\1/')

    local L_s=$(echo "$L_date"|/bin/sed -r 's/^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:([0-9]{2})$/\1/')

    if [ $(($L_h+6)) -ge 24 ]
    then
        L_h=$(($L_h+6-24))
        
	if [ $(isLastDayOfMonth $L_y $L_m $L_d) = 'yes' ]
	then
            L_d="01"

	    if [ $L_m -eq 12 ]
	    then
                L_m="01"
		L_y=$(($L_y+1))
            else
	        L_m=$(($L_m+1))
	    fi
	else
	    L_d=$(($L_d+1))
	fi
    else
        L_h=$(($L_h+6))
    fi
    
    if [ ${#L_h} -eq 1 ]
    then
        L_h="0${L_h}"
    fi
 
    if [ ${#L_d} -eq 1 ]
    then
        L_d="0${L_d}"
    fi
    
    if [ ${#L_m} -eq 1 ]
    then
        L_m="0${L_m}"
    fi

    L_after_date="${L_y}-${L_m}-${L_d} ${L_h}:${L_min}:${L_s}"

    echo "$L_after_date"
}

















