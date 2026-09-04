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
      show-recents = false;           # only pinned apps
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
    # delete the line; zap removes the app. Never remove a line silently.
    #
    # Homebrew 6 requires vendor taps to be trusted; an untrusted tap's casks
    # are silently skipped and its brews abort the switch. Hence trusted = true.
    taps = [
      { name = "automic-vault/isotopes"; trusted = true; }
      { name = "stablyai/orca"; trusted = true; }
    ];
    brews = [
      "gh"     # official GitHub CLI. Do not install the Automic isotope; it prompts on every call.
      "herdr"  # terminal multiplexer; config in home/.config/herdr
    ];
    casks = [
      # identity and secrets
      "1password"           # the human vault: passwords, TOTP, passkeys, the SSH agent
      "1password-cli"       # op, for the rare scripted read, human-driven
      "automic-vault/isotopes/automic-vault"  # the agent vault: a secret reaches a tool per approved use and never a file
      # the AI desktop apps
      "claude"              # Claude desktop: Cowork, Dispatch, scheduled tasks, computer use; the Mac half of the phone link. Do not remove.
      "chatgpt"             # ChatGPT desktop and the Codex app; the Codex Remote host
      "grok-bot"            # Grok Bot desktop (SuperGrok Heavy); read-only researcher, never a mail or calendar hand
      "cursor"              # bundled with SuperGrok Heavy; editor and cloud agents when a project earns them
      # the agent CLIs
      "claude-code@latest"  # claude on the latest channel (Fable 5.1 and the sandbox need 2.1.257+); the stable cask must not coexist. Its zap stanza deletes ~/.claude.json: never drop this line under zap.
      "codex"               # OpenAI Codex CLI; reads ~/.codex/AGENTS.md; the reviewer and second opinion
      "grok-build"          # Grok Build CLI. One of the harnesses Orca can open.
      "stablyai/orca/orca"  # the ADE: worktrees, parallel sessions, diff review. Harness in a pane is whatever the job needs. Leave Agent Permissions on the vendor default (bypass flags). Never the bare token "orca" (that is a disabled Plotly cask).
      # daily tools
      "ghostty"             # the terminal (1.3: search, command-done notifications, embedded JetBrains Mono); config in home/.config/ghostty
      "google-chrome"       # the logged-in browser; the only browser Claude in Chrome supports
      "wispr-flow"          # dictation into every text field; mic and Accessibility grants are manual
      "raycast"             # launcher, clipboard history, calculator, hyper key
      "rectangle"           # window tiling
      "thaw"                # menu bar manager that supports macOS 26 and 27
      "stats"               # memory pressure and battery in the menu bar; shows when an agent is swapping the machine
      "iina"                # video player; something is always on in the background
      "tailscale-app"       # the phone and other machines reach the Mac only through the tailnet; never an exit node
      # school and the desk
      "microsoft-teams"     # Georgia Tech and the part-time job
      "zoom"                # classes and calls that are not Teams
      "obsidian"            # the one memory: the private vault
      "anki"                # spaced retrieval for the semester (FSRS, opt-in per deck)
      "fantastical"         # the face of Google Calendar and the school calendar
      "superhuman"          # the reading client for Gmail and the school mailbox; drafts are never sent by an agent
      # creative lane
      "blender"             # 5.2 LTS
    ];
    # Mac App Store apps. `mas` cannot buy: sign in to the App Store and own
    # the app before the first rebuild, or the switch fails on that line.
    masApps = {
      "Things 3" = 904280696;              # today's list, fed one way from the brief; the record stays in the vault
      "1Password for Safari" = 1569813296; # fill and passkeys in Safari
    };
  };
}
