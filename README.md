# battery_checker
Bash script that checks the system's battery at a certain interval

## Usage
```
b2tr_chckr [-D] [-t time_to_refresh] [-m battery_alert_value]
```

## Arguments 
- `-D` starts the script in daemon mode (meant for systemd)
- `-t` set a custom refresh rate
- `-m` set a custom battery level treshhold warning

## Systemd
The `-D` options is meant to be used when the script is controlled by systemd. 
The file `battery_checker.service` is a basic service that can be used for this purpose. 

Example log:
```
$ systemctl status battery_checker
● battery_checker.service - Bash script that checks the system's battery at a certain interval
   Loaded: loaded (/etc/systemd/system/battery_checker.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-04-23 21:41:44 EEST; 9min ago
 Main PID: 610 (bash)
   CGroup: /system.slice/battery_checker.service
           ├─610 /usr/local/bin/bash /usr/local/sbin/battery_checker -D
           └─621 sleep 1800

Apr 23 21:41:44 rod systemd[1]: Started Bash script that checks the system's battery at a certain interval.
Apr 23 21:41:44 rod bash[610]: DATE='Fri Apr 23 21:41:44 EEST 2021' BATT_PERC='4' BATT_STATUS='Charging'
```
