#!/bin/bash
iatest=$(expr index "$-" i)

#######################################################
# SOURCED ALIAS'S AND SCRIPTS BY zachbrowne.me
#######################################################
#chamando os alias
source /etc/.bash_aliases

# Source global definitions
if [ -f /etc/bashrc ]; then
	 . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#######################################################
# EXPORTS
#######################################################

# Desabilitar o som de alerta (bell):
# Isso desabilita o som de alerta e, se a variável iatest for maior que 0, define o estilo do alerta como visível:
#
if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi

# Expandir o tamanho do Hitorioco:
# Define o tamanho máximo do arquivo de histórico e o número máximo de comandos a serem armazenados no histórico.
export HISTFILESIZE=10000
export HISTSIZE=500


# Controlar duplicatas no histórico:
# Isso evita que linhas duplicadas sejam armazenadas no histórico e ignora linhas que começam com espaço.
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Verificar o tamanho da janela:
# Atualiza as variáveis LINES e COLUMNS após cada comando, se necessário.
shopt -s checkwinsize

# Adicionar ao histórico em vez de sobrescrever:
# Isso faz com que o Bash adicione novos comandos ao histórico em vez de sobrescrevê-lo.

shopt -s histappend
PROMPT_COMMAND='history -a'

# Permitir navegação no histórico com Ctrl-S:
# Isso desabilita o controle de fluxo que impede o uso de Ctrl-S.

stty -ixon

# Ingnora maiusculas na auto-completação
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Mostra lista de auto-completação automaticamente:
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Define o editor padrão
export EDITOR=vim
export VISUAL=vim
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Alias's to change the directory
alias web='cd /var/www/html'

# Alias's to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)


#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Use the best version of pico installed
edit ()
{
	if [ "$(type -t jpico)" = "file" ]; then
		# Use JOE text editor http://joe-editor.sourceforge.net/
		jpico -nonotice -linums -nobackups "$@"
	elif [ "$(type -t nano)" = "file" ]; then
		nano -c "$@"
	elif [ "$(type -t pico)" = "file" ]; then
		pico "$@"
	else
		vim "$@"
	fi
}
sedit ()
{
	if [ "$(type -t jpico)" = "file" ]; then
		# Use JOE text editor http://joe-editor.sourceforge.net/
		sudo jpico -nonotice -linums -nobackups "$@"
	elif [ "$(type -t nano)" = "file" ]; then
		sudo nano -c "$@"
	elif [ "$(type -t pico)" = "file" ]; then
		sudo pico "$@"
	else
		sudo vim "$@"
	fi
}

# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp()
{
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
	| awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp $1 $2 && cd $2
	else
		cp $1 $2
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv $1 $2 && cd $2
	else
		mv $1 $2
	fi
}

# Create and go to the directory
mkdirg ()
{
	mkdir -p $1
	cd $1
}

#Sobe um número específico de diretórios
#up ()
#{
#	local d=""
#	limit=$1
#	for ((i=1 ; i <= limit ; i++))
#		do
#			d=$d/..
#		done
#	d=$(echo $d | sed 's/^\///')
#	if [ -z "$d" ]; then
#		d=..
#	fi
#	cd $d
#}

#Automatically do an ls after each cd
# cd ()
# {
# 	if [ -n "$1" ]; then
# 		builtin cd "$@" && ls
# 	else
# 		builtin cd ~ && ls
# 	fi
# }

