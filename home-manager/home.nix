{ config, pkgs, lib, ... }:

{
  home.username = "<USERNAME>";  # Change to your username
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "26.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set default shell
  programs.bash.enable = false;

  # Kitty terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      cursor = "#f5e0dc";
      selection_background = "#585b70";
      selection_foreground = "#1e1e2e";
      # Catppuccin Mocha theme
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#94e2d5";
      color7 = "#bac2de";
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+n" = "new_os_window";
    };
  };

  # ZSH Shell with all features
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreAllDups = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };

    initContent = ''
      # Enable vi key bindings
      bindkey -v

      # History search with arrow keys
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward

      # Home/End keys
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      # Useful aliases
      alias ls='ls --color=auto'
      alias la='ls -la'
      alias ll='ls -lh'
      alias grep='grep --color=auto'
      alias mkdir='mkdir -pv'
      alias cd='z'
      alias cdi='zi'
    '';

    shellAliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "zoxide"
        "fzf"
        "sudo"
      ];
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$nodejs$python$cmd_duration$line_break$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = "🌱 ";
      };
      git_status = {
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };
    };
  };

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
  };

  # FZF (fuzzy finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    baseIndex = 1;
    prefix = "C-b";
    extraConfig = ''
      # Split panes more intuitively
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Vi-like navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Theme
      set -g status-bg '#313244'
      set -g status-fg '#cdd6f4'
      set -g status-left ' #S '
      set -g status-left-style 'bg=#89b4fa fg=#313244 bold'
      set -g status-right ' %H:%M | %d %b '
      set -g status-right-style 'bg=#89b4fa fg=#313244'

      setw -g window-status-format ' #{window_index} #{window_name} '
      setw -g window-status-current-format ' #{window_index} #{window_name} '
      setw -g window-status-current-style 'bg=#a6e3a1 fg=#313244 bold'
    '';
  };

  # Neovim (basic config, you'll expand this)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "<YOUR_NAME>";          # Change to your name
      user.email = "<YOUR_EMAIL>";        # Change to your email
    };
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".vscode/"
      ".idea/"
      "*.o"
      "*.a"
    ];
  };

  # Package management
  home.packages = with pkgs; [
    # Terminal utilities
    ripgrep       # Fast grep alternative
    fd            # Fast find alternative
    bat           # Better cat with syntax highlighting
    eza           # Better ls alternative
    tldr          # Simplified man pages
    glow          # Markdown viewer for terminal
    pandoc        # Universal document converter
    mc            # Midnight Commander - terminal dual-pane file manager

    # File managers
    krusader      # KDE dual-pane file manager (Total Commander style)

    # Krusader helper tools (archivers, diff/compare)
    p7zip         # 7z archive support
    unrar         # rar extraction
    unzip         # zip extraction
    zip           # zip creation
    kdiff3        # file/folder diff
    kdePackages.ark       # archive GUI backend
    kdePackages.kompare   # diff viewer used by Krusader's compare feature
    kdePackages.kget      # download manager Krusader can queue remote fetches to
    krename       # batch rename tool
    plocate       # locate/updatedb

    # Text editors & note-taking
    emacs         # Powerful terminal/GUI editor with org-mode
    obsidian      # GUI knowledge base for second brain

    # Media
    vlc           # Video/audio player
    ffmpeg        # Audio/video conversion & processing

    # Development
    git
    curl
    wget
    tree

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # PDF reading + OCR for book study
    poppler-utils   # pdftoppm/pdftotext - unblocks Claude Code's native PDF page rendering
    tesseract       # OCR engine, fallback for text buried in diagrams/scans
    (python3.withPackages (ps: with ps; [ pymupdf pytesseract pdf2image pillow pyserial ]))

    # Embedded development - STM32 (ARM Cortex-M)
    gcc-arm-embedded  # arm-none-eabi-gcc/g++/gdb toolchain
    gcc               # host compiler, for the CMake host-tests preset (Unity/CTest)
    cmake
    ninja
    openocd           # flashing/debugging via ST-LINK
    stlink            # st-flash/st-info/st-util
    doxygen
    graphviz          # dot, for Doxygen include/collaboration graphs
    clang-tools       # provides clang-format, clang-tidy, clangd (LSP) - NOT a compiler
    # (no standalone `gdb` - gcc-arm-embedded already bundles arm-none-eabi-gdb,
    # and a plain `gdb` conflicts with it on shared system-gdbinit files)

    # Editor: VSCodium (upstream `vscode`/`vscode-fhs` are broken on this nixpkgs
    # channel as of 1.144.0 - ripgrep binary path changed, patchPhase not updated
    # yet; VSCodium builds from source and isn't affected)
    vscodium

    # Embedded development - other architectures (uncomment when needed)
    # Verify exact attribute names with `nix search nixpkgs <term>` before enabling -
    # these ecosystems are less standardized in nixpkgs than the ARM toolchain above.
    # pkgsCross.avr.buildPackages.gcc  # AVR cross compiler (Arduino-class targets)
    # avrdude                          # AVR flashing tool
    # platformio                       # unified build/flash tool; often the easiest path for ESP32
    # ESP32/ESP-IDF: no plain nixpkgs attribute - use `platformio` above, or the
    # community `esp-idf-nix` flake (https://github.com/mirrexagon/esp-idf-nix) if
    # you need the full ESP-IDF SDK rather than PlatformIO's wrapped version.
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };

  # Add ~/bin to PATH
  home.sessionPath = [
    "$HOME/bin"
  ];

  # Rebuild KDE's application cache after every switch - otherwise newly
  # installed GUI apps don't show up in the Kickoff menu. This is because
  # ~/.nix-profile is a symlink that switch repoints atomically; KDE's
  # inotify watch on the old target never fires for the new one, so the
  # cache goes stale until something forces a rebuild.
  home.activation.rebuildKdeSycoca = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental $VERBOSE_ARG || true
  '';
}
