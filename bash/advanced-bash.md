# Advanced Bash

## Date-time

~~~
today=$(date +"%d-%m-%Y")
time=$(date +"%H:%M:%S")
printf -v d "Current User:\t%s\nDate:\t\t%s @ %s\n" $USER $today $time
echo "$d"
~~~

## Word Formatting

~~~
#!/bin/bash
flashred=$(tput setab 7; tput setaf 1; tput blink)
red=$(tput setab 7; tput setaf 1)
none=$(tput sgr0)
echo -e $flashred"ERROR "$none$red"Something "$none
~~~

## Arrays

~~~
#!/bin/bash
declare -A myarray
myarray[color]=blue
myarray["office building"]="HQ West"
echo ${myarray["office building"]} is ${myarray[color]}
myarray[1]="deneme"
myarray+="mango"
myarray[2]="apple"
echo ${myarray[@]}
myarray[0]="sıfırıncı"
echo ${myarray[0]}
~~~

## Regex

~~~
#!/bin/bash

read -p "Enter email: " email

if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}$ ]]
then
    echo "This email address looks fine: $email"
else
    echo "This email address is flawed: $email"
fi
~~~

~~~
echo -n "Your answer> "
read REPLY
if [[ $REPLY =~ ^[0-9]+$ ]]; then
    echo Numeric
else
    echo Non-numeric
fi
~~~

## While Until

~~~
#!/bin/bash
i=0
while [ $i -lt 10 ]; do
        echo i:$i
        ((i+=1))
done

j=0
until [ $j -gt 10 ]; do
        echo j:$j
        ((j++))
done
~~~

## Case

~~~
#!/bin/bash
a="deneme"
case $a in
        cat) echo "Feline";;
        dog|puppy) echo "Canine";;
        *) echo "No match";;
esac
~~~

## Functions

~~~
#!/bin/bash
function greet {
        if [[ -z $@ ]]
        then
                echo "no arguments found"
        else
                echo "hi there $1"
        fi
}

greet
~~~

## Flags

~~~
#!/bin/bash
while getopts :u:p:ab option; do
        case $option in
                u) user=$OPTARG;;
                p) pass=$OPTARG;;
                a) echo "flag A";;
                b) echo "flag B";;
                ?) echo "not known $OPTARG";;
        esac
done

echo "User: $user / Pass: $pass"
~~~

## Input

~~~
#!/bin/bash
echo "Name?"
read name

echo "What is passwd?"
read -s pass

read -p "Favorite animal? " -s animal

echo -e "\n"$name $pass $animal
~~~

~~~
#!/bin/bash
read -p "What year? [nnnn] " a
while [[ ! $a =~ [0-9]{4} ]]; do
        read -p "A year, please! [nnnn] " a
done
echo "Selected year: $a"
~~~

## Select

~~~
#!/bin/bash
select option in "cat" "dog" "quit"
do
        case $option in
                cat) echo "cats";;
                dog) echo "dogs";;
                quit) break;;
                *) echo "I am not sure"
        esac
done
~~~
