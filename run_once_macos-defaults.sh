#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  macOS defaults. chezmoi runs this once per machine on `chezmoi apply`;
#  it's also safe to run by hand any time — every line is idempotent.
#  Keyboard changes need a logout to fully take; the rest apply on exit.
# ══════════════════════════════════════════════════════════════════════
[[ "$(uname)" == "Darwin" ]] || exit 0
set -u

# ── Keyboard ──────────────────────────────────────────────────────────
# Fast repeat, short delay. Hold-for-accents off so h/j/k/l repeat in
# editors instead of popping an accent picker.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# No "smart" text mangling in native text fields: straight quotes,
# no auto-caps, no auto-period, no autocorrect. Code pastes cleanly.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save dialogs open expanded — the folder tree, not the stub.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# ── Dock ──────────────────────────────────────────────────────────────
# Hidden, appears instantly, no recent-apps section.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.35
defaults write com.apple.dock show-recents -bool false
# Don't reorder Spaces by recent use — AeroSpace workspaces stay put.
defaults write com.apple.dock mru-spaces -bool false
# Group windows by app in Mission Control (AeroSpace recommendation).
defaults write com.apple.dock expose-group-apps -bool true

# ── Finder ────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search this folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Stop littering network shares and USB sticks with .DS_Store.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ── Screenshots ───────────────────────────────────────────────────────
# Into a folder, not onto the desktop. No drop shadow on window shots.
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

# ── Apply ─────────────────────────────────────────────────────────────
for app in Dock Finder SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
echo "macOS defaults applied. Log out and back in for keyboard changes."
