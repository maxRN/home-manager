{ pkgs, ... }:

{
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

    bat
    btop
    colima
    curl
    docker-client
    fd
    ffmpeg
    fnm
    kubectl
    kubernetes-helm
    neofetch
    neovim
    opam
    pandoc
    ripgrep
    tmux
    tree
    tree-sitter

    jq

    # fonts
    jetbrains-mono
    ia-writer-duospace

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/tmux/tmux.conf".source = dotfiles/tmux/tmux.conf;
    ".config/git/config".source = dotfiles/git/config;
    ".config/git/config-uni".source = dotfiles/git/config-uni;
    ".config/git/config-work".source = dotfiles/git/config-work;
    ".config/git/ignore".source = dotfiles/git/ignore;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maxrn/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_CACHE_HOME="$HOME/.cache";
    ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zshcompdump";
    SUMO_HOME="/opt/homebrew/opt/sumo/share/sumo";
    # For Quarkus Projects
    TESTCONTAINERS_RYUK_DISABLED="true";
  };

  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.zsh = {
      enable = true;
      syntaxHighlighting = {
          enable = true;
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      shellAliases = {
          hm = "home-manager";
          skim ="open -a /Applications/Skim.app";
          vim = "nvim";
          zshconfig="nvim ~/.zshrc";
          ohmyzsh = "nvim ~/.oh-my-zsh";
          co="git checkout";
          gdp="git diff -p";
          glp="git log -p";
          gsp="git diff --staged -p";
          gbl="git branch --list";
          gnew="git switch -c";
          gs="git status";
          # switch to main, if it errors switch to master;
          gsm=" git switch main 2> /dev/null; [ $? -gt 0 ] && git switch master";
          dbu="docker compose up -d --build";
          fzvim="fzf | xargs nvim";
          ll="ls -lah";
          k="kubectl";
          wirecard="/Applications/Wireshark.app/Contents/MacOS/Wireshark";
      };
      oh-my-zsh = {
          enable = true;
          plugins = [ "git" "docker" "docker-compose" "kubectl" "helm" ];
          theme = "robbyrussell";
      };
      initExtra = ''
      bindkey '^ ' autosuggest-accept

      zs() {
          exec zsh;
      }

      function inspiration() {
          fortune | cowsay -f $(node -e "var c='$(cowsay -l | sed "1d" | paste -s -d " " -)'.split(' ');console.log(c[Math.floor(Math.random()*c.length)])") | lolcat --seed 0 --spread 1.0
      }

      export PATH=$PATH:~/go/bin
      export PATH="$PATH:$HOME/.dotfiles/bin"
      export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

      export PATH="/Users/maxrn/bin:$PATH"
      export PATH="/Users/maxrn/.dotfiles/scripts:$PATH"
      export PATH="/Users/maxrn/.local/bin:$PATH"

      # Add Visual Studio Code (code)
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
      export PATH="/Users/maxrn/Library/Python/3.10/bin:$PATH"
      export PATH="./node_modules/.bin:$PATH"
      '';
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
