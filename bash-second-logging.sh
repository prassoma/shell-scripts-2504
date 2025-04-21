#! /bin/bash

# /etc/bash.bash_logout
#
# Time-stamped bash history logging
# by Craig Sanders <cas@taz.net.au> 2008
#
# This script is public domain.  Do whatever you want with it.

exec >& /dev/null

# LOGDIR must already exist and must be mode 1777 (same as /tmp)
# put it somewhere easily overlooked by script-kiddies.  /var/log 
# is a bad location because slightly-brighter-than-average SK's will
# often 'rm -rf /var/log' to cover their tracks.
LOGDIR='/var/tmp/.history'

[ -d "$LOGDIR" ] || exit 0

# Get current user name and who they logged in as.
CNAME=$(id -u -n)
LNAME=$(who am i | awk '{print $1}')
NAME="$LNAME--$CNAME"

# Get the TTY
TTY=$(tty)

# get the hostname and ip they logged in from
# short (non-fqdn) hostname:
RHOST_NAME=$(who -m  | awk '{print $5}' | sed -r -e 's/[()]|\..*//g')
# or full hostname:
#RHOST_NAME=$(who -m  | awk '{print $5}' | sed -r -e 's/[()]//g')

# if no RHOST_NAME, then login was on the console.
echo "$RHOST_NAME" | grep -q '[:/]' && RHOST_NAME="console"

# get the IP address
RHOST_IP=$(who -m --ips | awk '{print $5}')
echo "$RHOST_IP" | grep -q '[:/]' && RHOST_IP="console"

RHOST=$(echo "$RHOST_NAME--$RHOST_IP")

WHERE="$RHOST--$TTY"
WHERE=$(echo "$WHERE" | sed -e 's/\//-/g' -e 's/^-//')

# Filenames will be of the form:
# $LOGDIR/cas--root--localhost--127.0.0.1---dev-pts-1
# Ugly, but useful/informative. This example shows I logged in as cas
# from localhost, sudo-ed to root, and my tty was /dev/pts/1
HISTLOG="$LOGDIR/$NAME--$WHERE"


# Optionally rotate HISTLOG on each logout, otherwise new history
# sessions just get appended.
#[ -e "$HISTLOG" ] && savelog -l -c 21 -q $HISTLOG > /dev/null 2>&1

# Log some easily parseable info as a prelude, including the current
# history settings (an unusual HISTFILE or zero HISTSIZE setting is
# suspicious and worthy of investigation)

cat <<__EOF__ >> "$HISTLOG"

### TIME ### $(date +'%a,%Y-%m-%d,%H:%M:%S')
### FROM ### $RHOST_NAME,$RHOST_IP,$TTY
### USER ### $LNAME,$CNAME
### WHOM ### $(who -m)
### HIST ### $HISTFILE,$HISTSIZE

__EOF__


# Setting HISTTIMEFORMAT seems to be buggy. bash man page says it uses
# strftime, but all it seems to care about is whether it's set or not -
# 'history -a' always uses seconds since epoch, regardless of what it is
# set to.

HISTTIMEFORMAT="%s"
history -a "$HISTLOG"


# Now write history as normal (this seems buggy too. bash used to always
# write $HISTFILE anyway, but now it won't do it if you've already run
# 'history -a')

unset HISTTIMEFORMAT
history -w