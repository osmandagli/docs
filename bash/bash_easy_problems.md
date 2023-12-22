# Bash Easy Problem

~~~
Given a text file file.txt that contains a list of phone numbers (one per line), write a one-liner bash script to print all valid phone numbers.

You may assume that a valid phone number must appear in one of the following two formats: (xxx) xxx-xxxx or xxx-xxx-xxxx. (x means a digit)

You may also assume each line in the text file must not contain leading or trailing white spaces.

Example:

Assume that file.txt has the following content:

987-123-4567
123 456 7890
(123) 456-7890
Your script should output the following valid phone numbers:

987-123-4567
(123) 456-7890
~~~

Easy Way

~~~
grep  -e "^[0-9]\{3\}-[0-9]\{3\}-[0-9]\{4\}$" -e "^([0-9]\{3\}) [0-9]\{3\}-[0-9]\{4\}$" file.txt
~~~

Very hard way

~~~
#!/bin/bash

while read phoneNumber
do
        if [[ ${phoneNumber:0:1} =~ [0-9]$ ]]
        then
                if [[ ${#phoneNumber} -eq 12 ]]
                then
                        if [[ ${phoneNumber:0:3} =~ [0-9]$ && ${phoneNumber:4:3} =~ [0-9]$ && ${phoneNumber:8:4} =~ [0-9]$ && ${phoneNumber:3:1} == "-" && ${phoneNumber:7:1} == "-" ]]
                        then
                                echo $phoneNumber
                        fi
                fi
        else
                if [[ ${#phoneNumber} -eq 14 ]]
                then
                        if [[ ${phoneNumber:1:3} =~ ^[0-9]+$ && ${phoneNumber:6:3} =~ [0-9]$ && ${phoneNumber:10:4} =~ [0-9]$ && ${phoneNumber:0:1} == "(" && ${phoneNumber:4:1} == ")" && ${phoneNumber:9:1} == "-" && ${phoneNumber:5:1} == " " ]]
                        then
                                echo $phoneNumber
                        fi
                fi
        fi
done < file.txt
#if [[ ${phoneNumber:1:3} =~ [0-9]$ && ${phoneNumber:6:3} =~ [0-9]$ && ${phoneNumber:10:4} =~ [0-9]$ && ${phoneNumber:0:1} == ")" && ${phoneNumber:4:1} == ")" && ${phoneNumber:9:1} == "-" && ${phoneNumber:5:1} == " " ]]
~~~

------------------

Number of words in a file with a reverse order

~~~
cat words.txt | tr -s ' ' '\n' | sort | uniq -c | sort -nr | awk '{print $2 " " $1}'
~~~

-------------------------

10th line

~~~
tail -n +10 file.txt |head -1 
~~~

    awk "NR==10" file.txt

------------------------

transpose of a file

~~~
for i in $(seq 1 $(head -1 file.txt | wc -w)); do echo $(awk "{print \\$$i}" file.txt) ; done;
~~~

how to handle big numbers

    read n
    declare -i sum
    sum=0
    
    for i in $(seq 1 $n)
    do
        read number
        sum=$( bc -l  <<< "$sum+$number" )
    done
    declare -i average
    printf "%.3f" $( bc -l <<< "$sum/$n" )
