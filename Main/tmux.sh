#!/bin/sh
# shellcheck shell=sh # Written to be posix compatible
# shellcheck disable=SC2016,SC2154   # False Trigger

: '
-----------------------------------------------------------------------------------------------
|  Created by LiveEmily <d.claassen2003@outlook.com> in 2020 under the terms of GNU AGPL-3.0  |
|               Last Updated on Friday, January 29, 2021 at 04:30 AM (GMT+6)                  |
-----------------------------------------------------------------------------------------------
'

###! Script to start, configure and kill tmux sessions for Ripple Stack instance.
###! UPSTREAM: (https://github.com/Uniminin/Ripple-Auto-Installer)

# [ WARNING ]: Script Untested. Use at your own Risk!

: '
> Contributor info <
* CONTRIBUTOR: "LiveEmily"
* EMAIL: "d.claassen2003@outlook.com"
* MAINTAINERS: ["uniminin", "LiveEmily"]
'

# Don't exit the script if anything returns false
set +e

# Version #
UPSTREAM_VERSION="1.2.0"

# Name
session="Ripple"

# Colors For Prints
# RPRINT -> prints to standard error instead of standard output
alias RPRINT="printf '\\033[0;31m%s\\n''\\033[0;37m' >&2" # Red
alias GPRINT="printf '\\033[0;32m%s\\n''\\033[0;37m'"     # Green

# Command Overwrites
alias EXIT="exit"
alias READ="read -r"

: ' -Deprecated-
# Simplified File Integrity Checker by uniminin <uniminin@zoho.com> under the terms of AGPLv3
# CHECK FILE INTEGRITY

checksum_checker="true"

# Upstream File #
# tmux.sh
TMUX_SH="https://raw.githubusercontent.com/Uniminin/Ripple-Auto-Installer/master/Main/tmux.sh"

# tmux.sha1 (checksum)
TMUX_SHA1="https://raw.githubusercontent.com/Uniminin/Ripple-Auto-Installer/master/Main/tmux.sha1"

if [ "$checksum_checker" = "true" ]; then
	if [ ! -f "tmux.sha1" ]; then
		RPRINT "file integrity data not found" ; GPRINT "Fetching the latest file integrity data"
		wget -O "tmux.sha1" "$TMUX_SHA1"
		if [ ! -f "tmux.sha1" ]; then
			RPRINT "Failed to fetch the latest file integrity data" ; EXIT 1
		fi
	fi

	if [ -f "tmux.sha1" ]; then
		sha1sum -c tmux.sha1 || match="false"
		if [ "$match" = "false" ]; then
			GPRINT "Fetching the latest script, please try again..."
			wget -O "tmux.sh" "$TMUX_SH"
			EXIT 1
		fi
	else
		RPRINT "file integrity data not found" ; EXIT 1
	fi
fi
'

while [ "$#" -ge 0 ]; do
	case "$1" in
	"--new" | "-N")
		if command -v tmux >/dev/null; then
			GPRINT "Directory: "
			READ directory
			tmux new-session -c /"$USER"/"$directory"/ -s "$session" -d
			tmux send-keys "python3.5 pep.py/pep.py" C-m
			tmux send-keys "python3.6 lets/lets.py" C-m
			tmux send-keys "python3.6 avatar-server/avatar-server.py" C-m
			tmux send-keys "exec hanayo/hanayo" C-m
			tmux send-keys "exec api/api" C-m
		else
			RPRINT "Fatal: tmux is not executable on this system!"
			EXIT 1
		fi
		EXIT 0
		;;

	"--attach" | "-A")
		tmux attach-session -t "$session"
		EXIT 0
		;;

	"--kill" | "-K")
		tmux kill-session -t "$session"
		EXIT 0
		;;

	"--help" | "-H")
		GPRINT "Arguments: " \
			"    --new, -N  <directory_name>   | Create a new Ripple session." \
			"    --attach, -A                  | Reattach to the Ripple session." \
			"    --kill, -K                    | Kills the current Ripple session." \
			"    --version, -V                 | Prints the upstream version of the script." \
			"    --help, -H                    | Shows the list of all arguments including relevant informations."
		EXIT 0
		;;

	"--version" | "-V")
		GPRINT "Version: $UPSTREAM_VERSION"
		EXIT 0
		;;

	"")
		RPRINT "Fatal: No argument was provided | Try: $0 --help"
		EXIT 74
		;;

	*)
		RPRINT "Fatal: Unknown argument | Try: $0 --help"
		EXIT 74
		;;

	esac
	shift
done
