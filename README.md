# Bash1602Driver
A bash implementation of a driver for 16x2 LCDs for Raspberry Pi.  
Due to the nature of Bash, this script is not very speedy and is more of a hack than useful code.  
Feel free to use and extend, should work with most 16x2 LCD displays through the Raspberry Pi GPIO pins.  

# Set Up
Please set the pin numberings listed at the top of the file to the pins that you are using in your set up.  
Note: `LCD_BACKLIGHT` is the pin that the LCD **anode** is connected to. This allows for the drive program to turn the LCD Backlight on and off.  

# Usage
