#!/bin/bash

# -----------------------------------------------------------------------
# Author: 	Michael DeGuzis
# Git:		https://github.com/ProfessorKaos64/SteamOS-Tools
# Scipt Name:	install-desktop-software.sh
# Script Ver:	0.2.3
# Description:	Adds various desktop software to the system for a more
#		usable experience. Although this is not the main
#		intention of SteamOS, for some users, this will provide
#		some sort of additional value
#
# Usage:	./steamos-stats.sh -type [basic|full]
# Warning:	You MUST have the Debian repos added properly for
#		Installation of the pre-requisite packages.
#
# ------------------------------------------------------------------------

# Set vars
type="$1"
options="$2"
apt_mode="install"
uninstall="no"

show_help()
{

clear
cat << EOF
You have two options with this script:

Basic
------------------------------------------------------------
standard debian desktop utilities: archive roller (TODO)

Full
------------------------------------------------------------
Extra software, such as libreoffice (TODO)

For a complete list, type:
'./install-debian-software --list | less'

Press enter to continue...

EOF

read -n 1
printf "Continuing...\n"
clear

}

# Show help if requested

if [[ "$1" == "--help" ]]; then
        show_help
	exit 0
fi

install_software()
{

	# Set mode and proceed based on main() choice
        if [[ "$options" == "uninstall" ]]; then
                apt_mode="remove"
	else
		apt_mode="install"
        fi

        # set software type
        if [[ "$type" == "basic" ]]; then
                # add basic software to temp list
                software_list="basic-software.txt"
        elif [[ "$type" == "full" ]]; then
                # add full softare to temp list
                software_list="basic-software.txt"
        fi

	# Alchemist repos
	# None here for now

	# Wheezy-only software
	sudo apt-get -t wheezy $apt_mode `cat $software_list`

}

show_warning()
{
        clear
        printf "\nIn order to run this script, you MUST have had enabled the Debian\n"
        printf "repositories! If you wish to exit, please press CTRL+C now..."
        printf "\n\n type './install-debian-software --help' for assistance.\n"

        read -n 1
        printf "Continuing...\n"
        sleep 1s
}

main()
{

        # generate software listing based on type
        get_software

	if [[ "$type" == "basic" ]]; then

		if [[ "$options" == "uninstall" ]]; then
        		uninstall="yes"

                elif [[ "$options" == "list" ]]; then
                        # show listing from software.temp
                        clear
                        cat software.temp | less
			rm -f software.temp
			exit
		fi

		show_warning
		install_software

	elif [[ "$type" == "full" ]]; then

		if [[ "$options" == "uninstall" ]]; then
                        uninstall="yes"

                elif [[ "$options" == "list" ]]; then
                        # show listing from software.temp
                        clear
			cat software.temp | less
			rm -f software.temp
			exit
                fi

		show_warning
		install_software
	fi
}

# Start main function
main
