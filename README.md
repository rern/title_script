title.sh script
---

BASH script for drawing colored string with top-bottom lines  

![screen](https://github.com/rern/title_script/blob/master/title.png)

```
         usage:  place 'title.sh' file in the same directory
                 type command or add this line to script: . title.sh
                 
       command:  title [OPTION]... STRING
              :  linecolor CHARACTER [color]
              :  textcolor STRING [color] [background]
              
inline command:  $( textcolor STRING [color] [background] )

STRING:          quoted or unquote strings, variables (as of 'echo')
CHARACTER:       single character for lines
OPTION:   -?     help (this)
          -c N   N - line color
          -l C   C - line character
          -nt    no top line
          -nb    no bottom line
Color:           code for [color], [background], N
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
