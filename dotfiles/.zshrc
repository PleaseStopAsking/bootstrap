# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";
export PATH="/opt/homebrew/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# enable zsh autocompletion
autoload -U compinit; compinit

# disable autocorrect typos in path names when using `cd`
unsetopt CORRECT;
unsetopt CORRECT_ALL;