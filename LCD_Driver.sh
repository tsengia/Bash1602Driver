#!/bin/bash

# Many thanks to: https://www.raspberrypi-spy.co.uk/2012/07/16x2-lcd-module-control-using-python/

# Below are GPIO pin mappings. Note, using BCM pin labels/numbering
# Change these values according to your configuration
LCD_RS=25
LCD_E=17
LCD_D4=24
LCD_D5=23
LCD_D6=22
LCD_D7=18
LCD_BACKLIGHT=8


# These are not pins, these are constants, don't change these
LCD_WIDTH=16
LCD_CHR=1
LCD_CMD=0

LCD_LINE1=0x80
LCD_LINE2=0xC0

# The below variables are measured in seconds.
# I have set them to 0 because bash execution usually takes well over milliseconds in time, but if you are having difficulties you can try changing the values. (try 0.0005 and/or 0.001)
E_PULSE=0.0000
E_DELAY=0.0000

doClear=1

usage() {
	echo "
	LCD_Driver\n
	Usage:		./LCD_Driver.sh [-p ( 1 | 0 )] [-c ( 1 | 0 )] [TEXT]
	
	-p [VALUE]		Turn the LCD Backlight on (1) or off (0). If not specified, no changes are made to the current state of the LCD Backlight pin.
	-c [VALUE]		If VALUE is 0, do not clear the display. If VALUE is 1, clear the display. Default is 1 (default is clear the display).
	
	Author: ExpandingDev
	Issues, bugs, suggestions: https://github.com/ExpandingDev/Bash1602Driver
	";
	exit 0
}

toggle_enable() {
	sleep $E_DELAY
	gpio -g write $LCD_E 1
	sleep $E_PULSE
	gpio -g write $LCD_E 0
	sleep $E_DELAY
}

# Sets all of the data pins to 0
dataLow() {
	gpio -g write $LCD_D4 0
	gpio -g write $LCD_D5 0
	gpio -g write $LCD_D6 0
	gpio -g write $LCD_D7 0
}

# The below function takes two args, the first is a number/byte and the second is a 1 or 0 for mode (cmd or data mode)
writeByte() {
	gpio -g write $LCD_RS $2

	dataLow
	# High bits
	if [ $(( ($1 & 0x10) == 0x10)) -eq 1 ]; then gpio -g write $LCD_D4 1 ; fi
	if [ $(( ($1 & 0x20) == 0x20)) -eq 1 ]; then gpio -g write $LCD_D5 1 ; fi
	if [ $(( ($1 & 0x40) == 0x40)) -eq 1 ]; then gpio -g write $LCD_D6 1 ; fi
	if [ $(( ($1 & 0x80) == 0x80)) -eq 1 ]; then gpio -g write $LCD_D7 1 ; fi
	toggle_enable

	dataLow
	# Low bits
	if [ $(( ($1 & 0x01) == 0x01)) -eq 1 ]; then gpio -g write $LCD_D4 1 ; fi
	if [ $(( ($1 & 0x02) == 0x02)) -eq 1 ]; then gpio -g write $LCD_D5 1 ; fi
	if [ $(( ($1 & 0x04) == 0x04)) -eq 1 ]; then gpio -g write $LCD_D6 1 ; fi
	if [ $(( ($1 & 0x08) == 0x08)) -eq 1 ]; then gpio -g write $LCD_D7 1 ; fi
	toggle_enable
}

lcdOn() {
	gpio -g write $LCD_BACKLIGHT 1
}

lcdOff() {
	gpio -g write $LCD_BACKLIGHT 0
}

clearLCD() {
	writeByte 0x01 $LCD_CMD
}

initPins() {
	gpio -g mode $LCD_RS out
	gpio -g mode $LCD_E out
	gpio -g mode $LCD_D4 out
	gpio -g mode $LCD_D5 out
	gpio -g mode $LCD_D6 out
	gpio -g mode $LCD_D7 out
	gpio -g mode $LCD_BACKLIGHT out
}

resetLCD() {
	writeByte 0x33 $LCD_CMD
	writeByte 0x32 $LCD_CMD
	writeByte 0x06 $LCD_CMD
	writeByte 0x0C $LCD_CMD
	writeByte 0x28 $LCD_CMD
	sleep $E_DELAY
}

writeString() {
 	for i in $(seq 1 "${#1}"); do
	  code=`printf "%d" \'"${1:i-1:1}"`
	  # for some reason, the lcd doesn't like the usual code for the space (ASCII 32 dec.) and instead likes 0x20 (https://www.openhacks.com/uploadsproductos/eone-1602a1.pdf)
	  if [ $(( $code == 32 )) -eq 1 ]; then
		writeByte 0x20 $LCD_CHR
	  else
		writeByte $code $LCD_CHR
	  fi
	done
}

initPins
setPower=2
while getopts "p:c" o; do
	case "${o}" in
		p)
			setPower=${OPTARG}
			((setPower == 0 || setPower == 1)) || usage
			;;
		c)
			doClear=1
			;;
		*)
			usage
			;;
	esac
done

resetLCD

if [ $doClear -eq 1 ]; then
	clearLCD
fi

if [ $setPower -eq 2 ]; then
	#Do nothing as the user hasn't specified the flag
else
	gpio -g write $LCD_BACKLIGHT $setPower
fi

writeByte $LCD_LINE2 $LCD_CMD
writeString "$1"
