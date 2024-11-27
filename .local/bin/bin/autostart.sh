#! /bin/bash
dunst &
#protonmail-bridge --no-window &
#lxpolkit &
xss-lock -- lock1 &
wifi() {
  wifiperc="$(grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70) "%" }')"
  echo -ne "${wifiperc}"
}
eth() {
    eth="$(sed "s/down/ /;s/up//" /sys/class/net/e*/operstate 2>/dev/null)"
    echo -ne "${eth}"
}
vol(){
    mix=`amixer get Master | tail -1`
    vol="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
    if [[ $mix == *\[off\]* ]]; then
      echo -e " Muted"
    elif [[ $mix == *\[on\]* ]]; then
      echo -e " ${vol}%"
    else
      echo -e "VOL: ---"
    fi
}

dte(){
  dte="$(date +"%A, %B %d | 🕒 %H:%M %Z")"
  echo -e "$dte"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "🖪 $mem"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "💻 $cpu% cpu"
}
bat() {
  status="$(cat /sys/class/power_supply/ADP0/online)"
  battery="$(cat /sys/class/power_supply/BAT0/capacity)"
  timer="$(acpi -b | grep "Battery" | awk '{print $1}' | cut -c 1-1)"
  if [ "${status}" == 1 ]; then
    echo -ne " ${battery}% "
  else
    echo -ne " ${battery}%"
  fi
}

while true; do
    xsetroot -name "$(eth) $(wifi) | $(vol) | $(cpu) | $(mem) | $(bat)| $(dte)"
     sleep 10s    # Update time every ten seconds
done &
