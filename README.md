# Purpose
This project is a small demo of [phusion baseimage](https://github.com/phusion/baseimage-docker).

# Problems
1. `runit` does not seem to reap orphan processes.  Look at `service1`, which starts a subshell by calling `bash /usr/bin/loop.sh`.  If you run `sv stop service1`, you will notice that the subshell process is attached to process 1, but not reaped.

Here is an example output
```bash
# Before stopping service1
root@ee51a8a4ce38:/# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 09:36 ?        00:00:00 /usr/bin/python3 -u /sbin/my_init
root         8     1  0 09:36 ?        00:00:00 /usr/bin/runsvdir -P /etc/service
root         9     8  0 09:36 ?        00:00:00 runsv sshd
root        10     8  0 09:36 ?        00:00:00 runsv service2
root        11     8  0 09:36 ?        00:00:00 runsv syslog-ng
root        12     8  0 09:36 ?        00:00:00 runsv cron
root        13     8  0 09:36 ?        00:00:00 runsv syslog-forwarder
root        14     8  0 09:36 ?        00:00:00 runsv service1
root        15    11  0 09:36 ?        00:00:00 syslog-ng -F -p /var/run/syslog-ng.pid --no-caps
root        16    12  0 09:36 ?        00:00:00 /usr/sbin/cron -f
root        17    13  0 09:36 ?        00:00:00 tail -F -n 0 /var/log/syslog
root        19    14  0 09:36 ?        00:00:00 /bin/bash ./run
root        21    19  0 09:36 ?        00:00:00 bash /usr/bin/loop.sh
root       105     0  0 09:36 ?        00:00:00 bash
root       517    21  0 09:38 ?        00:00:00 sleep 1
root       518   105  0 09:38 ?        00:00:00 ps -ef

# After stopping service1
root@ee51a8a4ce38:/# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 09:36 ?        00:00:00 /usr/bin/python3 -u /sbin/my_init
root         8     1  0 09:36 ?        00:00:00 /usr/bin/runsvdir -P /etc/service
root         9     8  0 09:36 ?        00:00:00 runsv sshd
root        10     8  0 09:36 ?        00:00:00 runsv service2
root        11     8  0 09:36 ?        00:00:00 runsv syslog-ng
root        12     8  0 09:36 ?        00:00:00 runsv cron
root        13     8  0 09:36 ?        00:00:00 runsv syslog-forwarder
root        14     8  0 09:36 ?        00:00:00 runsv service1
root        15    11  0 09:36 ?        00:00:00 syslog-ng -F -p /var/run/syslog-ng.pid --no-caps
root        16    12  0 09:36 ?        00:00:00 /usr/sbin/cron -f
root        17    13  0 09:36 ?        00:00:00 tail -F -n 0 /var/log/syslog
root        21     1  0 09:36 ?        00:00:00 bash /usr/bin/loop.sh # -----> Orphan
root       105     0  0 09:36 ?        00:00:00 bash
root       599    21  0 09:38 ?        00:00:00 sleep 1
root       600   105  0 09:38 ?        00:00:00 ps -ef
```

My question on stackoverflow: http://stackoverflow.com/questions/31668752/does-runit-reap-orphan-processes
