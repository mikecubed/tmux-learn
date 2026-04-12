# Lesson: Status Bar Customization

function Lesson-Info {
    Set-LessonInfo `
        -Title "Customizing the Status Bar" `
        -Module "03-customization" `
        -Description "Design a custom status bar with colors, segments, and dynamic content." `
        -Time "10 minutes" `
        -Prerequisites "03-customization/02-keybindings"
}

function Lesson-Run {
    Engine-Section "Status Bar Anatomy"

    Engine-Teach "The status bar at the bottom of tmux has three parts:"

    Write-Host ""
    Write-Host "${C_CYAN}"
    Write-Host "    +-----------------------------------------------------+"
    Write-Host "    | LEFT          CENTER (windows)              RIGHT    |"
    Write-Host "    | [session]   0:bash  1:vim* 2:logs          12:34 PM  |"
    Write-Host "    +-----------------------------------------------------+"
    Write-Host ""
    Write-Host "${C_RESET}"

    Write-Host "  ${C_BOLD}status-left${C_RESET}     Left side content"
    Write-Host "  ${C_BOLD}window-status${C_RESET}   Window list in the center"
    Write-Host "  ${C_BOLD}status-right${C_RESET}    Right side content"
    Write-Host ""

    Engine-Pause

    Engine-Section "Basic Status Bar Options"

    Engine-Teach "Control the status bar appearance:"
    Write-Host ""
    UI-Command "set -g status on" "Show status bar (default)"
    UI-Command "set -g status off" "Hide status bar"
    UI-Command "set -g status-position top" "Move to top of screen"
    UI-Command "set -g status-interval 5" "Update every 5 seconds"
    UI-Command "set -g status-justify centre" "Center the window list"
    Write-Host ""

    Engine-Pause

    Engine-Section "Format Strings"

    Engine-Teach "tmux uses special format variables (like #{variable}):"
    Write-Host ""
    Write-Host "  ${C_BOLD}#{session_name}${C_RESET}      Current session name"
    Write-Host "  ${C_BOLD}#{window_index}${C_RESET}      Window number"
    Write-Host "  ${C_BOLD}#{window_name}${C_RESET}       Window name"
    Write-Host "  ${C_BOLD}#{pane_current_path}${C_RESET} Current directory"
    Write-Host "  ${C_BOLD}#{host}${C_RESET}              Hostname"
    Write-Host "  ${C_BOLD}#{pane_current_command}${C_RESET} Running command"
    Write-Host ""

    Engine-Teach "Use #() to run shell commands:"
    Write-Host ""
    Write-Host "  ${C_BOLD}#(whoami)${C_RESET}            Current user"
    Write-Host "  ${C_BOLD}#(date +%%H:%%M)${C_RESET}       Current time"
    Write-Host "  ${C_BOLD}#(uptime | ...)${C_RESET}      System uptime"
    Write-Host ""

    Engine-Pause

    Engine-Section "Customizing Left and Right"

    Engine-Teach "Set the content of each section:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set -g status-left-length 40${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-left '#[fg=green,bold][#S] '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}set -g status-right-length 60${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-right '#[fg=yellow]%H:%M #[fg=cyan]%d-%b-%Y'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Color Styling"

    Engine-Teach "Apply colors and styles with #[...] markers:"
    Write-Host ""
    Write-Host "  ${C_BOLD}#[fg=red]${C_RESET}          Set foreground color"
    Write-Host "  ${C_BOLD}#[bg=blue]${C_RESET}         Set background color"
    Write-Host "  ${C_BOLD}#[bold]${C_RESET}            Bold text"
    Write-Host "  ${C_BOLD}#[italics]${C_RESET}         Italic text"
    Write-Host "  ${C_BOLD}#[underscore]${C_RESET}      Underlined text"
    Write-Host "  ${C_BOLD}#[default]${C_RESET}         Reset to default style"
    Write-Host ""

    Engine-Teach @"
Available colors: black, red, green, yellow, blue, magenta,
cyan, white, default, colour0-colour255, or hex #rrggbb
"@

    Engine-Pause

    Engine-Section "Window Status Format"

    Engine-Teach "Customize how windows appear in the status bar:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Format for inactive windows${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-format ' #I:#W '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Format for the active window${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-current-format ' #[bold]#I:#W* '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Style for active window${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-current-style fg=white,bg=blue,bold${C_RESET}"
    Write-Host ""

    Engine-Teach "#I is the window index, #W is the window name."

    Engine-Pause

    Engine-Section "Example: Clean Modern Status Bar"

    Engine-Teach "Here's a complete modern-looking status bar configuration:"

    Write-Host ""
    Write-Host "  ${C_GREEN}# Status bar colors${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-style bg=colour235,fg=colour136${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Left: session name${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-left '#[fg=colour46,bold] #S '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Right: user@host and time${C_RESET}"
    Write-Host "  ${C_WHITE}set -g status-right '#[fg=colour75]#(whoami)@#H #[fg=colour226]%H:%M '${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Active window${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g window-status-current-style fg=colour46,bg=colour238,bold${C_RESET}"
    Write-Host ""

    Engine-Pause

    # -- Exercise --
    Engine-Exercise `
        -ExerciseId "status-bar-1" `
        -Title "Customize the Status Bar" `
        -Instructions @"
Move the status bar to the top of the screen.

Run this command:
  tmux set -g status-position top

Then type 'check' to verify.
"@ `
        -VerifyFunc { Verify-OptionSet "status-position" "top" } `
        -Hint "Run: tmux set -g status-position top" `
        -UseSandbox "none"

    # Reset status position
    tmux set -g status-position bottom 2>$null

    Engine-Teach @"
The status bar is your tmux dashboard. A well-configured status
bar gives you quick access to essential information at a glance.
"@
}
