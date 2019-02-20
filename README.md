# Bash1602Driver
A bash implementation of a HD44780 driver for 16x2 LCDs for Raspberry Pi.  
Due to the nature of Bash, this script is not very speedy and is more of a hack than useful code.  
Feel free to use and extend, should work with most HD44780 16x2 LCD displays through the Raspberry Pi GPIO pins.  

# Set Up
Please set the pin numberings listed at the top of the file to the pins that you are using in your set up.  
Note: `LCD_BACKLIGHT` is the pin that the LCD **anode** is connected to. This allows for the drive program to turn the LCD Backlight on and off.  

# Usage
>LCD_Driver
>
>	Usage:		./LCD_Driver.sh [-p ( 1 | 0 )] [-c ( 1 | 0 )] [-l ( 1 | 2 )] [-t TEXT]
>	
>	-p [VALUE]		Turn the LCD Backlight on (1) or off (0). If not specified, no changes are made to the current state of the LCD Backlight pin.
>	-c [VALUE]		If VALUE is 0, do not clear the display. If VALUE is 1, clear the display. Default is 1 (default is clear the display).
>	-t [TEXT]		Will print the specified text (note: it is recommended that you double quote your string) to the display.
>	-l [VALUE]		Select the line that the text will be printed to. Default is line 1;
>
>If the -t option is not used, input from stdin will be printed to the LCD display.
>
>Author: ExpandingDev
>Issues, bugs, suggestions: https://github.com/ExpandingDev/Bash1602Driver