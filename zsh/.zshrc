# History Information
HISTFILE=$HOME/.cache/zsh/histfile
HISTSIZE=1000
SAVEHIST=100000

# Emacs Mode for key binds
bindkey -e

# Auto Complete Modes
zstyle :compinstall filename '/home/jeffzha/.config/zsh/.zshrc'
autoload -Uz compinit
compinit

# Editor Integration for long commands
# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Enable fzf integration
source <(fzf --zsh)

# Prompt Configuration
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
	SEPERATOR=${5:-$'\ue0b0'}

	echo "%K{${BG_1}}%F{${FG_1}} %n %F{${BG_1}}%K{${BG_2}}${SEPERATOR}%F{${FG_2}} %~ %k%F{${BG_2}}${SEPERATOR}%f "
}

function __build_rprompt {
	SEPERATOR=$'\ue0b2'
	echo "%(?.%F{046}.%F{208})${SEPERATOR}%(?.%K{046}.%K{208})%(?.%F{000}.%F{015}) %? %f%k"
}

export PROMPT=$(__build_prompt)
#export RPROMPT=$(__build_rprompt)

# Aliases
alias ls="ls --color=auto"
