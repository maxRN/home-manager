{ config, pkgs, ... }:

let
  homeManagerHome = "/Users/maxrn/.config/home-manager";
  link = config.lib.file.mkOutOfStoreSymlink;
  linkHome = x: link "${homeManagerHome}" + "/${x}";
in
{
  imports = [
    ./git.nix
    ./zsh.nix
    ./work.nix
    ./darwin.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "maxrn";
  home.homeDirectory = "/Users/maxrn";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [

    # Because for some reason they are not included by default.
    # Would like to have the BSD ones for MacOS but these'll do.
    man-pages

    alacritty

    vscode

    # programming langs
    go
    rustup
    python3
    poetry
    # Why is it broken??
    # opam

    bat
    btop
    curl
    wget
    fd
    ffmpeg
    fnm
    kubectl
    kubernetes-helm
    neofetch
    neovim
    pandoc
    ripgrep
    tmux
    tree
    tree-sitter
    nixpkgs-fmt
    jq

    gh

    sqlite
    sqlite-utils
    shellcheck

    # fonts
    jetbrains-mono
    ia-writer-duospace
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/tmux".source = dotfiles/tmux;
    ".config/alacritty".source = linkHome "dotfiles/alacritty";
    ".config/goku".source = linkHome "dotfiles/goku";
    ".config/nvim".source = linkHome "dotfiles/nvim";
    ".config/bat".source = linkHome "dotfiles/bat";
  };

  # TODO: Maybe this belongs to nix-darwin?
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    SUMO_HOME = "/opt/homebrew/opt/sumo/share/sumo";
  };

  home.shellAliases = {
    hm = "home-manager";
    vim = "nvim";
    gdp = "git diff -p";
    glp = "git log -p";
    gsp = "git diff --staged -p";
    gbl = "git branch --list";
    gnew = "git switch -c";
    gs = "git status";
    # switch to main, if it errors switch to master;
    gsm = " git switch main 2> /dev/null; [ $? -gt 0 ] && git switch master";
    dbu = "docker compose up -d --build";
    fzvim = "fzf | xargs nvim";
    ll = "ls -lah";
    k = "kubectl";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$XDG_CONFIG_HOME/home-manager/dotfiles/scripts"
    "$HOME/.local/bin"
    "$HOME/Library/Python/3.10/bin"
    "./node_modules/.bin"
    "$HOME/go/bin"
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };


  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;
}
