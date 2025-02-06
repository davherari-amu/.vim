# From ProVim {{{
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# }}}

# Aliases {{{
alias freecad='/home/david/opt/freecad/FreeCAD_0.21.0-Linux-x86_64.AppImage'
alias feconv='/home/david/Documents/Codes/FEconv/FEconv/feconv'
alias openDir='xdg-open .'
alias Salome='/home/david/salome_meca/appli_V2019.0.3_universal/salome'
alias -s py=python3
alias MorphoDir='cd ~/Documents/Codes/MorphoDesign/'
alias PyUtilDir='cd ~/Documents/Codes/MorphoDesign/PythonUtilities'
alias LatexDir='cd ~/Documents/Latex'
alias FenicsDir='cd ~/Documents/Codes/fenics '
# Git aliases
alias gitmain='git checkout main'
alias gitDevelop='git checkout Develop'
gitNewBranch() {
  git checkout -b $1
}
gitMergeDevelopMain(){
  gitDevelop
  git pull
  git merge $1
  gitmain
  git pull
  git merge Develop
  git push
  gitDevelop
  git push
  git branch -d $1
}
gitRemoteBranch() {
  git push -u origin $1
}
makeLatex() {
  # Get input
  if [ $# -eq 1 ]
  then
    fileName=$1
  else
    if [ $# -eq 2 ]
    then
      if [ "$1" = "-p" ]
      then
        fileName=$2
      else
        if [ "$2" = "-p" ]
        then
          fileName=$1
        else
          echo "Error: unknown option. You must provide the file name and you can add '-p' to indicate popping up."
          break
        fi
      fi
    else
      echo "Error: unknown option. You must provide the file name and you can add '-p' to indicate popping up."
    fi
  fi
  echo "$fileName"
  # Remove previous latex files
  rm "$fileName.aux"
  rm "$fileName.bbl"
  rm "$fileName.blg"
  rm "$fileName.log"
  rm "$fileName.out"
  rm "$fileName.spl"
  rm "$fileName.nav"
  rm "$fileName.snm"
  rm "$fileName.toc"
  rm *-eps-converted-to.pdf
  # Compile latex
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -shell-escape -file-line-error $fileName
  makeindex "$fileName.nlo" -s nomencl.ist -o "$fileName.nls"
  bibtex $fileName
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -shell-escape -file-line-error $fileName
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -shell-escape -file-line-error $fileName
  # Save in build and open with okular
  mkdir -p build
  mv "$fileName.pdf" "build/$fileName.pdf"
  if [ $# -eq 2 ]
  then
    xdg-open "build/$1.pdf"
  fi
}
makeDiffLatex() {
  # Compile latex
  rm diffmain.*
  # latexdiff  "$1.tex" "$2.tex" -t CFONT > diffmain.tex
  latexdiff  "$1.tex" "$2.tex" > diffmain.tex
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -file-line-error diffmain
  makeindex diffmain.nlo -s diffmain.ist -o diffmain.nls
  bibtex diffmain
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -file-line-error diffmain
  pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -file-line-error diffmain
  rm *-eps-converted-to.pdf
  # Save in build and open with okular
  mkdir -p build
  mv diffmain.pdf build/reviewedMain.pdf
}
# }}}

# Programs {{{
export PATH=$PATH:/opt/ParaView-5-10/bin/
# export PATH="$HOME/miniforge3/bin:$PATH"  # commented out by conda initialize
# }}

# nvm {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }}}

# Use vim editor {{{
export VISUAL=vim
export EDITOR="$VISUAL"
# }}}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/david/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/david/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/david/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/david/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

