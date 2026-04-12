# Lesson: tmux.conf Basics

function Lesson-Info {
    Set-LessonInfo `
        -Title "Introduction to tmux.conf" `
        -Module "03-customization" `
        -Description "Learn to configure tmux with the tmux.conf configuration file." `
        -Time "8 minutes" `
        -Prerequisites "02-navigation/04-copy-mode"
}

function Lesson-Run {
    Engine-Section "The Configuration File"

    Engine-Teach @"
tmux reads its configuration from ~/.tmux.conf at startup.
This file contains tmux commands that run automatically when
the server starts.
"@
    Write-Host ""
    UI-Command "~/.tmux.conf" "User configuration file"
    UI-Command "/etc/tmux.conf" "System-wide configuration"
    Write-Host ""

    Engine-Teach @"
Any tmux command you run manually can be placed in tmux.conf
to make it permanent. Lines starting with # are comments.
"@

    Engine-Pause

    Engine-Section "Basic Configuration"

    Engine-Teach "Here's a starter tmux.conf with common settings:"

    Write-Host ""
    Write-Host "  ${C_GREEN}# ~/.tmux.conf${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_CYAN}# Use vi keybindings in copy mode${C_RESET}"
    Write-Host "  ${C_WHITE}set -g mode-keys vi${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_CYAN}# Increase scrollback buffer${C_RESET}"
    Write-Host "  ${C_WHITE}set -g history-limit 10000${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_CYAN}# Start window numbering at 1 (not 0)${C_RESET}"
    Write-Host "  ${C_WHITE}set -g base-index 1${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g pane-base-index 1${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_CYAN}# Enable mouse support${C_RESET}"
    Write-Host "  ${C_WHITE}set -g mouse on${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_CYAN}# Reduce escape delay (important for vim/neovim)${C_RESET}"
    Write-Host "  ${C_WHITE}set -sg escape-time 10${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Reloading Configuration"

    Engine-Teach "After editing tmux.conf, reload it without restarting tmux:"
    Write-Host ""
    UI-Command "tmux source-file ~/.tmux.conf" "Reload from command line"
    Write-Host ""

    Engine-Teach "Or from inside tmux (Prefix + :):"
    Write-Host ""
    UI-Command ":source-file ~/.tmux.conf" "Reload from command mode"
    Write-Host ""

    Engine-Teach "A common practice is to bind a key to reload the config:"
    Write-Host ""
    Write-Host "  ${C_WHITE}bind r source-file ~/.tmux.conf \; display 'Config reloaded!'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Set vs Setw"

    Engine-Teach "tmux has two types of options:"
    Write-Host ""
    Write-Host "  ${C_BOLD}set -g${C_RESET}     Server/session options (affect all sessions)"
    Write-Host "  ${C_BOLD}setw -g${C_RESET}    Window options (affect all windows)"
    Write-Host ""

    Engine-Teach "Common session options:"
    Write-Host ""
    UI-Command "set -g prefix C-a" "Change prefix key"
    UI-Command "set -g default-terminal 'screen-256color'" "Set terminal type"
    UI-Command "set -g status-position top" "Move status bar to top"
    Write-Host ""

    Engine-Teach "Common window options:"
    Write-Host ""
    UI-Command "setw -g automatic-rename on" "Auto-rename windows"
    UI-Command "setw -g monitor-activity on" "Monitor for activity"
    Write-Host ""

    Engine-Pause

    Engine-Section "Conditional Configuration"

    Engine-Teach "You can use if-shell for platform-specific config:"
    Write-Host ""
    Write-Host "  ${C_WHITE}if-shell 'uname | grep -q Darwin' \${C_RESET}"
    Write-Host "  ${C_WHITE}  'bind -T copy-mode-vi y send -X copy-pipe-and-cancel `"pbcopy`"'${C_RESET}"
    Write-Host ""

    Engine-Teach "Or check tmux version:"
    Write-Host ""
    Write-Host "  ${C_WHITE}if-shell '[ `"`$(tmux -V | cut -d`" `" -f2 | tr -d a-z)`" -ge 32 ]' \${C_RESET}"
    Write-Host "  ${C_WHITE}  'set -g pane-border-indicators colour'${C_RESET}"
    Write-Host ""

    Engine-Pause

    # -- Exercise --
    Engine-Teach "Let's practice changing a tmux option."

    Engine-Exercise `
        -ExerciseId "tmux-conf-1" `
        -Title "Change a tmux Setting" `
        -Instructions @"
Set the base-index to 1 (so windows start
numbering at 1 instead of 0).

Run this command in any pane:
  tmux set -g base-index 1

Then type 'check' here to verify.
"@ `
        -VerifyFunc { Verify-OptionSet "base-index" "1" } `
        -Hint "Run: tmux set -g base-index 1" `
        -UseSandbox "none"

    Engine-Teach @"
You now know how to configure tmux. In the next lesson, you'll
learn to customize keybindings for maximum productivity.
"@
}
