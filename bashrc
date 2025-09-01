#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

function __build_prompt {
        # Other Seperators that are available:
        # Filled Triangles \ue0b0 and \ue0b2
        # Empty Triangles \ue0b1 and \ue0b3
        # Filled Circle \ue0b4 and \ue0b6
        # Empty Circle \ue0b5 and \ue0b7
        BG_1=${1:-234}
        BG_2=${2:-198}
        FG_1=${3:-015}
        FG_2=${4:-015}
	SEPERATOR=$(printf '\ue0b0')

	echo "\[\e[48;5;${BG_1}m\]\[\e[38;5;${FG_1}m\] \u \
\[\e[38;5;${BG_1}m\]\[\e[48;5;${BG_2}m\]${SEPERATOR}\
\[\e[38;5;${FG_2}m\] \w \
\[\e[0m\]\[\e[38;5;${BG_2}m\]${SEPERATOR}\[\e[0m\] "

}

PS1=$(__build_prompt)
