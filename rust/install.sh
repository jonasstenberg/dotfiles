if test ! $(which bat); then
  cargo install bat
fi
if test ! $(which devicon-lookup); then
  cargo install devicon-lookup
fi
if test ! $(which rg); then
  cargo install ripgrep
fi
