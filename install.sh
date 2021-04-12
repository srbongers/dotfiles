#!/usr/bin/env bash

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

backup() {
    BACKUP_DIR=$HOME/dotfiles-backup

    echo "Creating backup directory at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    for file in $(get_linkables); do
        filename=".$(basename "$file" '.symlink')"
        target="$HOME/$filename"
        if [ -f "$target" ]; then
            echo "backing up $filename"
            cp "$target" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done

    for filename in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
        if [ ! -L "$filename" ]; then
            echo "backing up $filename"
            cp -rf "$filename" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done
}


setup_symlinks() {
    title "Creating symlinks"

    if [ ! -e "$HOME/.dotfiles" ]; then
        info "Adding symlink to dotfiles at $HOME/.dotfiles"
        ln -s "$DOTFILES" ~/.dotfiles
    fi

    for file in $(get_linkables) ; do
        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done

    echo -e
    info "installing to ~/.config"
    if [ ! -d "$HOME/.config" ]; then
        info "Creating ~/.config"
        mkdir -p "$HOME/.config"
    fi

    config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
    for config in $config_files; do
        target="$HOME/.config/$(basename "$config")"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $config"
            ln -s "$config" "$target"
        fi
    done

    if [[ "$(uname)" == "Darwin" ]]; then
        echo -e
        info "installing to ~/.matplotlib"
        if [ ! -d "$HOME/.matplotlib" ]; then
            info "Creating ~/.matplotlib"
            mkdir -p "$HOME/.matplotlib"
            info "Creating symlink for $DOTFILES/matplotlib/matplotlibrc"
	    ln -s "$DOTFILES/matplotlib/matplotlibrc" "$HOME/.matplotlib/matplotlibrc"
	fi
    fi

    # create vim symlinks
    # As I have moved off of vim as my full time editor in favor of neovim,
    # I feel it doesn't make sense to leave my vimrc intact in the dotfiles repo
    # as it is not really being actively maintained. However, I would still
    # like to configure vim, so lets symlink ~/.vimrc and ~/.vim over to their
    # neovim equivalent.

    echo -e
    info "Creating vim symlinks"
    VIMFILES=( "$HOME/.vim:$DOTFILES/config/nvim"
            "$HOME/.vimrc:$DOTFILES/config/nvim/init.vim" )

    for file in "${VIMFILES[@]}"; do
        KEY=${file%%:*}
        VALUE=${file#*:}
        if [ -e "${KEY}" ]; then
            info "${KEY} already exists... skipping."
        else
            info "Creating symlink for $KEY"
            ln -s "${VALUE}" "${KEY}"
        fi
    done
}

setup_git() {
    title "Setting up Git"

    defaultName=$(git config user.name)
    defaultEmail=$(git config user.email)
    defaultGithub=$(git config github.user)

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github

    git config -f ~/.gitconfig-local user.name "${name:-$defaultName}"
    git config -f ~/.gitconfig-local user.email "${email:-$defaultEmail}"
    git config -f ~/.gitconfig-local github.user "${github:-$defaultGithub}"

    if [[ "$(uname)" == "Darwin" ]]; then
        git config --global credential.helper "osxkeychain"
    else
        read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
        if [[ $save =~ ^([Yy])$ ]]; then
            git config --global credential.helper "store"
        else
            git config --global credential.helper "cache --timeout 3600"
        fi
    fi
}

setup_homebrew() {
    title "Setting up Homebrew"

    if test ! "$(command -v brew)"; then
        info "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    fi

    if [ "$(uname)" == "Linux" ]; then
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    fi

    # install brew dependencies from Brewfile
    brew bundle

    # install fzf
    if test -f $(brew --prefix)/opt/fzf/install; then
        echo -e
        info "Installing fzf"
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

function setup_shell() {
    title "Configuring shell"

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
    fi

    ## fix for zsh compinit insecure directories error
    #eval "$zsh_path -i -c compaudit | xargs chmod g-w"
}

function setup_terminfo() {
    title "Configuring terminfo"

    info "adding tmux.terminfo"
    tic -x "$DOTFILES/resources/tmux.terminfo"

    info "adding xterm-256color-italic.terminfo"
    tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"
}

setup_macos() {
    title "Configuring macOS"
    if [[ "$(uname)" == "Darwin" ]]; then

        get_plist_files=$(find -H "$DOTFILES/Applications/LaunchAgents" -maxdepth 1 -name '*.plist')
	   
        for file in $get_plist_files ; do
            filename=".$(basename "$file")"
            target="$HOME/Library/LaunchAgents/$filename"
            if [ -e "$target" ]; then
                info "${filename} already exists... Skipping."
            else
                info "Copying ${filename}"
                cp "$file" "$target"
		
		if [[ "$(basename "$file" '.plist')" == "userkeymapping" ]]; then
                    chmod 755 "$DOTFILES/bin/userkeymapping"
		fi
		
		launchctl load "$target"
            fi
        done

        echo "Finder: show all filename extensions"
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true
        
        # echo "show hidden files by default"
        defaults write com.apple.Finder AppleShowAllFiles -bool false
        
        echo "only use UTF-8 in Terminal.app"
        defaults write com.apple.terminal StringEncodings -array 4
        
        echo "expand save dialog by default"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        
        echo "show the ~/Library folder in Finder"
        chflags nohidden ~/Library
        
        # echo "disable resume system wide"
        # defaults write NSGlobalDomainNSQuitAlwaysKeepWindows -bool false
        
        echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
        
        echo "Enable subpixel font rendering on non-Apple LCDs"
        defaults write NSGlobalDomain AppleFontSmoothing -int 2
        
        # echo "Enable the 2D Dock"
        # defaults write com.apple.dock no-glass -bool true
        
        # Automatically hide and show the Dock
        # defaults write com.apple.dock autohide -bool true
        
        # echo "Make Dock icons of hidden applications translucent"
        # defaults write com.apple.dock showhidden -bool true
        
        # echo "Enable iTunes track notifications in the Dock"
        # defaults write com.apple.dock itunes-notifications -bool true
        
        # Disable menu bar transparency
        # defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
        
        # Show remaining battery time; hide percentage
        # defaults write com.apple.menuextra.battery ShowPercent -string "NO"
        # defaults write com.apple.menuextra.battery ShowTime -string "YES"
        
        # echo "Always show scrollbars"
        # defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"
        
        # echo "Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons"
        # defaults write com.apple.finder QuitMenuItem -bool true
        
        # Disable window animations and Get Info animations in Finder
        # defaults write com.apple.finder DisableAllAnimations -bool true
        
        echo "Use current directory as default search scope in Finder"
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
        
        echo "Show Path bar in Finder"
        defaults write com.apple.finder ShowPathbar -bool true
        
        echo "Show Status bar in Finder"
        defaults write com.apple.finder ShowStatusBar -bool true
       
        # Use list view in all Finder windows by default
        # Four-letter codes for the other view modes (icons, list, columns, gallery view): `icnv`,'Nlsv' `clmv`, `glyv`
        defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

        # echo "Expand print panel by default"
        # defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        
        # echo "Disable the “Are you sure you want to open this application?” dialog"
        # defaults write com.apple.LaunchServices LSQuarantine -bool false
        
        # echo "Disable shadow in screenshots"
        # defaults write com.apple.screencapture disable-shadow -bool true
        
        # echo "Enable highlight hover effect for the grid view of a stack (Dock)"
        # defaults write com.apple.dock mouse-over-hilte-stack -bool true
        
        # echo "Enable spring loading for all Dock items"
        # defaults write enable-spring-load-actions-on-all-items -bool true
        
        # echo "Show indicator lights for open applications in the Dock"
        # defaults write com.apple.dock show-process-indicators -bool true
        
        # Don’t animate opening applications from the Dock
        # defaults write com.apple.dock launchanim -bool false
        
        # echo "Display ASCII control characters using caret notation in standard text views"
        # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
        # defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
        
        echo "Disable press-and-hold for keys in favor of key repeat"
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
        
        echo "Set a blazingly fast keyboard repeat rate"
        defaults write NSGlobalDomain KeyRepeat -int 1
        
        echo "Set a shorter Delay until key repeat"
        defaults write NSGlobalDomain InitialKeyRepeat -int 15
        
        # echo "Disable auto-correct"
        # defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
        
        # Disable opening and closing window animations
        # defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
        
        # echo "Disable disk image verification"
        # defaults write com.apple.frameworks.diskimages skip-verify -bool true
        # defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
        # defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
        
        # echo "Automatically open a new Finder window when a volume is mounted"
        # defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
        # defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
        # defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
        
        # echo "Display full POSIX path as Finder window title"
        # defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
        
        # Increase window resize speed for Cocoa applications
        # defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
        
        # echo "Avoid creating .DS_Store files on network volumes"
        # defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
        
        # echo "Disable the warning when changing a file extension"
        # defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
        
        # echo "Show item info below desktop icons"
        # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
        
        # echo "Enable snap-to-grid for desktop icons"
        # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
        
        # echo "Disable the warning before emptying the Trash"
        # defaults write com.apple.finder WarnOnEmptyTrash -bool false
        
        # Empty Trash securely by default
        # defaults write com.apple.finder EmptyTrashSecurely -bool true
        
        # echo "Require password immediately after sleep or screen saver begins"
        # defaults write com.apple.screensaver askForPassword -int 1
        # defaults write com.apple.screensaver askForPasswordDelay -int 0
        
        echo "Enable tap to click (Trackpad)"
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        
        # echo "Map bottom right Trackpad corner to right-click"
        # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
        # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
        
        # echo "Disable Safari’s thumbnail cache for History and Top Sites"
        # defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
        
        # echo "Enable Safari’s debug menu"
        # defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
        
        # echo "Make Safari’s search banners default to Contains instead of Starts With"
        # defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
        
        # Remove useless icons from Safari’s bookmarks bar
        # defaults write com.apple.Safari ProxiesInBookmarksBar "()"
        
        # echo "Add a context menu item for showing the Web Inspector in web views"
        # defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
        
        # echo "Only use UTF-8 in Terminal.app"
        # defaults write com.apple.terminal StringEncodings -array 4
        
        # echo "Disable the Ping sidebar in iTunes"
        # defaults write com.apple.iTunes disablePingSidebar -bool true
        
        # echo "Disable all the other Ping stuff in iTunes"
        # defaults write com.apple.iTunes disablePing -bool true
        
        # echo "Make ⌘ + F focus the search input in iTunes"
        # defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"
        
        # Disable send and reply animations in Mail.app
        # defaults write com.apple.Mail DisableReplyAnimations -bool true
        # defaults write com.apple.Mail DisableSendAnimations -bool true
        
        # Disable Resume system-wide
        # defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
        
        # echo "Disable the “reopen windows when logging back in” option"
        # This works, although the checkbox will still appear to be checked.
        # defaults write com.apple.loginwindow TALLogoutSavesState -bool false
        # defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
        
        # echo "Enable Dashboard dev mode (allows keeping widgets on the desktop)"
        # defaults write com.apple.dashboard devmode -bool true
        
        # echo "Reset Launchpad"
        # [ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db
        
        # echo "Disable local Time Machine backups"
        # hash tmutil &> /dev/null && sudo tmutil disablelocal
        
        # echo "Remove Dropbox’s green checkmark icons in Finder"
        # file=/Applications/Dropbox.app/Contents/Resources/check.icns
        # [ -e "$file" ] && mv -f "$file" "$file.bak"
        # unset file
        
        # Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)
        # Commented out, as this is known to cause problems when saving files in Adobe Illustrator CS5 :(
        # echo "0x08000100:0" > ~/.CFUserTextEncoding

        echo "Kill affected applications"

        for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
    else
        warning "macOS not detected. Skipping."
    fi
}

setup_applications() {
    title "Configuring applications"

    info "Install ranger-fm and neovim python libraries"
    pip3 install ranger-fm pynvim

	if pip3 list | grep neovim-remote > /dev/null 2>&1; then
	    echo "neovim-remote already installed... skipping."
	else
	  pip3 install neovim-remote
	fi

    info "Install docker"
    docker-machine create --driver virtualbox default

}

case "$1" in
    backup)
        backup
        ;;
    link)
        setup_symlinks
        ;;
    git)
        setup_git
        ;;
    homebrew)
        setup_homebrew
        ;;
    shell)
        setup_shell
        ;;
    terminfo)
        setup_terminfo
        ;;
    macos)
        setup_macos
        ;;
    applications)
        setup_applications
        ;;
    all)
        setup_symlinks
        setup_terminfo
        setup_homebrew
        setup_shell
        setup_git
        setup_macos
        setup_applications
        ;;
    *)
        echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|terminfo|macos|applications|all}\n"
        exit 1
        ;;
esac

echo -e
success "Done."
