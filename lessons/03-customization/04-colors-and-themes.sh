#!/usr/bin/env bash
# Lesson: Colors and Themes

lesson_info() {
    LESSON_TITLE="Colors, Themes, and Visual Styling"
    LESSON_MODULE="03-customization"
    LESSON_DESCRIPTION="Style every part of tmux with colors, borders, and complete themes."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="03-customization/03-status-bar"
}

lesson_run() {
    engine_section "Terminal Colors in tmux"

    engine_teach "For full color support, set the correct terminal type:"
    echo ""
    printf "  ${C_WHITE}# In tmux.conf${C_RESET}\n"
    printf "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}\n\n"
    printf "  ${C_WHITE}# For true color (24-bit) support${C_RESET}\n"
    printf "  ${C_WHITE}set -as terminal-overrides ',*256col*:Tc'${C_RESET}\n"
    echo ""

    engine_teach "If colors look wrong in vim/neovim, these settings usually fix it."

    engine_pause

    engine_section "Pane Border Styling"

    engine_teach "Customize the lines between panes:"
    echo ""
    printf "  ${C_WHITE}# Border colors${C_RESET}\n"
    printf "  ${C_WHITE}set -g pane-border-style fg=colour238${C_RESET}\n"
    printf "  ${C_WHITE}set -g pane-active-border-style fg=colour46${C_RESET}\n"
    echo ""

    engine_teach "In tmux 3.2+, you can also show pane border indicators:"
    echo ""
    printf "  ${C_WHITE}set -g pane-border-indicators colour${C_RESET}\n"
    printf "  ${C_WHITE}set -g pane-border-lines heavy${C_RESET}  ${C_DIM}# single, double, heavy, simple, number${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Message and Command Prompt Style"

    engine_teach "Style the tmux message bar and command prompt:"
    echo ""
    printf "  ${C_WHITE}# Message display style${C_RESET}\n"
    printf "  ${C_WHITE}set -g message-style fg=colour226,bg=colour235,bold${C_RESET}\n\n"
    printf "  ${C_WHITE}# Command prompt style${C_RESET}\n"
    printf "  ${C_WHITE}set -g message-command-style fg=colour75,bg=colour235${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Copy Mode Styling"

    engine_teach "Change the look of copy mode:"
    echo ""
    printf "  ${C_WHITE}set -g mode-style fg=colour235,bg=colour226${C_RESET}\n"
    echo ""

    engine_teach "This controls the selection highlight color in copy mode."

    engine_pause

    engine_section "Clock and Display Panes"

    engine_teach "Even small details can be customized:"
    echo ""
    printf "  ${C_WHITE}# Clock style (Prefix + t)${C_RESET}\n"
    printf "  ${C_WHITE}set -g clock-mode-colour colour46${C_RESET}\n"
    printf "  ${C_WHITE}set -g clock-mode-style 24${C_RESET}  ${C_DIM}# 12 or 24 hour${C_RESET}\n\n"
    printf "  ${C_WHITE}# Pane number display (Prefix + q)${C_RESET}\n"
    printf "  ${C_WHITE}set -g display-panes-active-colour colour46${C_RESET}\n"
    printf "  ${C_WHITE}set -g display-panes-colour colour226${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Popular Themes"

    engine_teach "Several pre-made themes are available as plugins:"

    echo ""
    printf "  ${C_BOLD}Dracula${C_RESET}    - Dark theme with vibrant colors\n"
    printf "              github.com/dracula/tmux\n\n"
    printf "  ${C_BOLD}Catppuccin${C_RESET} - Pastel theme with multiple flavors\n"
    printf "              github.com/catppuccin/tmux\n\n"
    printf "  ${C_BOLD}Nord${C_RESET}       - Arctic color palette\n"
    printf "              github.com/nordtheme/tmux\n\n"
    printf "  ${C_BOLD}Tokyo Night${C_RESET} - VS Code Tokyo Night port\n"
    printf "              github.com/janoamaral/tokyo-night-tmux\n"
    echo ""

    engine_teach "We'll cover installing plugins in the Advanced module."

    engine_pause

    engine_section "Complete Theme Example"

    engine_teach "Here's a complete minimal dark theme you can use as a starting point:"

    echo ""
    printf "  ${C_GREEN}# ── Colors ──${C_RESET}\n"
    printf "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}\n\n"
    printf "  ${C_GREEN}# Status bar${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-style bg='#1a1b26',fg='#a9b1d6'${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-left '#[fg=#7aa2f7,bold] #S '${C_RESET}\n"
    printf "  ${C_WHITE}set -g status-right '#[fg=#bb9af7]%%H:%%M '${C_RESET}\n\n"
    printf "  ${C_GREEN}# Windows${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-format ' #[fg=#565f89]#I:#W '${C_RESET}\n"
    printf "  ${C_WHITE}setw -g window-status-current-format ' #[fg=#7aa2f7,bold]#I:#W '${C_RESET}\n\n"
    printf "  ${C_GREEN}# Panes${C_RESET}\n"
    printf "  ${C_WHITE}set -g pane-border-style fg='#3b4261'${C_RESET}\n"
    printf "  ${C_WHITE}set -g pane-active-border-style fg='#7aa2f7'${C_RESET}\n\n"
    printf "  ${C_GREEN}# Messages${C_RESET}\n"
    printf "  ${C_WHITE}set -g message-style fg='#7aa2f7',bg='#1a1b26'${C_RESET}\n"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "colors-1" \
        "Style the Active Pane Border" \
        "Change the active pane border color to green.

Run this command:
  tmux set -g pane-active-border-style fg=green

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux set -g pane-active-border-style fg=green" \
        "none"

    engine_teach "You've completed the Customization module! Your tmux can now look
and feel exactly the way you want. Next up: Scripting - where you'll
learn to automate tmux with shell scripts."
}

verify_exercise_1() {
    verify_reset
    local style
    style=$(tmux show-options -gv pane-active-border-style 2>/dev/null)

    if echo "$style" | grep -qi "green"; then
        VERIFY_MESSAGE="Active pane border is set to green"
        return 0
    else
        VERIFY_MESSAGE="Active pane border style is '$style', expected something with 'green'"
        VERIFY_HINT="Run: tmux set -g pane-active-border-style fg=green"
        return 1
    fi
}
