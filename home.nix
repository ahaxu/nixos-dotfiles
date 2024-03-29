{ config, pkgs, inputs, ... }:

# TODO move this to neovim config module
# coc config file for haskell
let
  cocSettings = {
    "diagnostic.maxWindowHeight" = 60;
    "diagnostic.virtualText" = true;
    "diagnostic.virtualTextCurrentLineOnly" = false;
    "codeLens.enable" = true;
    languageserver = {
      nix = {
        command = "rnix-lsp";
        filetypes = [ "nix" ];
      };
      haskell = {
        command = "haskell-language-server";
        args = [ "--lsp" "-d" "-l" "/tmp/LanguageServer.log" ];
        rootPatterns = [ ".hie-bios" "cabal.project" ];
        filetypes = [ "hs" "lhs" "haskell" ];
        settings.languageServerHaskell.formattingProvider = "fourmolu";
      };
    };
    explorer.icon.enableNerdfont = true;
    explorer.file.child.template =
      "[git | 2] [selection | clip | 1] [indent][icon | 1] [diagnosticError & 1][diagnosticWarning & 1][filename omitCenter 1][modified][readonly] [linkIcon & 1][link growRight 1 omitCenter 5][size]";
    };

in

  {
    home.username = "lk";
    home.homeDirectory = "/home/lk";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    luajitPackages.lua-lsp

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    tmux

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # graphics tool
    gimp-with-plugins

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    clipboard-jh

    clang
    git
    glibc
    (glibcLocales.override { locales = [ "en_US.UTF-8" ]; })
    openssl
    pkg-config
    rustup
    stdenv
    cmake

    python3
    python311Packages.pip

    nodejs_21
    yarn

    dbeaver
    mongodb-compass

    # chat tools
    telegram-desktop
    slack

    # browser
    brave
    opera

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    # hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # golang config
  programs.go = {
    enable = true;
  };

  programs.fish = {
    enable = true;
  };


  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "ahaxu";
    userEmail = "banghahatinh96@gmail.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };

    theme = "Gruvbox Dark";

    #font = {
    #  name="Iosevka Term";
    #  size = 10;
    #};

    extraConfig = ''

    hide_window_decorations yes

      # key remap

      map ctrl+c copy_to_clipboard
      map ctrl+v paste_from_clipboard

      map ctrl+equal change_font_size all +2.0
      map ctrl+plus change_font_size all +2.0

      map ctrl+minus change_font_size all -2.0
      map ctrl+kp_subtract change_font_size all -2.0

      map ctrl+0 change_font_size all 0

      # rebind ctrl+c to kill current process
      map ctrl+k send_text all \x03

      # map ctrl shift v
      # https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
      map ctrl+shift+v send_text all \x1b[86;6u
      # neotree for vim key binding
      map ctrl+1 send_text all \x1b[49;5u

      # font
      font_family   Operator Mono Book
      font_size     10
      '';
    };


    programs.bash = {
      enable = true;
      enableCompletion = true;

      # TODO add your cusotm bashrc here
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
  };

  # neovim configuration
  # TODO move this to separate file
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";


    in
    {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        lua-language-server
        rnix-lsp

        xclip
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; [

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        neodev-nvim

        {
          plugin = neo-tree-nvim;
          config = toLuaFile ./nvim/plugin/neo-tree.lua;
        }

        nvim-web-devicons
        vim-devicons

        vim-surround

        nvim-cmp
        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }

        telescope-fzf-native-nvim

        cmp_luasnip
        cmp-nvim-lsp

        luasnip
        friendly-snippets


        # Theme
        papercolor-theme
        vim-airline
        vim-airline-themes

        # ===
        # Languages
        # haskell syntax highlighting
        haskell-vim
        vim-hoogle

        vim-go
        # nix syntax highlighting
        vim-nix
        vim-markdown
        # latex
        vimtex
        coc-nvim
        coc-vimtex # not sure if I need two
        # ledger
        vim-ledger
        # rust
        coc-rls
        # python
        coc-python
        # css
        coc-css
        # yaml
        coc-yaml
        # json
        coc-json
        # html
        coc-html
        # dhall
        dhall-vim


        # general whitespace
        vim-trailing-whitespace
        vim-autoformat

        lualine-nvim

        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-json
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }


        {
          plugin = onedark-nvim;
          config = "colorscheme onedark";
        }

      ];

      extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/plugin/lsp.lua}
      ${builtins.readFile ./nvim/plugin/cmp.lua}
      ${builtins.readFile ./nvim/plugin/telescope.lua}
      ${builtins.readFile ./nvim/plugin/neo-tree.lua}
      ${builtins.readFile ./nvim/plugin/treesitter.lua}
      ${builtins.readFile ./nvim/plugin/coc.lua}
      ${builtins.readFile ./nvim/plugin/other.lua}
      '';
    };
    xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON cocSettings;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
