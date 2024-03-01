# bash script pc info

~~~
#!/bin/bash
green=$(tput setaf 2)
none=$(tput sgr0)
date=$(date +"%d-%m-%y")
free_space=$(free -h | grep "Mem" | awk '{print $4}' | sed 's/Gi/G/g')
time=$(date +"%H%M%S")
logfile_name="$time"_report.log

cat >> $logfile_name  << EOF
Quick system report for $green$USER$none
        System type:    $(uname -r)
        Bash version:   $BASH_VERSION
        Free space:     $free_space
        Files in dir:   $(ls | wc -l)
        Generated on:   $date
Copy of this info has been saved into $green$logfile_name$none
EOF
~~~
