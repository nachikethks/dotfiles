skip_global_compinit=1
CONDA_CHANGEPS1=false

for f in "$ZDOTDIR/conf.d/"*.zsh; do
  source "$f"
done
unset f
