#!/usr/bin/env bash
#-Metadata----------------------------------------------------#
#  Filename: DMARCHECK (v1.0.0)          (Update: 2021-11-04) #
#-Info--------------------------------------------------------#
#  Bash Script for DMARC Spoof                                #
#-Author(s)---------------------------------------------------#
#  Blay Raes ~ @ninebrainer                                   #
#-------------------------------------------------------------#





### Variable Name and Version

APPNAME="DMARCHECK"
VERSION="1.0.0#dev"



goBanner(){
echo -e "\n"
echo -e ${SORANGE}"     .___                             ${SPURPLE}            :::::::  ";
echo -e ${SORANGE}"   __| _/_____  _____ _______   ____   ${SPURPLE}          -%%%%%%%-  ";
echo -e ${SORANGE}"  / __ |/     \  __  \ _  __ \/ ___\  ${SPURPLE}         ###%%%%%%%###.";
echo -e ${SORANGE}" / /_/ |  Y Y  \/ __ \|  | \/ \  \___  ${SPURPLE}       .%%*==%%%==*%%.";
echo -e ${SORANGE}" \____ |__|_|  (____  /__|     \___  > ${SPURPLE}       .%%*-=%%%=-*%%.";
echo -e ${SORANGE}"      \/     \/     \/            \/  ${SPURPLE}        .##%%%%%%%%%##.";
echo -e ${SORANGE}"                                       ${SPURPLE}         =#-+*:**-#= ";
echo -e ${SORANGE}"                                       ${SPURPLE}        =# -#   #- #=   ";
echo -e ${SORANGE}"                                        ${SPURPLE}      =-=:*=   =*:=-=";
echo -e ${RED}"spfchck ${RESET}* Simple Bash DMARC record checker${RESET}${SPURPLE}     .:-.#-   -#.-:.     ";
echo -e ${RESET}     " ~ https://github.com/ninebrainer/DMARCHECK    ${SPURPLE}  =-+. .+-=${RESET}"
echo -e 
echo -e 
}



# ✔
# # ❌

#### Colors Output

RESET="\033[0m"			# Normal Colour
RED="\033[0;31m" 		# Error / Issues
GREEN="\033[0;32m"		# Successful       
BOLD="\033[01;01m"    	# Highlight
WHITE="\033[1;37m"		# BOLD
YELLOW="\033[1;33m"		# Warning
PADDING="  "
DPADDING="\t\t"


#### Other Colors / Status Code

LGRAY="\033[0;37m"		# Light Gray
LRED="\033[1;31m"		# Light Red
LGREEN="\033[1;32m"		# Light GREEN
LBLUE="\033[1;34m"		# Light Blue
LPURPLE="\033[1;35m"	# Light Purple
LCYAN="\033[1;36m"		# Light Cyan
SORANGE="\033[0;33m"	# Standar Orange
SBLUE="\033[0;34m"		# Standar Blue
SPURPLE="\033[0;35m"	# Standar Purple      
SCYAN="\033[0;36m"		# Standar Cyan
DGRAY="\033[1;30m"		# Dark Gray
BLACK="\e[0;30m"		# BLACK 


goBanner ## Called Banner DMARCHECK

help () {
	echo "Accepted parameters:"
	echo "Use -d along with a domain name, example sh dmarcheck.sh -d domain.com"
	echo "Null string will be detected and ignored"
	echo "Use -f along with a file containing domain names, example sh dmarcheck.sh -f domains.txt"
	echo "Note that the path provided for the file must be a valid one"
}

check_url () {
	domain=$1

	retval=0
	output=$(nslookup -type=txt _dmarc."$domain")
	case "$output" in
		*p=reject*)
			echo -e "$domain is ${GREEN}NOT vulnerable ✔${RESET} "
		;;
		*p=quarantine*)
			echo -e "$domain ${YELLOW}can be vulnerable ❌${RESET}  (email will be sent to spam)"
		;;
		*p=none*)
			echo -e "$domain is ${RED}vulnerable ❌ ${RESET} "
			retval=1
		;;
		*)
			echo -e "$domain is ${RED}vulnerable ❌${RESET} (No DMARC record found)"
			retval=1
		;;
	esac
	return $retval
}

check_file () {

		input=$1
		
		COUNTER=0
		VULNERABLES=0
		while IFS= read -r line
		do
			COUNTER=$((COUNTER=COUNTER+1))
			check_url $line
			VULNERABLES=$((VULNERABLES=VULNERABLES+$?))
		done < $input
		echo -e "\n$VULNERABLES out of $COUNTER domains are ${RED}vulnerable ${RESET}"

}

main () {

	while getopts d:f: flag
	do
		case "${flag}" in
			f) file=${OPTARG};;
			d) domain=${OPTARG};;
		esac
	done

	if [ -n "$domain" ]; then
		check_url $domain
	elif [ -f "$file" ]; then
		check_file $file
	else
		help
	fi

}


if [ $# != 2  ];then
	echo " "
        echo -e 	${RED}"❌" ${RESET} "Wrong execution"
	help
	exit 0
fi

main $@
