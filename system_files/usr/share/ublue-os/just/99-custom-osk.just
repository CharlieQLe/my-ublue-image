toggle-osk ACTION="":
    #!/usr/bin/bash
    OPTION="{{ ACTION }}"
    source /usr/lib/ujust/ujust.sh

    stop_osk() {
        echo "Stopping any running on-screen keyboards..."
        systemctl --user stop wvkbd-deskintl.service
        systemctl --user stop wvkbd-mobintl.service
        systemctl --user stop sysboard.service
        rm $HOME/.config/systemd/user/niri.service.wants/wvkbd-deskintl.service
        rm $HOME/.config/systemd/user/niri.service.wants/wvkbd-mobintl.service
        rm $HOME/.config/systemd/user/niri.service.wants/sysboard.service
        echo "Stopped all running on-screen keyboards!"
    }

    if [ "$OPTION" == "help" ]; then
        echo "Usage: ujust toggle-osk <option>"
        echo "  <option>: Specify the option to skip the interactive prompt"
        echo "  Use 'wvkbd-deskintl' to use wvkbd's desktop layout"
        echo "  Use 'wvkbd-mobintl' to use wvkbd's mobile layout"
        echo "  Use 'sysboard' to use sysboard"
        echo "  Use 'none' to disable the on-screen keyboard"
        exit 0
    elif [ "$OPTION" == "" ]; then
        echo "Choose an option:"
        OPTION=$(ugum choose "wvkbd-deskintl" "wvkbd-mobintl" "sysboard" "none" "do nothing")
    fi

    case "$OPTION" in
        "wvkbd-deskintl")
            stop_osk
            echo "Enabling wvkbd's desktop layout as the on-screen keyboard..."
            systemctl --user add-wants niri.service wvkbd-deskintl.service
            systemctl --user start wvkbd-deskintl.service
            echo "On-screen keyboard is now set to wvkbd's desktop layout! Run \`/usr/bin/toggle-osk\` to toggle the on-screen keyboard!"
            ;;
        "wvkbd-mobintl")
            stop_osk
            echo "Enabling wvkbd's mobile layout as the on-screen keyboard..."
            systemctl --user add-wants niri.service wvkbd-mobintl.service
            systemctl --user start wvkbd-mobintl.service
            echo "On-screen keyboard is now set to wvkbd's mobile layout! Run \`/usr/bin/toggle-osk\` to toggle the on-screen keyboard!"
            ;;
        "sysboard")
            stop_osk
            echo "Enabling sysboard as the on-screen keyboard..."
            systemctl --user add-wants niri.service sysboard.service
            systemctl --user start sysboard.service
            echo "On-screen keyboard is now set to sysboard! Run \`/usr/bin/toggle-osk\` to toggle the on-screen keyboard! Alternatively, just focus a text field!"
            ;;
        "none")
            stop_osk
            ;;
        *)
            echo "No changes made."
            ;;
