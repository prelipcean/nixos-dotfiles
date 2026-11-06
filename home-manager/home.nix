{ config, pkgs, ... }:

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

    # Text editors & note-taking
    emacs         # Powerful terminal/GUI editor with org-mode
    obsidian      # GUI knowledge base for second brain

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
    (python3.withPackages (ps: with ps; [ pymupdf pytesseract pdf2image pillow ]))
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
}
