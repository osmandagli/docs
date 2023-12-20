# Advanced Bash

Word formatting

~~~~
#!/bin/bash
flashred=$(tput setab 7; tput setaf 1; tput blink)
red=$(tput setab 7; tput setaf 1)
none=$(tput sgr0)
echo -e $flashred"ERROR "$none$red"Something "$none
~~~~
