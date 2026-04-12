# Lesson: Colors and Themes

function Lesson-Info {
    Set-LessonInfo `
        -Title "Colors, Themes, and Visual Styling" `
        -Module "03-customization" `
        -Description "Style every part of tmux with colors, borders, and complete themes." `
        -Time "8 minutes" `
        -Prerequisites "03-customization/03-status-bar"
}

function Lesson-Run {
    Engine-Section "Terminal Colors in tmux"

    Engine-Teach "For full color support, set the correct terminal type:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# In tmux.conf${C_RESET}"
    Write-Host "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# For true color (24-bit) support${C_RESET}"
    Write-Host "  ${C_WHITE}set -as terminal-overrides ',*256col*:Tc'${C_RESET}"
    Write-Host ""

    Engine-Teach "If colors look wrong in vim/neovim, these settings usually fix it."

    Engine-Pause

    Engine-Section "Pane Border Styling"

    Engine-Teach "Customize the lines between panes:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Border colors${C_RESET}"
    Write-Host "  ${C_WHITE}set -g pane-border-style fg=colour238${C_RESET}"
    Write-Host "  ${C_WHITE}set -g pane-active-border-style fg=colour46${C_RESET}"
    Write-Host ""

    Engine-Teach "In tmux 3.2+, you can also show pane border indicators:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set -g pane-border-indicators colour${C_RESET}"
    Write-Host "  ${C_WHITE}set -g pane-border-lines heavy${C_RESET}  ${C_DIM}# single, double, heavy, simple, number${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Message and Command Prompt Style"

    Engine-Teach "Style the tmux message bar and command prompt:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Message display style${C_RESET}"
    Write-Host "  ${C_WHITE}set -g message-style fg=colour226,bg=colour235,bold${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Command prompt style${C_RESET}"
    Write-Host "  ${C_WHITE}set -g message-command-style fg=colour75,bg=colour235${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Copy Mode Styling"

    Engine-Teach "Change the look of copy mode:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set -g mode-style fg=colour235,bg=colour226${C_RESET}"
    Write-Host ""

    Engine-Teach "This controls the selection highlight color in copy mode."

    Engine-Pause

    Engine-Section "Clock and Display Panes"

    Engine-Teach "Even small details can be customized:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Clock style (Prefix + t)${C_RESET}"
    Write-Host "  ${C_WHITE}set -g clock-mode-colour colour46${C_RESET}"
    Write-Host "  ${C_WHITE}set -g clock-mode-style 24${C_RESET}  ${C_DIM}# 12 or 24 hour${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Pane number display (Prefix + q)${C_RESET}"
    Write-Host "  ${C_WHITE}set -g display-panes-active-colour colour46${C_RESET}"
    Write-Host "  ${C_WHITE}set -g display-panes-colour colour226${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Popular Themes"

    Engine-Teach "Several pre-made themes are available as plugins:"

    Write-Host ""
    Write-Host "  ${C_BOLD}Dracula${C_RESET}    - Dark theme with vibrant colors"
    Write-Host "              github.com/dracula/tmux"
    Write-Host ""
    Write-Host "  ${C_BOLD}Catppuccin${C_RESET} - Pastel theme with multiple flavors"
    Write-Host "              github.com/catppuccin/tmux"
    Write-Host ""
    Write-Host "  ${C_BOLD}Nord${C_RESET}       - Arctic color palette"
    Write-Host "              github.com/nordtheme/tmux"
    Write-Host ""
    Write-Host "  ${C_BOLD}Tokyo Night${C_RESET} - VS Code Tokyo Night port"
    Write-Host "              github.com/janoamaral/tokyo-night-tmux"
    Write-Host ""

    Engine-Teach "We'll cover installing plugins in the Advanced module."

    Engine-Pause

    Engine-Section "Complete Theme Example"

    Engine-Teach "Here's a complete minimal dark theme you can use as a starting point:"

    Write-Host ""
    Write-Host "  ${C_GREEN}# -- Colors --${C_RESET}"
    Write-Host "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Status bar${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-style bg='#1a1b26',fg='#a9b1d6'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-left '#[fg=#7aa2f7,bold] #S '${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-right '#[fg=#bb9af7]%H:%M '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Windows${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-format ' #[fg=#565f89]#I:#W '${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-current-format ' #[fg=#7aa2f7,bold]#I:#W '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Panes${C_RESET}"
    Write-Host "  ${C_WHITE}set -g pane-border-style fg='#3b4261'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g pane-active-border-style fg='#7aa2f7'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Messages${C_RESET}"
    Write-Host "  ${C_WHITE}set -g message-style fg='#7aa2f7',bg='#1a1b26'${C_RESET}"
    Write-Host ""

    Engine-Pause

    # -- Exercise --
    Engine-Exercise `
        -ExerciseId "colors-1" `
        -Title "Style the Active Pane Border" `
        -Instructions @"
Change the active pane border color to green.

Run this command:
  tmux set -g pane-active-border-style fg=green

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset
            $style = $null
            try {
                $style = (tmux show-options -gv pane-active-border-style 2>$null)
            } catch {}

            if ($style -and $style -match "green") {
                Set-VerifyMessage "Active pane border is set to green"
                return $true
            } else {
                Set-VerifyMessage "Active pane border style is '$style', expected something with 'green'"
                Set-VerifyHint "Run: tmux set -g pane-active-border-style fg=green"
                return $false
            }
        } `
        -Hint "Run: tmux set -g pane-active-border-style fg=green" `
        -UseSandbox "none"

    Engine-Teach @"
You've completed the Customization module! Your tmux can now look
and feel exactly the way you want. Next up: Scripting - where you'll
learn to automate tmux with shell scripts.
"@
}
