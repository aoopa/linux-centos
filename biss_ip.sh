#!/bin/bash
# Aoo validate_ip wrapper # Version 1.0.0.3
# Script Developed by Apivat Pattana-Anurak
# Checks that the parameter passed is an IP Address.
# Meant for user input validation.
# Example : sh biss_ip.sh 27.254.164.1

function validate_IP() {
        # Step 1 : Contain exactly three dots.
if [ `echo $1 | grep -o '\.' | wc -l` -ne 3 ]; then
        echo "Parameter '$1' does not look like an IP Address (does not contain 3 dots).";
        exit 1;
        # Step 2 : Contain exactly four parts, if broken down by dots.
elif [ `echo $1 | tr '.' ' ' | wc -w` -ne 4 ]; then
        echo "Parameter '$1' does not look like an IP Address (does not contain 4 octets).";
        exit 1;
else       
        # 3 All four parts are numeric.
        for OCTET in `echo $1 | tr '.' ' '`; do
                if ! [[ $OCTET =~ ^[0-9]+$ ]]; then
                        echo "Parameter '$1' does not look like in IP Address (octet '$OCTET' is not numeric).";
                        exit 1;   
        # Step 4 : All four parts are between 0 and 255.
                elif [[ $OCTET -lt 0 || $OCTET -gt 255 ]]; then
                        echo "Parameter '$1' does not look like in IP Address (octet '$OCTET' is not in range 0-255).";
                        exit 1;
                fi                     
        done
fi

####  echo "Parameter '$1' is a valid IP Address."; //หากเงื่อนไขตรวจสอบไอพีถูกต้อง จะแสดงผล
return 0;
}

validate_IP $1;

############################## Step 5 : Chk IP Validation (Range)################################
# Set DEBUG=1, in order to see it iterate through the calculations.
#DEBUG=1

MAXCDN_ARRAY="27.254.164.0/24 27.254.165.0/24 27.254.166.0/24 27.254.167.0/24 27.254.216.0/24 103.233.192.0/24 103.233.193.0/24 103.233.194.0/24 103.70.4.0/24 103.70.5.0/24 103.70.6.0/24 103.70.7.0/24 43.255.240.0/24 43.255.241.0/24 43.255.242.0/24 43.255.243.0/24 27.254.155.0/24"

IP=$1

function in_subnet {
    # Determine whether IP address is in the specified subnet.
    #
    # Args:
    #   sub: Subnet, in CIDR notation.
    #   ip: IP address to check.
    #
    # Returns:
    #   1|0
    #
    local ip ip_a mask netmask sub sub_ip rval start end

    # Define bitmask.
    local readonly BITMASK=0xFFFFFFFF

    # Set DEBUG status if not already defined in the script.
    [[ "${DEBUG}" == "" ]] && DEBUG=0

    # Read arguments.
    IFS=/ read sub mask <<< "${1}"
    IFS=. read -a sub_ip <<< "${sub}"
    IFS=. read -a ip_a <<< "${2}"

    # Calculate netmask.
    netmask=$(($BITMASK<<$((32-$mask)) & $BITMASK))

    # Determine address range.
    start=0
    for o in "${sub_ip[@]}"
    do
        start=$(($start<<8 | $o))
    done

    start=$(($start & $netmask))
    end=$(($start | ~$netmask & $BITMASK))

    # Convert IP address to 32-bit number.
    ip=0
    for o in "${ip_a[@]}"
    do
        ip=$(($ip<<8 | $o))
    done

    # Determine if IP in range.
    (( $ip >= $start )) && (( $ip <= $end )) && rval=1 || rval=0

    (( $DEBUG )) &&
        printf "ip=0x%08X; start=0x%08X; end=0x%08X; in_subnet=%u\n" $ip $start $end $rval 1>&2

    echo "${rval}"
}

for subnet in $MAXCDN_ARRAY
do
    (( $(in_subnet $subnet $IP) )) &&
        echo "IP : ${IP} Is in Range : [${subnet}]" && break
done

############################# End Script ###############################
