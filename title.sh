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
         usage:  place this file in the same directory
                 $( tcolor '. title.sh' ) type command or add this line to script

         title:  title [OPTION]... STRING

  colored line:  lcolor \"CHARACTER\" [color]
  colored text:  tcolor \"STRING\" [color] [background]
   color chart:  colorchart

inline command:  \$( tcolor \"STRING\" [color] [background] )

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
Color:           code for N, [color], [background]
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
	[[ $2 ]] && local color=$2
	printf "\e[38;5;${color}m%*s\e[0m\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' "$1"
}
tcolor() { 
	local color=6   # default
	local back=0  # default
	[[ $2 ]] && local color=$2
	[[ $3 ]] && local back=$3
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
			-c) local ctop=$2
				local cbottom=$2
				shift;; # 1st shift
			-ct) local ctop=$2
				shift;;
			-cb) local cbottom=$2
				shift;;
			-l) local ltop=$2
				local lbottom=$2
				shift;;
			-lt) local ltop=$2
				shift;;
			-lb) local lbottom=$2
				shift;;
			-nt) local notop=1;;        # no 'shift' for option without vale
			-nb) local nobottom=1;;
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
			code=$( printf %03d $i )
			printf "\e[48;5;${i}m  \e[0m \e[38;5;${i}m$code\e[0m  "
			(( i == 7 )) || (( i == 243 )) || (( i == 255 )) && echo
			( (( i == 15 )) || (( i > 15 )) && (( i < 232 )) && (( (i-15) % 6 == 0 )) ) && echo
		done
	echo
}

[[ $1 == -h || $1 == --help || $1 == -? ]] && usage
