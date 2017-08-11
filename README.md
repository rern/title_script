title.sh script
---

For installation script (BASH)  
- drawing colored string with top-bottom lines
- yes/no dialog
- password dialog
- timer

![screen](https://github.com/rern/title_script/blob/master/title.png)

```
         usage:  place 'title.sh' file in the same directory
                 type command or add this line to script: . title.sh
                 
         title:  title [OPTION]... STRING

  colored line:  lcolor 'CHARACTER' [color]
  colored text:  tcolor "STRING" [color] [background]
inline command:  $( tcolor "STRING" [color] [background] )
   color chart:  colorchart

        yes/no:  yesno "STRING" [VARNAME]
      password:  setpwd [VARNAME]

STRING:          string or variables
CHARACTER:       single character for lines
OPTION:   -c N   N - color: line
          -ct N  N - color: line-top
          -cb N  N - color: line-bottom
          -l C   C - line:  character
          -lt C  C - line:  character-top
          -lb C  C - line:  character-bottom
          -nt    no line:   top
          -nb    no line:   bottom
          -?, -h this info
Color:           code for N, [color], [background]
          0 ---- black
          1 ---- red
          2 ---- green
          3 ---- yellow
          4 ---- blue
          5 ---- magenta
          6 ---- cyan (default)
          7 ---- white
Badge:           built-in variables
          [   ]  $bar
          [ i ]  $info
          [ ! ]  $warn
```
