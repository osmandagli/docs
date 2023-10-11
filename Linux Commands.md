---
tags: [Linux Operations and Commands]
title: Linux Commands
created: '2023-10-10T08:13:06.032Z'
modified: '2023-10-10T11:38:17.539Z'
---

# Linux Commands

## awk

Prints the file.txt
~~~~
awk {print} file.txt or cat file.txt | awk {print}
~~~~
Displays the line numbers for the file.txt file
~~~~
awk {print NR} file.txt
~~~~
Displays lines 3 to 6. Note: $0 prints the whole line
~~~~
awk 'NR==3, NR==6 {print NR,$0}' file.txt
~~~~
Prints '-' between line number and first element
~~~~
awk '{print NR,"- " $1 }' file.txt
~~~~
Prints the total number of lines
~~~~
awk 'END {print NR}' file.txt
~~~~
Prints the lines with more than 10 character
~~~~
awk 'length($0) > 10' file.txt
~~~~
Check for a spesific text in any specific column. Code prints the $2^{nd}$ line if the word equals to "word"
~~~~
awk '{if($1=="word") print $0; }' file.txt
~~~~
Using both variable and text with awk in 2 versions
~~~~
export date=$(date +"%d-%m-%y")
echo |  awk '{print "Date is: '$date'"}'
~~~~
~~~~
echo |  awk -v date=$(date +"%d-%m-%y") '{printf "Date is: %s\n", date}'
~~~~


