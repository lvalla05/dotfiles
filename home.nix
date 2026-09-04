{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  # 1Password's SSH agent socket. The container is 2BUA8C4S2C.com.1password
  # (no "group." segment); the socket exists only after Settings > Developer >
  # "Use the SSH agent" is on in 1Password.
  opAgent = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep    # fast search
    fd         # fast find
    fzf        # fuzzy finder
    jq         # json on the command line
    lazygit
    neovim
    tmux       # a Remote Control session survives a closed window when it runs in tmux
    shellcheck # the tests lint the shell scripts
    # node for `npx -y <tool>@<version>` (lavish-axi, backpass); no global npm layer to drift
    nodejs
    # the font for editors that do not embed one (Ghostty ships its own).
    # home-manager copies fonts into ~/Library/Fonts/HomeManager; macOS ignores symlinked fonts.
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = opAgent;
    ORCA_TELEMETRY_DISABLED = "1";
  };

  # Git identity, declared so a fresh machine commits correctly from the first
  # rebuild. Cloners: change these before your first rebuild.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Likhith Vallabhaneni";
        email = "valla.likhith@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    # The only compinit that runs (configuration.nix turns off nix-darwin's).
    # nix-homebrew leaves a dangling _brew completion symlink; drop it first.
    completionInit = ''
      if [[ -L /opt/homebrew/share/zsh/site-functions/_brew && ! -e /opt/homebrew/share/zsh/site-functions/_brew ]]; then
        rm -f /opt/homebrew/share/zsh/site-functions/_brew
      fi
      _zcompdump="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-''${ZSH_VERSION}"
      mkdir -p "''${_zcompdump:h}"
      autoload -U compinit && compinit -d "$_zcompdump"
      autoload -U bashcompinit && bashcompinit
      unset _zcompdump
    '';
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      m = "git switch main";
      rebuild = "~/.dotfiles/rebuild.sh";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in this repo, the path in $HOME points
  # at it. Editing the repo is editing the live config; no rebuild needed.
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";

  # One instruction file for every harness.
  # Codex and Grok Build read AGENTS.md natively; ~/.agents/AGENTS.md is the
  # vendor-neutral path (backpass's canonical target). All live links.
  home.file.".agents/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".grok/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  # Claude is the exception, on purpose: the desktop app (Cowork, Dispatch)
  # skips a symlinked ~/.claude/CLAUDE.md and skips any @import that resolves
  # outside the working directory, so a link or an @AGENTS.md pointer loads
  # nothing there. A plain copy of the same file loads everywhere. It is
  # refreshed on every ./rebuild.sh; edit home/AGENTS.md, then rebuild.
  home.activation.claudeInstructions = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    run mkdir -p "$HOME/.claude"
    run install -m 644 "${./home/AGENTS.md}" "$HOME/.claude/CLAUDE.md"
  '';
  # Claude Code rewrites this file at runtime (permission grants, /config).
  # As a live link, those writes land in the repo: commit the keepers, check
  # out the rest. A copy would silently revert them on every rebuild.
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # npm never needs sudo and never writes into the nix store.
  home.file.".npmrc".text = "prefix=${config.home.homeDirectory}/.local\n";
  # SSH through 1Password's agent: GitHub and Tailscale SSH unlock with the
  # fingerprint, no key file on disk, no passphrase typed.
  home.file.".ssh/config".text = ''
    Host *
      IdentityAgent "${opAgent}"
      AddKeysToAgent no
  '';
}
