{ config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "lk";
  home.homeDirectory = "/home/lk";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

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
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

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

    # chat tools
    telegram-desktop

    # brave browser
    brave

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    # hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
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

    theme = "Gruvbox Dark Soft";

    font = {
      name="Iosevka Term";
      size = 12;
    };

    extraConfig = ''
      hide_window_decorations yes
    '';
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
      vim-go
      trim-nvim 
      haskell-tools-nvim
      nvim-fzf

      #(fromGitHub "HEAD" "elihunter173/dirbuf.nvim") # https://gist.github.com/nat-418/d76586da7a5d113ab90578ed56069509
    ];
    extraConfig =''
      """"""""""""""""""""""
      "      Settings      "
      """"""""""""""""""""""
      set nocompatible                " Enables us Vim specific features
      filetype off                    " Reset filetype detection first ...
      filetype plugin indent on       " ... and enable filetype detection
      set ttyfast                     " Indicate fast terminal conn for faster redraw
      set laststatus=2                " Show status line always
      set encoding=utf-8              " Set default encoding to UTF-8
      set autoread                    " Automatically read changed files
      set autoindent                  " Enabile Autoindent
      set backspace=indent,eol,start  " Makes backspace key more powerful.
      set incsearch                   " Shows the match while typing
      set hlsearch                    " Highlight found searches
      "set noerrorbells                " No beeps
      set number                      " Show line numbers
      set showcmd                     " Show me what I'm typing
      set noswapfile                  " Don't use swapfile
      set nobackup                    " Don't create annoying backup files
      set splitright                  " Vertical windows should be split to right
      set splitbelow                  " Horizontal windows should split to bottom
      set autowrite                   " Automatically save before :next, :make etc.
      set hidden                      " Buffer should still exist if window is closed
      set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
      set noshowmatch                 " Do not show matching brackets by flickering
      set noshowmode                  " We show the mode with airline or lightline
      set ignorecase                  " Search case insensitive...
      set smartcase                   " ... but not it begins with upper case
      set completeopt=menu,menuone    " Show popup menu, even if there is one entry
      set pumheight=10                " Completion window max size
      set nocursorcolumn              " Do not highlight column (speeds up highlighting)
      set nocursorline                " Do not highlight cursor (speeds up highlighting)
      set lazyredraw                  " Wait to redraw
      set expandtab
      set tabstop=4
    '';
    extraLuaConfig = /* lua */ ''
      vim.o.termguicolors  = true
      vim.cmd('colorscheme gruvbox-material')
      vim.g.gruvbox_material_background = 'hard'
    '';
  };

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
