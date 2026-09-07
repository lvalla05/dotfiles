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
    python3    # portable automation and restore checks
    ripgrep    # fast search
    fd         # fast find
    fzf        # fuzzy finder
    jq         # json on the command line
    lazygit
    neovim
    tmux       # terminal sessions survive a closed window; not machine sleep or shutdown
    shellcheck # the tests lint the shell scripts
    # node and go run the pinned agent CLIs in home/bin/agent-tools.lock; npm
    # installs land under ~/.local (see .npmrc), never in the nix store.
    nodejs
    go
    # the font for editors that do not embed one (Ghostty ships its own).
    # home-manager copies fonts into ~/Library/Fonts/HomeManager; macOS ignores symlinked fonts.
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];  # agent-tools installs here
  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = opAgent;
    ORCA_TELEMETRY_DISABLED = "1";
    BRAIN_DIR = "${config.home.homeDirectory}/orca/brain";
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
      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
      };
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
      # Unattended launchers: the harness runs without prompts inside a
      # worktree; review what it produced before anything ships.
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
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

  home.file.".config/raycast/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/raycast/scripts";
  # pi coding agent: a minimal config (from kunchenguid/dotfiles, MIT-0), live-linked.
  # The model picker favors Luna xhigh and Sol high. Sign in with /login for
  # ChatGPT or xAI subscriptions; Pi stores credentials outside this repo.
  home.file.".pi/agent/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  # Orca adds runtime hooks beside these repository-owned extensions.
  home.file.".pi/agent/extensions/calm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions/calm";
  home.file.".pi/agent/extensions/terminal-status-title.js".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions/terminal-status-title.js";
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  # Pinned agent CLIs; home/bin/agent-tools.lock is the version authority.
  # Run `agent-tools` once after the first switch and after bumping the lock.
  home.file.".local/bin/agent-tools".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/agent-tools";
  home.file.".local/bin/pstack-setup".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/pstack-setup";
  home.file.".local/bin/firstmate".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/bin/firstmate";

  # One instruction file for every harness.
  # Codex and Grok Build read AGENTS.md natively; ~/.agents/AGENTS.md is the
  # vendor-neutral path. All live links.
  home.file.".agents/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".grok/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".grok/requirements.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.grok/requirements.toml";
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

  home.activation.codexExecutionMode = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.python3}/bin/python3 ${./scripts/configure-codex.py} "$HOME/.codex/config.toml"
  '';

  # npm never needs sudo and never writes into the nix store.
  home.file.".npmrc".text = "prefix=${config.home.homeDirectory}/.local\n";
  # Ordinary SSH uses keys stored in 1Password. GitHub git stays on HTTPS.
  home.file.".ssh/config".text = ''
    Host *
      IdentityAgent "${opAgent}"
      AddKeysToAgent no
  '';
}
