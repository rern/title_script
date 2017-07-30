#!/bin/bash

### title.sh
#
### Draw colored string with top-bottom lines ###
# by rern

usage() {
	local t='          '
	echo
	lcolor -
	echo $bar 'Draw title with colored' $( tcolor STRING ) 'and top-bottom lines'
	lcolor -
	echo "
         howto:  place this file in the same directory
                 $( tcolor '. title.sh' ) type command or add this line to script

         usage:  title [OPTION]... STRING

  colored line:  lcolor \"CHARACTER\" [COLOR]
  colored text:  tcolor \"STRING\" [COLOR] [BACKGROUND]
   color chart:  colorchart

inline command:  \$( tcolor \"STRING\" [COLOR] [BACKGROUND] )

STRING:          string or variables
CHARACTER:       single character for lines
OPTION:   -c N   N - color: line
${t}-ct N  N - color: line-top
${t}-cb N  N - color: line-bottom
${t}-l C   C - line:  character
${t}-lt C  C - line:  character-top
${t}-lb C  C - line:  character-bottom
${t}-nt    no line:   top
${t}-nb    no line:   bottom  
${t}-?, -h this info

Color:           code for N, COLOR, BACKGROUND
${t} 0     0 black
${t} $( tcolor 1 7 1 ) $( tcolor '--- 1' 1 ) red
${t} $( tcolor 2 0 2 ) $( tcolor '--- 2' 2 ) green
${t} $( tcolor 3 0 3 ) $( tcolor '--- 3' 3 ) yellow
${t} $( tcolor 4 7 4 ) $( tcolor '--- 4' 4 ) blue
${t} $( tcolor 5 7 5 ) $( tcolor '--- 5' 5 ) magenta
${t} $( tcolor 6 0 6 ) $( tcolor '--- 6' 6 ) cyan (default)
${t} $( tcolor 7 0 7 ) --- 7 white
Badge:           built-in variables
${t}$bar    \$bar
${t}$info    \$info
${t}$warn    \$warn
"
	lcolor -
}

lcolor() {
	local color=6
	[[ $2 ]] && color=$2
	printf "\e[38;5;${color}m%*s\e[0m\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' "$1"
}
tcolor() { 
	local color=6 back=0  # default
	[[ $2 ]] && color=$2
	[[ $3 ]] && back=$3
	echo -e "\e[38;5;${color}m\e[48;5;${back}m${1}\e[0m"
}

bar=$( tcolor ' . ' 6 6 )   # [   ]     (white on cyan)
info=$( tcolor ' i ' 0 3 )  # [ i ]     (black on yellow)
warn=$( tcolor ' ! ' 7 1 )  # [ ! ]     (white on red)

title() {
	local ctop=6
	local cbottom=6
	local ltop='-'
	local lbottom='-'
	local notop=0
	local nobottom=0
	
	while :; do
		case $1 in
			-c) ctop=$2
				cbottom=$2
				shift;; # 1st shift
			-ct) ctop=$2
				shift;;
			-cb) cbottom=$2
				shift;;
			-l) ltop=$2
				lbottom=$2
				shift;;
			-lt) ltop=$2
				shift;;
			-lb) lbottom=$2
				shift;;
			-nt) notop=1;;        # no 'shift' for option without vale
			-nb) nobottom=1;;
			-h|-\?|--help) usage
				return 0;;
			-?*) echo "$info unknown option: $1"
				echo $( tcolor 'title -h' 3 ) for information
				echo
				return 0;;
			*) break
		esac
		# shift 1 out of argument array '$@'
		# 1.option + 1.value - shift twice
		# 1.option + 0.without vale - shift once
		shift
	done

	[[ $notop == 0 ]] && echo $( lcolor $ltop $ctop )
	echo -e "${@}" # $@ > "${@}" - preserve spaces 
	[[ $nobottom == 0 ]] && echo $( lcolor $lbottom $cbottom )
}
colorchart() {
	echo
		for i in {0..255}; do
			local code=$( printf %03d $i )
			printf "\e[48;5;${i}m  \e[0m \e[38;5;${i}m$code\e[0m  "
			(( i == 7 )) || (( i == 243 )) || (( i == 255 )) && echo
			( (( i == 15 )) || (( i > 15 )) && (( i < 232 )) && (( (i-15) % 6 == 0 )) ) && echo
		done
	echo
}

yesno() { # $1 = header string; $2 = input or <enter> = ''
	title "$1"
	echo -e '  \e[0;36m0\e[m No'
	echo -e '  \e[0;36m1\e[m Yes'
	echo
	echo -e '\e[0;36m0\e[m / 1 ? '
	read -n 1 $2
	echo
}
setpwd() { # return $pwd1
	echo -e "$info Password: "
	read -s pwd1
	echo
	echo 'Retype password: '
	read -s pwd2
	echo
	if [[ $pwd1 != $pwd2 ]]; then
		echo
		echo "$info Passwords not matched. Try again."
		setpwd
	fi
}
timestart() { # timelapse: any argument
	time0=$( date +%s )
	[[ $# -ne 0 ]] && timelapse0=$( date +%s )
}
timestop() { # timelapse: any argument
	time1=$( date +%s )
	if [[ $# -eq 0 ]]; then
		timediff=$(( $time1 - $time0 ))
		stringlapse=''
	else
		timediff=$(( $time1 - $timelapse0 ))
		stringlapse=' (timelapse)'
	fi
	timemin=$(( $timediff / 60 ))
	timesec=$(( $timediff % 60 ))
	echo -e "\nDuration$stringlapse: $timemin min $timesec sec"
}

[[ $1 == -h || $1 == --help || $1 == -? ]] && usage
