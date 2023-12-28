# Linux Operations

## CronJob

### Crontab Syntax
~~~~
*  *  *  *  *  --> command to execute
-- -- -- -- --  
|  |  |  |  |
|  |  |  |  +-------------------- day of weak (0-6) (Sunday=0)
|  |  |  +------------------ month (1-12)
|  |  +---------------- day of month (1-31)
|  +-------------- hour (0-23)
+------------ min (0-59)

~~~~
Example-1: /root/backup.sh script will be executed every Friday at 17:37 without checking the month, or the day of month.
~~~~
37 17 * * 5 root/backup.sh
~~~~
Example-2: /root/backup.sh script will be executed every Monday and Friday at 17:37 without checking the month, or the day of month.
~~~~
37 17 * * 1,5 root/backup.sh
~~~~
Example-3: /root/backup.sh script will be executed every 15 minutes.
~~~~
*/15 * * * * /root/backup.sh
~~~~
Example-4: /root/backup.sh script will be executed every hour. 
Note: available parameters are @hourly, @daily = @midnight (both runs at midnight), @weekly, @monthly, @yearly, @reboot
~~~~
@hourly /root/backup.sh
~~~~

### CronJob Permission

To run a CronJob user that will run the CronJob, should be in /etc/cron.allow file. /etc/cron.deny file consists of the users that are not allowed to run cronjobs.

### Creating CronJobs

To create a CronJob enter the snippet below into the command line. This will open a nano then you can enter the CronJob details and save it.

~~~
crontab -e
~~~

### Display List of CronJobs

The code below lists all of the active CronJobs for the current user
~~~
crontab -l
~~~

To check for a specific user's CronJobs

~~~
crontab -u username -l
~~~
