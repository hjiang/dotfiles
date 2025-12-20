#!/bin/sh

# Power menu options
options="Lock Screen
Logout
Suspend
Shutdown
Reboot"

# Show menu and get selection
selected=$(printf "%s" "$options" | vicinae dmenu --no-section --no-metadata --no-quick-look)

# Execute action based on selection
case "$selected" in
    "Lock Screen")
        loginctl lock-session
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Suspend")
        loginctl suspend
        ;;
    "Shutdown")
        loginctl poweroff
        ;;
    "Reboot")
        loginctl reboot
        ;;
esac
