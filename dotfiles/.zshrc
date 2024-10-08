# add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";
export PATH="/opt/homebrew/bin:$PATH"

# load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# enable zsh autocompletion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# disable autocorrect typos in path names when using `cd`
unsetopt CORRECT;
unsetopt CORRECT_ALL;

eval "$(oh-my-posh init zsh --config ~/.omp-theme.json)"
