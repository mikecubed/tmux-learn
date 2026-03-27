#!/usr/bin/env bash
# Lesson: tmux.conf Basics

lesson_info() {
    LESSON_TITLE="Introduction to tmux.conf"
    LESSON_MODULE="03-customization"
    LESSON_DESCRIPTION="Learn to configure tmux with the tmux.conf configuration file."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="02-navigation/04-copy-mode"
}

lesson_run() {
    engine_section "The Configuration File"

    engine_teach "tmux reads its configuration from ~/.tmux.conf at startup.
This file contains tmux commands that run automatically when
the server starts."
    echo ""
    ui_command "~/.tmux.conf" "User configuration file"
    ui_command "/etc/tmux.conf" "System-wide configuration"
    echo ""

    engine_teach "Any tmux command you run manually can be placed in tmux.conf
to make it permanent. Lines starting with # are comments."

    engine_pause

    engine_section "Basic Configuration"

    engine_teach "Here's a starter tmux.conf with common settings:"

    echo ""
    printf "  ${C_GREEN}# ~/.tmux.conf${C_RESET}\n\n"
    printf "  ${C_CYAN}# Use vi keybindings in copy mode${C_RESET}\n"
    printf "  ${C_WHITE}set -g mode-keys vi${C_RESET}\n\n"
    printf "  ${C_CYAN}# Increase scrollback buffer${C_RESET}\n"
    printf "  ${C_WHITE}set -g history-limit 10000${C_RESET}\n\n"
    printf "  ${C_CYAN}# Start window numbering at 1 (not 0)${C_RESET}\n"
    printf "  ${C_WHITE}set -g base-index 1${C_RESET}\n"
    printf "  ${C_WHITE}setw -g pane-base-index 1${C_RESET}\n\n"
    printf "  ${C_CYAN}# Enable mouse support${C_RESET}\n"
    printf "  ${C_WHITE}set -g mouse on${C_RESET}\n\n"
    printf "  ${C_CYAN}# Reduce escape delay (important for vim/neovim)${C_RESET}\n"
    printf "  ${C_WHITE}set -sg escape-time 10${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Reloading Configuration"

    engine_teach "After editing tmux.conf, reload it without restarting tmux:"
    echo ""
    ui_command "tmux source-file ~/.tmux.conf" "Reload from command line"
    echo ""

    engine_teach "Or from inside tmux (Prefix + :):"
    echo ""
    ui_command ":source-file ~/.tmux.conf" "Reload from command mode"
    echo ""

    engine_teach "A common practice is to bind a key to reload the config:"
    echo ""
    printf "  ${C_WHITE}bind r source-file ~/.tmux.conf \\; display 'Config reloaded!'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Set vs Setw"

    engine_teach "tmux has two types of options:"
    echo ""
    printf "  ${C_BOLD}set -g${C_RESET}     Server/session options (affect all sessions)\n"
    printf "  ${C_BOLD}setw -g${C_RESET}    Window options (affect all windows)\n"
    echo ""

    engine_teach "Common session options:"
    echo ""
    ui_command "set -g prefix C-a" "Change prefix key"
    ui_command "set -g default-terminal 'screen-256color'" "Set terminal type"
    ui_command "set -g status-position top" "Move status bar to top"
    echo ""

    engine_teach "Common window options:"
    echo ""
    ui_command "setw -g automatic-rename on" "Auto-rename windows"
    ui_command "setw -g monitor-activity on" "Monitor for activity"
    echo ""

    engine_pause

    engine_section "Conditional Configuration"

    engine_teach "You can use if-shell for platform-specific config:"
    echo ""
    printf "  ${C_WHITE}if-shell 'uname | grep -q Darwin' \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  'bind -T copy-mode-vi y send -X copy-pipe-and-cancel \"pbcopy\"'${C_RESET}\n"
    echo ""

    engine_teach "Or check tmux version:"
    echo ""
    printf "  ${C_WHITE}if-shell '[ \"\$(tmux -V | cut -d\" \" -f2 | tr -d a-z)\" -ge 32 ]' \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  'set -g pane-border-indicators colour'${C_RESET}\n"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_teach "Let's practice changing a tmux option."

    engine_exercise \
        "tmux-conf-1" \
        "Change a tmux Setting" \
        "Set the base-index to 1 (so windows start
numbering at 1 instead of 0).

Run this command in any pane:
  tmux set -g base-index 1

Then type 'check' here to verify." \
        verify_exercise_1 \
        "Run: tmux set -g base-index 1" \
        "none"

    engine_teach "You now know how to configure tmux. In the next lesson, you'll
learn to customize keybindings for maximum productivity."
}

verify_exercise_1() {
    verify_option_set "base-index" "1"
}
