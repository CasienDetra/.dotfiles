#!/usr/bin/env bash

SSH_CONFIG="$HOME/.ssh/config"

# --- UI Helpers ---
BLUE="\033[1;34m"
CYAN="\033[36m"
GRAY="\033[38;5;244m"
DGRAY="\033[1;38;5;8m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# --- Functions ---

show_help() {
	echo -e "${GREEN} SSH Config Manager (scl)${RESET}"
	echo -e "${DGRAY}Usage: scl [command] [options]${RESET}\n"
	echo -e "${BLUE}Commands:${RESET}"
	printf "  ${CYAN}%-15s${RESET} %s\n" "ls" "List all hosts (default)"
	printf "  ${CYAN}%-15s${RESET} %s\n" "connect <name>" "Connect to host (alias: c)"
	printf "  ${CYAN}%-15s${RESET} %s\n" "add" "Add a new host"
	printf "  ${CYAN}%-15s${RESET} %s\n" "del <name>" "Remove a host"
	printf "  ${CYAN}%-15s${RESET} %s\n" "edit" "Open config in \$EDITOR"
	printf "  ${CYAN}%-15s${RESET} %s\n" "help, -h" "Show this help menu"
}

connect_host() {
	local target=$1
	if [[ -z "$target" ]]; then
		echo -e "${RED}󱈸 Error: Provide an alias to connect.${RESET}"
		return
	fi

	# Check if the host exists in config before trying to connect
	if grep -iq "^Host $target$" "$SSH_CONFIG"; then
		echo -e "${BLUE}󰒋 Connecting to $target...${RESET}"
		ssh "$target"
	else
		echo -e "${RED}󱈸 Error: Host '$target' not found in config.${RESET}"
	fi
}

list_hosts() {
	printf "${DGRAY}%-16s %-12s %-15s %s${RESET}\n" "Alias" "User" "Hostname" "Status"
	awk '
        { gsub(/\r/, ""); $1=$1 }
        tolower($1) == "host" && $2 !~ /[*?]/ {
            if (alias) print_record();
            alias = $2; hostname = "---"; user = "root";
        }
        tolower($1) == "hostname" { hostname = $2 }
        tolower($1) == "user" { user = $2 }
        function print_record() {
            if (alias) printf "'${BLUE}'%-16s'${RESET}' '${CYAN}'%-12s'${RESET}' '${GRAY}'%-15s'${RESET}' '${GREEN}'󰄬'${RESET}'\n", "󰒋 "alias, " "user, hostname
        }
        END { print_record() }
    ' "$SSH_CONFIG" | sort
}

add_host() {
	echo -e "${GREEN}󰐕 Create New Entry${RESET}"
	read -p "  Enter Alias: " alias
	if grep -iq "^Host $alias$" "$SSH_CONFIG"; then
		echo -e "${RED}󱈸 Error: Alias '$alias' already exists!${RESET}"
		return
	fi
	read -p "  Enter Hostname (IP): " hname
	read -p "  Enter User (root): " user
	user=${user:-root}

	echo -e "${GRAY}  Key directory: ~/.ssh/${RESET}"
	read -p "  Enter IdentityFile (id_ed25519): " keyname
	keyname=${keyname:-id_ed25519}

	{
		echo ""
		echo "Host $alias"
		echo "    HostName $hname"
		echo "    User $user"
		echo "    SetEnv TERM=xterm-256color"
		echo "    IdentityFile ~/.ssh/$keyname"
	} >>"$SSH_CONFIG"
	echo -e "${GREEN}󰄬 Added successfully.${RESET}"
}

del_host() {
	if [[ -z "$1" ]]; then
		echo -e "${RED}󱈸 Error: Provide an alias to delete.${RESET}"
		return
	fi
	sed -i "/^Host $1$/,/^$/d" "$SSH_CONFIG"
	echo -e "${YELLOW}󰆴 Removed $1 from config.${RESET}"
}

# --- Router ---
case "$1" in
add) add_host ;;
del) del_host "$2" ;;
connect | c) connect_host "$2" ;;
edit) ${EDITOR:-nano} "$SSH_CONFIG" ;;
help | -h | --help) show_help ;;
ls | "") list_hosts ;;
*)
	echo -e "${RED}󱈸 Unknown command: $1${RESET}"
	show_help
	exit 1
	;;
esac
