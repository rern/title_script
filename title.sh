#!/bin/bash

# Draw colored string with top-bottom lines

linecolor() {
	if [[ -z $2 ]] || (( $2 > 6 )); then
		local color='\e[0;36m%*s\e[m\n'
	else
		local color='\e[0;3'$2'm%*s\e[m\n'
	fi
	printf $color "${COLUMNS:-$(tput cols)}" '' | tr ' ' "$1"
}
textcolor() { 
	local color=6   # default
	local back=0  # default
	[[ $2 ]] && local color=$2
	[[ $3 ]] && local back=$3
	echo "$(tput setaf $color; tput setab $back)${1}$(tput setaf 7; tput setab 0)"
}

bar=$( textcolor ' . ' 6 6 )   # [   ]     (white on cyan)    - double quoted to keep spaces
info=$( textcolor ' i ' 0 3 )  # [ i ]     (black on yellow)
warn=$( textcolor ' ! ' 7 1 )  # [ ! ]     (white on red)

title() {
	local color=6
	local line='-'
	local notop=0
	local nobottom=0
	
	while :; do
		case $1 in
			-h|-\?|--help) usage; exit 1;;
			-c) local color=$2; shift;; # 1st shift
			-l) local line=$2; shift;;
			-nt) local notop=1;;        # no 'shift' for option without vale
			-nb) local nobottom=1;;
			-?*) printf 'WARN: unknown option: %s\n' "$1" >&2;;
			*) break
		esac
		# shift 1 out of argument array '$@'
		# 1.option + 1.value - shift twice
		# 1.option + 0.without vale - shift once
		shift
	done

	[[ $notop == 0 ]] && echo $( linecolor $line $color )
	echo -e "${@}" # $@ > "${@}" - preserve spaces 
	[[ $nobottom == 0 ]] && echo $( linecolor $line $color )
}
usage() {
	local t='          '
	echo
	linecolor -
	echo $bar 'Draw title with colored' $( textcolor STRING ) 'and top-bottom lines'
	linecolor -
	echo '         usage:  place this file in the same directory'
	echo '                 type command or add this line to script:' $( textcolor '. title.sh' )
	echo '       command:  title [OPTION]... STRING'
	echo
	echo '  colored line:  $( linecolor CHARACTER [color] )'
	echo 'colored string:  $( textcolor STRING [color] [background] )'
	echo
	echo 'OPTION:'
	echo "${t}"'-?     help (this)'
	echo "${t}"'-c N   N - line color'
	echo "${t}"'-l C   C - line character'
	echo "${t}"'-nt    no top line'
	echo "${t}"'-nb    no bottom line'
	echo 'Badge:'
	echo "${t}"$bar'    $bar'   
	echo "${t}"$info'    $info'   
	echo "${t}"$warn'    $warn'   
	echo 'Color code for [color], [background], N:'
	echo "${t}"$( textcolor '0 ----' 7 ) 'black'
	echo "${t}"$( textcolor '1 ----' 1 ) 'red'
	echo "${t}"$( textcolor '2 ----' 2 ) 'green'
	echo "${t}"$( textcolor '3 ----' 3 ) 'yellow'
	echo "${t}"$( textcolor '4 ----' 4 ) 'blue'
	echo "${t}"$( textcolor '5 ----' 5 ) 'magenta'
	echo "${t}"$( textcolor '6 ----' 6 ) 'cyan (default)'
	echo "${t}"$( textcolor '7 ----' 7 ) 'white'
	linecolor -
}	

[[ $# > 0 ]] && usage
