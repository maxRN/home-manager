{ config, pkgs, ... }:

let
  homeManagerHome = "/Users/maxrn/.config/home-manager";
  link = config.lib.file.mkOutOfStoreSymlink;
  linkHome = x: link "${homeManagerHome}" + "/${x}";
in
{
  imports = [
    ./work/work.nix
    ./darwin/darwin.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "maxrn";
  home.homeDirectory = "/Users/maxrn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    #opam

    tkdiff

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
    ".config/tmux/tmux.conf".source = dotfiles/tmux/tmux.conf;
    ".config/git/config".source = dotfiles/git/config;
    ".config/git/config-uni".source = dotfiles/git/config-uni;
    ".config/git/ignore".source = dotfiles/git/ignore;
    ".config/alacritty/alacritty.yml".source = linkHome "dotfiles/alacritty/alacritty.yml";
    ".config/goku/karabiner.edn".source = linkHome "dotfiles/goku/karabiner.edn";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    ZSH_COMPDUMP = "$XDG_CACHE_HOME/zsh/zshcompdump";
    SUMO_HOME = "/opt/homebrew/opt/sumo/share/sumo";
  };

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

    zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      shellAliases = {
        hm = "home-manager";
        skim = "open -a /Applications/Skim.app";
        vim = "nvim";
        zshconfig = "nvim ~/.zshrc";
        ohmyzsh = "nvim ~/.oh-my-zsh";
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
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" "kubectl" "helm" ];
        theme = "robbyrussell";
      };
      initExtra = ''
        bindkey '^ ' autosuggest-accept

        eval "$(fnm env --use-on-cd)"

        function inspiration() {
            fortune | cowsay -f $(node -e "var c='$(cowsay -l | sed "1d" | paste -s -d " " -)'.split(' ');console.log(c[Math.floor(Math.random()*c.length)])") | lolcat --seed 0 --spread 1.0
        }

        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

        export PATH="$PATH:$HOME/.dotfiles/bin"
        export PATH="/Users/maxrn/bin:$PATH"
        export PATH="/Users/maxrn/.dotfiles/scripts:$PATH"
        export PATH="/Users/maxrn/.local/bin:$PATH"
        export PATH="/Users/maxrn/Library/Python/3.10/bin:$PATH"
        export PATH="./node_modules/.bin:$PATH"
        export PATH="$HOME/go/bin:$PATH"
      '';
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;
}
