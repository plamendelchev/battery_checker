# battery_checker
Bash script that checks the system's battery at a certain interval

## Usage
```
b2tr_chckr [-D] [-t time_to_refresh] [-m battery_alert_value]
```

### Arguments 
- `-D` starts the script in daemon mode (meant for systemd)
- `-t` set a custom refresh rate
- `-m` set a custom battery level treshhold warning
