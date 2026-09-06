{ config, user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };

  # One compinit, not two: nix-darwin's /etc/zshrc would run compinit before
  # home-manager's ~/.zshrc runs its own, and every shell paid two full
  # compdumps. Completion stays on; the single compinit lives in home.nix.
  programs.zsh.enableGlobalCompInit = false;
  programs.zsh.enableBashCompletion = false;

  environment.etc."grok/requirements.toml".source = ./home/.grok/requirements.toml;

  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
      # Dictation-first writing (Wispr Flow) in deliberate lowercase: every
      # macOS rewrite layer fights that, so all six stay off. Dash substitution
      # off also stops "--" becoming an em dash system-wide.
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      # Held keys repeat (vim navigation) instead of opening the accent picker.
      ApplePressAndHoldEnabled = false;
      # Tracking speed maxed; this is how the machine is actually driven.
      "com.apple.trackpad.scaling" = 3.0;
      # Save and print dialogs open expanded.
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;           # reveal immediately at the edge
      autohide-time-modifier = 0.15;  # fast slide
      launchanim = false;             # no bounce before an app opens
      mru-spaces = false;             # Spaces keep their order
      persistent-apps = [ ];         # launch through Raycast
      persistent-others = [ ];       # no pinned folders or stacks
      show-recents = false;
      tilesize = 16;                  # tiny dock
    };
    finder = {
      FXPreferredViewStyle = "Nlsv";  # list view by default
      CreateDesktop = false;          # clean desktop
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";  # search the current folder, not This Mac
      _FXSortFoldersFirst = true;
      FXEnableExtensionChangeWarning = false;
    };
    screencapture = {
      location = "/Users/${user}/Pictures/Screenshots";  # dir ensured below
      type = "png";
      disable-shadow = true;
    };
    CustomUserPreferences = {
      "com.raycast.macos".raycastGlobalHotkey = "Command-49"; # Command-Space
      "com.knollsoft.Rectangle" = {
        alternateDefaultShortcuts = true; # Control-Option arrow layout
        launchOnLogin = true;
      };
      "com.apple.iCal" = {
        "first minute of work hours" = 360;
        "last minute of work hours" = 1320;
        "number of hours displayed" = 16;
        "last calendar view description" = "7-day";
      };
    };
    trackpad.Clicking = true;  # tap to click
  };

  # Touch ID (and Apple Watch) for sudo, written to /etc/pam.d/sudo_local so it
  # survives macOS updates; reattach makes it work inside tmux.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.activationScripts.postActivation.text = ''
    # screencapture.location does not create its target directory.
    sudo -u ${user} mkdir -p /Users/${user}/Pictures/Screenshots || true
  '';

  # GUI apps do not read the shell; the one env var Orca needs.
  launchd.user.envVariables.ORCA_TELEMETRY_DISABLED = "1";

  nix-homebrew = {
    enable = true;
    # Adopt a pre-existing /opt/homebrew install instead of failing on it.
    autoMigrate = true;
    inherit user;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here; every line below is a deliberate choice
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;   # brews and casks move forward on every rebuild
    onActivation.extraFlags = [ "--force" ];
    # Agent CLIs and GUI apps come from Homebrew, not nixpkgs: the 26.05 pin
    # trails these fast-moving tools by months, while brew tracks upstream.
    # Every entry has its job written beside it. If a line loses its job,
    # propose removal; delete it only when the human names it. Zap removes the app.
    #
    # Homebrew 6 requires vendor taps to be trusted; an untrusted tap's casks
    # are silently skipped and its brews abort the switch. Hence trusted = true.
    taps = [
      { name = "automic-vault/isotopes"; trusted = true; }
      { name = "stablyai/orca"; trusted = true; }
      { name = "smudge/smudge"; trusted = true; }
    ];
    brews = [
      "gh"     # official GitHub CLI. Do not install the Automic isotope; it prompts on every call.
      "herdr"  # terminal multiplexer; config in home/.config/herdr
      "imessage-exporter" # preserve the installed message export utility
      "smudge/smudge/nightlight" # Night Shift from the CLI; no bottle, compiles with cargo on install from a tap last updated 2025-07
    ];
    casks = [
      # identity and secrets
      "1password"           # the human vault: passwords, TOTP, passkeys, the SSH agent
      "1password-cli"       # op, for the rare scripted read, human-driven
      "automic-vault/isotopes/automic-vault"  # optional local delivery and policy layer; 1Password remains the source of truth
      # the AI desktop apps
      "claude"              # Claude desktop: Cowork, Dispatch, scheduled tasks, computer use. Do not remove.
      "chatgpt"             # ChatGPT desktop, Work, and Codex; local and cloud execution are separate
      "grok-bot"            # cloud executive entry point; account-specific routines and context live in private brain
      "cursor"              # bundled with SuperGrok Heavy; editor and cloud agents when a project earns them
      # the agent CLIs
      "claude-code@latest"  # current Claude Code channel; the stable cask must not coexist. Its zap stanza deletes ~/.claude.json: never drop this line under zap.
      "codex"               # OpenAI Codex CLI; reads ~/.codex/AGENTS.md; one of the harnesses Orca can open
      "grok-build"          # Grok Build CLI. One of the harnesses Orca can open.
      "stablyai/orca/orca"  # optional terminal-harness workspace alongside Codex/Claude GUI: worktrees, parallel sessions, diff review. Keep vendor-default bypass flags. Never the bare token "orca" (disabled Plotly cask).
      # daily tools
      "ghostty"             # the terminal; config in home/.config/ghostty
      "wezterm"             # retain the existing alternate terminal and its data
      "google-chrome"       # compatibility for integrations that specifically require Chrome
      "aside"               # primary Mac browser and local MCP browser worker; not the durable brain or an assumed cloud host
      "wispr-flow"          # dictation into every text field; mic and Accessibility grants are manual
      "raycast"             # launcher, clipboard history, calculator, hyper key
      "rectangle"           # window tiling
      "todoist-app"         # the shared task inbox; use the existing account
      "thaw"                # menu bar manager; its cask requires macOS 26 or newer (doctor.sh checks)
      "stats"               # memory pressure and battery in the menu bar; shows when an agent is swapping the machine
      "iina"                # video player; something is always on in the background
      # school and the desk
      "microsoft-outlook"   # Georgia Tech mail and calendar; use an Institute-approved client for GT data
      "microsoft-teams"     # Georgia Tech and the part-time job
      "zoom"                # classes and calls that are not Teams
      "obsidian"            # opens the separate private brain repo
      "anki"                # spaced retrieval for the semester (FSRS, opt-in per deck)
      # creative lane
      "blender"             # 3D creation
    ];
    # Mac App Store apps. `mas` cannot buy: sign in to the App Store and own
    # the app before the first rebuild, or the switch fails on that line.
    masApps = {
      "1Password for Safari" = 1569813296; # fill and passkeys in Safari
      "Dynamic wallpaper" = 1582358382;   # preserve the already-owned wallpaper app
      "uBlock Origin Lite" = 6745342698; # preserve the already-owned Safari blocker
    };
  };
}