# Returns the last 2 fields of the working directory
pwdtail ()
{
	pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show the current distribution
distribution ()
{
	local dtype
	# Assume unknown
	dtype="unknown"

	# First test against Fedora / RHEL / CentOS / generic Redhat derivative
	if [ -r /etc/rc.d/init.d/functions ]; then
		source /etc/rc.d/init.d/functions
		[ zz`type -t passed 2>/dev/null` == "zzfunction" ] && dtype="redhat"

	# Then test against SUSE (must be after Redhat,
	# I've seen rc.status on Ubuntu I think? TODO: Recheck that)
	elif [ -r /etc/rc.status ]; then
		source /etc/rc.status
		[ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && dtype="suse"

	# Then test against Debian, Ubuntu and friends
	elif [ -r /lib/lsb/init-functions ]; then
		source /lib/lsb/init-functions
		[ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && dtype="debian"

	# Then test against Gentoo
	elif [ -r /etc/init.d/functions.sh ]; then
		source /etc/init.d/functions.sh
		[ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && dtype="gentoo"

	# For Mandriva we currently just test if /etc/mandriva-release exists
	# and isn't empty (TODO: Find a better way :)
	elif [ -s /etc/mandriva-release ]; then
		dtype="mandriva"

	# For Slackware we currently just test if /etc/slackware-version exists
	elif [ -s /etc/slackware-version ]; then
		dtype="slackware"

	fi
	echo $dtype
}

# Show the current version of the operating system
ver ()
{
	local dtype
	dtype=$(distribution)

	if [ $dtype == "redhat" ]; then
		if [ -s /etc/redhat-release ]; then
			cat /etc/redhat-release && uname -a
		else
			cat /etc/issue && uname -a
		fi
	elif [ $dtype == "suse" ]; then
		cat /etc/SuSE-release
	elif [ $dtype == "debian" ]; then
		lsb_release -a
		# sudo cat /etc/issue && sudo cat /etc/issue.net && sudo cat /etc/lsb_release && sudo cat /etc/os-release # Linux Mint option 2
	elif [ $dtype == "gentoo" ]; then
		cat /etc/gentoo-release
	elif [ $dtype == "mandriva" ]; then
		cat /etc/mandriva-release
	elif [ $dtype == "slackware" ]; then
		cat /etc/slackware-version
	else
		if [ -s /etc/issue ]; then
			cat /etc/issue
		else
			echo "Error: Unknown distribution"
			exit 1
		fi
	fi
}

# Automatically install the needed support files for this .bashrc file
install_bashrc_support () {
    local dtype
    dtype=$(distribution)

    case $dtype in
        "redhat")
            sudo yum install -y multitail tree joe
            ;;
        "suse")
            sudo zypper install -y multitail tree joe
            ;;
        "debian")
            sudo apt-get install -y multitail tree joe
            ;;
        "gentoo")
            sudo emerge multitail tree joe
            ;;
        "mandriva")
            sudo urpmi multitail tree joe
            ;;
        "slackware")
            echo "No install support for Slackware"
            ;;
        *)
            echo "Unknown distribution"
            ;;
    esac
}

# Show current network information
#netinfo ()
#{
#	echo "--------------- Network Information ---------------"
#	/sbin/ifconfig | awk /'inet addr/ {print $2}'
#	echo ""
#	/sbin/ifconfig | awk /'Bcast/ {print $3}'
#	echo ""
#	/sbin/ifconfig | awk /'inet addr/ {print $4}'
#
#	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#	echo "---------------------------------------------------"
#}
#
## IP address lookup
#alias whatismyip="whatsmyip"
#function whatsmyip ()
#{
#	# Dumps a list of all IP addresses for every device
#	# /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';
#
#	# Internal IP Lookup
#	echo -n "Internal IP: " ; /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
#
#	# External IP Lookup
#	echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
#}
#
## View Apache logs
#apachelog ()
#{
#	if [ -f /etc/httpd/conf/httpd.conf ]; then
#		cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
#	else
#		cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
#	fi
#}
#
## Edit the Apache configuration
#apacheconfig ()
#{
#	if [ -f /etc/httpd/conf/httpd.conf ]; then
#		sedit /etc/httpd/conf/httpd.conf
#	elif [ -f /etc/apache2/apache2.conf ]; then
#		sedit /etc/apache2/apache2.conf
#	else
#		echo "Error: Apache config file could not be found."
#		echo "Searching for possible locations:"
#		sudo updatedb && locate httpd.conf && locate apache2.conf
#	fi
#}
#
## Edit the PHP configuration file
#phpconfig ()
#{
#	if [ -f /etc/php.ini ]; then
#		sedit /etc/php.ini
#	elif [ -f /etc/php/php.ini ]; then
#		sedit /etc/php/php.ini
#	elif [ -f /etc/php5/php.ini ]; then
#		sedit /etc/php5/php.ini
#	elif [ -f /usr/bin/php5/bin/php.ini ]; then
#		sedit /usr/bin/php5/bin/php.ini
#	elif [ -f /etc/php5/apache2/php.ini ]; then
#		sedit /etc/php5/apache2/php.ini
#	else
#		echo "Error: php.ini file could not be found."
#		echo "Searching for possible locations:"
#		sudo updatedb && locate php.ini
#	fi
#}
#
## Edit the MySQL configuration file
#mysqlconfig ()
#{
#	if [ -f /etc/my.cnf ]; then
#		sedit /etc/my.cnf
#	elif [ -f /etc/mysql/my.cnf ]; then
#		sedit /etc/mysql/my.cnf
#	elif [ -f /usr/local/etc/my.cnf ]; then
#		sedit /usr/local/etc/my.cnf
#	elif [ -f /usr/bin/mysql/my.cnf ]; then
#		sedit /usr/bin/mysql/my.cnf
#	elif [ -f ~/my.cnf ]; then
#		sedit ~/my.cnf
#	elif [ -f ~/.my.cnf ]; then
#		sedit ~/.my.cnf
#	else
#		echo "Error: my.cnf file could not be found."
#		echo "Searching for possible locations:"
#		sudo updatedb && locate my.cnf
#	fi
#}
#
# For some reason, rot13 pops up everywhere
#rot13 () {
#	if [ $# -eq 0 ]; then
#		tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
#	else
#		echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
#	fi
#}
#
# Trim leading and trailing spaces (for scripts)
#trim()
#{
#	local var=$@
#	var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
#	var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
#	echo -n "$var"
#}
#
#######################################################
# Set the ultimate amazing command prompt
#######################################################

