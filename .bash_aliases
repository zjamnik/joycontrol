alias ll="ls -la"

jc() {
	screen -S joycontrol -X stuff "$1^M"
}

jcstart() {
	cd ~/joycontrol
	git pull --ff-only
	screen -dmS joycontrol sudo python3 run_controller_cli.py PRO_CONTROLLER -r 98:E2:55:92:E8:81
	cd
}

jcstop() {
	screen -S joycontrol -X quit
}

jcrestart() {
        jcstop
        jcstart
}

jcmacro() {
	while read -r line; do
		if [[ ${line:0:1} != "#" ]]; then
			jc "$line"
		fi
	done < "$1"
}

if screen -ls | grep joycontrol; then 
	echo "joycontrol already running, restart id needed"
else
	jcstart
fi
