#!/bin/sh
# Script basat de https://collectd.org/wiki/index.php/Plugin:haproxy-stat.sh
# Parametres de haproxy consultables a http://cbonte.github.com/haproxy-dconv/configuration-1.4.html#9.2
#
#
# Us: 
# LoadPlugin exec
# <Plugin exec>
#    Exec "haproxy:haproxy" "/etc/collectd.d/haproxy-stat.sh" "-s" "/var/run/haproxy-stat"
# </Plugin>
#
# Novembre de 2012
# Toni Comerma

sock='/var/run/haproxy-stat'
host="$(hostname -f)"
pause=10

while getopts "h:p:s:" c; do
    case $c in
         s)      sock=$OPTARG;;
         *)      echo "Usage: $0 [-s <sockfile>]";;
    esac
done
host="${COLLECTD_HOSTNAME:-$host}"
pause="${COLLECTD_INTERVAL:-$pause}"
INTERVAL=$pause
while [ $? -eq 0 ]; do
        time="$(date +%s)"
        echo 'show stat' | socat - UNIX-CLIENT:$sock \
        |while IFS=',' read pxname svname qcur qmax scur smax slim stot bin bout dreq dresp ereq econ eresp wretr wredis status weight act bck chkfail chdown lastchg downtime qlimit pid iid sid throttle lbtot tracked type rate rate_lim rate_max check_status check_code check_duration hrsp_1xx hrsp_2xx hrsp_3xx hrsp_4xx hrsp_5xx hrsp_other hanafail req_rate req_rate_max req_tot cli_abrt srv_abrt
        do
          if [ "$svname" != "svname" -a ! -z "$svname" ]
            then
              if [ "$svname" = 'FRONTEND' ]
              then
                echo "PUTVAL $host/haproxy-$pxname-$svname/gauge-req_rate interval=$INTERVAL $time:${req_rate:-0}"
                echo "PUTVAL $host/haproxy-$pxname-$svname/counter-ereq interval=$INTERVAL $time:${ereq:-0}"
              fi
              echo "PUTVAL $host/haproxy-$pxname-$svname/bytes-bin interval=$INTERVAL $time:${bin:-0}"
              echo "PUTVAL $host/haproxy-$pxname-$svname/bytes-bout interval=$INTERVAL $time:${bout:-0}"
              echo "PUTVAL $host/haproxy-$pxname-$svname/gauge-scur interval=$INTERVAL $time:${scur:-0}"
              echo "PUTVAL $host/haproxy-$pxname-$svname/gauge-rate interval=$INTERVAL $time:${rate:-0}"
              if [ "$svname" != 'FRONTEND' ]
              then
                echo "PUTVAL $host/haproxy-$pxname-$svname/counter-eresp interval=$INTERVAL $time:${eresp:-0}"
                echo "PUTVAL $host/haproxy-$pxname-$svname/counter-econ interval=$INTERVAL $time:${econ:-0}"
              fi
          fi
        done
        sleep $pause
done

