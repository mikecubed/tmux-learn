#!/usr/bin/env bash
# Lesson: Status Bar Customization

lesson_info() {
    LESSON_TITLE="Customizing the Status Bar"
    LESSON_MODULE="03-customization"
    LESSON_DESCRIPTION="Design a custom status bar with colors, segments, and dynamic content."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="03-customization/02-keybindings"
}

lesson_run() {
    engine_section "Status Bar Anatomy"

    engine_teach "The status bar at the bottom of tmux has three parts:"

    echo ""
    printf "${C_CYAN}"
    cat << 'DIAGRAM'

    ┌─────────────────────────────────────────────────────┐
    │ LEFT          CENTER (windows)              RIGHT   │
    │ [session]   0:bash  1:vim* 2:logs          12:34 PM │
    └─────────────────────────────────────────────────────┘

DIAGRAM
    printf "${C_RESET}"

    printf "  ${C_BOLD}status-left${C_RESET}     Left side content\n"
    printf "  ${C_BOLD}window-status${C_RESET}   Window list in the center\n"
    printf "  ${C_BOLD}status-right${C_RESET}    Right side content\n"
    echo ""

    engine_pause

    engine_section "Basic Status Bar Options"

    engine_teach "Control the status bar appearance:"
    echo ""
    ui_command "set -g status on" "Show status bar (default)"
    ui_command "set -g status off" "Hide status bar"
    ui_command "set -g status-position top" "Move to top of screen"
    ui_command "set -g status-interval 5" "Update every 5 seconds"
    ui_command "set -g status-justify centre" "Center the window list"
    echo ""

    engine_pause

    engine_section "Format Strings"

    engine_teach "tmux uses special format variables (like #{variable}):"
    echo ""
    printf "  ${C_BOLD}#{session_name}${C_RESET}      Current session name\n"
    printf "  ${C_BOLD}#{window_index}${C_RESET}      Window number\n"
    printf "  ${C_BOLD}#{window_name}${C_RESET}       Window name\n"
    printf "  ${C_BOLD}#{pane_current_path}${C_RESET} Current directory\n"
    printf "  ${C_BOLD}#{host}${C_RESET}              Hostname\n"
    printf "  ${C_BOLD}#{pane_current_command}${C_RESET} Running command\n"
    echo ""

    engine_teach "Use #() to run shell commands:"
    echo ""
    printf "  ${C_BOLD}#(whoami)${C_RESET}            Current user\n"
    printf "  ${C_BOLD}#(date +%%H:%%M)${C_RESET}       Current time\n"
    printf "  ${C_BOLD}#(uptime | ...)${C_RESET}      System uptime\n"
    echo ""

    engine_pause

    engine_section "Customizing Left and Right"

    engine_teach "Set the content of each section:"
    echo ""
    printf "  ${C_WHITE}set -g status-left-length 40${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-left '#[fg=green,bold][#S] '${C_RESET}\n"
    echo ""
    printf "  ${C_WHITE}set -g status-right-length 60${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-right '#[fg=yellow]%%H:%%M #[fg=cyan]%%d-%%b-%%Y'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Color Styling"

    engine_teach "Apply colors and styles with #[...] markers:"
    echo ""
    printf "  ${C_BOLD}#[fg=red]${C_RESET}          Set foreground color\n"
    printf "  ${C_BOLD}#[bg=blue]${C_RESET}         Set background color\n"
    printf "  ${C_BOLD}#[bold]${C_RESET}            Bold text\n"
    printf "  ${C_BOLD}#[italics]${C_RESET}         Italic text\n"
    printf "  ${C_BOLD}#[underscore]${C_RESET}      Underlined text\n"
    printf "  ${C_BOLD}#[default]${C_RESET}         Reset to default style\n"
    echo ""

    engine_teach "Available colors: black, red, green, yellow, blue, magenta,
cyan, white, default, colour0-colour255, or hex #rrggbb"

    engine_pause

    engine_section "Window Status Format"

    engine_teach "Customize how windows appear in the status bar:"
    echo ""
    printf "  ${C_WHITE}# Format for inactive windows${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-format ' #I:#W '${C_RESET}\n\n"
    printf "  ${C_WHITE}# Format for the active window${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-current-format ' #[bold]#I:#W* '${C_RESET}\n\n"
    printf "  ${C_WHITE}# Style for active window${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-current-style fg=white,bg=blue,bold${C_RESET}\n"
    echo ""

    engine_teach "#I is the window index, #W is the window name."

    engine_pause

    engine_section "Example: Clean Modern Status Bar"

    engine_teach "Here's a complete modern-looking status bar configuration:"

    echo ""
    printf "  ${C_GREEN}# Status bar colors${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-style bg=colour235,fg=colour136${C_RESET}\n\n"
    printf "  ${C_GREEN}# Left: session name${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-left '#[fg=colour46,bold] #S '${C_RESET}\n\n"
    printf "  ${C_GREEN}# Right: user@host and time${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-right '#[fg=colour75]#(whoami)@#H #[fg=colour226]%%H:%%M '${C_RESET}\n\n"
    printf "  ${C_GREEN}# Active window${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-current-style fg=colour46,bg=colour238,bold${C_RESET}\n"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "status-bar-1" \
        "Customize the Status Bar" \
        "Move the status bar to the top of the screen.

Run this command:
  tmux set -g status-position top

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux set -g status-position top" \
        "none"

    # Reset status position
    tmux set -g status-position bottom 2>/dev/null

    engine_teach "The status bar is your tmux dashboard. A well-configured status
bar gives you quick access to essential information at a glance."
}

verify_exercise_1() {
    verify_option_set "status-position" "top"
}