alias cpu="grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf(\"%.1f\n\", usage)}'"

function __setprompt {
    local LAST_COMMAND=$? # Must come first!

    # Define colors
    local DARKGRAY="\033[1;30m"
    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local BROWN="\033[0;33m"
    local BLUE="\033[0;34m"
    local MAGENTA="\033[0;35m"
    local CYAN="\033[0;36m"
    local NOCOLOR="\033[0m"

    # Show error exit code if there is one
    if [[ $LAST_COMMAND != 0 ]]; then
        PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])"
        case $LAST_COMMAND in
            1) PS1+="General error";;
            2) PS1+="Missing keyword, command, or permission problem";;
            126) PS1+="Permission problem or command is not an executable";;
            127) PS1+="Command not found";;
            128) PS1+="Invalid argument to exit";;
            130) PS1+="Script terminated by Control-C";;
            *) PS1+="Unknown error code";;
        esac
        PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
    else
        PS1='\[\e[32m\]\u@\h:\[\e[34m\]\w\[\e[0m\] '
    fi

    # Date
    PS1+="\[${CYAN}\]($(date +%a) $(date +%b-'%-m')) \[${NOCOLOR}\]"

    # Time
    PS1+="\[${MAGENTA}\]$(date +'%-I:%M:%S %p') \[${NOCOLOR}\]"

    # User and server
    local SSH_IP=$(echo $SSH_CLIENT | awk '{ print $1 }')
    local SSH2_IP=$(echo $SSH2_CLIENT | awk '{ print $1 }')
    if [ $SSH2_IP ] || [ $SSH_IP ]; then
        PS1+="(\[${RED}\]\u@\h"
    else
        PS1+="(\[${RED}\]\u"
    fi

    # Current directory
    PS1+="\[${DARKGRAY}\]:\[${BROWN}\]\w\[${DARKGRAY}\]) "

    # Total size of files in current directory
    PS1+="(\[${GREEN}\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')\[${DARKGRAY}\]:"

    # Number of files
    PS1+="\[${GREEN}\]\$(/bin/ls -A -1 | /usr/bin/wc -l)\[${DARKGRAY}\])"

    # Skip to the next line
    PS1+="\n"

    # Prompt symbol based on user type
    if [[ $EUID -ne 0 ]]; then
        PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
    else
        PS1+="\[${RED}\]>\[${NOCOLOR}\] " # Root user
    fi

    # PS2, PS3, and PS4 for command continuation and scripting
    PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "
    PS3='Please enter a number from above list: '
    PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}

PROMPT_COMMAND='__setprompt'
