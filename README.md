collectd-haproxy
================

haproxy collectd plugin

Bash shell to get performance information from haproxy. Based on example plugin from https://collectd.org/wiki/index.php/Plugin:haproxy-stat.sh by Oleg Blednov.
License: GPLv3 (http://www.gnu.org/licenses/gpl.html)

Improvements from original
  - Uses exported variables from collectd (so version >= 4.9 is required)
  - Uses types already defined in types.db to make easier to set up, even though this forces some weird names
  - More parameters fed to collectd
  - Gathering info from FRONTEND, BACKEND and real servers

Note: Just tested using graphite as writing plugin
