#!/usr/bin/env bash
# Lesson: Keybindings

lesson_info() {
    LESSON_TITLE="Custom Keybindings"
    LESSON_MODULE="03-customization"
    LESSON_DESCRIPTION="Create and customize tmux keybindings for a more efficient workflow."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="03-customization/01-tmux-conf-basics"
}

lesson_run() {
    engine_section "The bind-key Command"

    engine_teach "Customize what happens when you press keys in tmux:"
    echo ""
    ui_command "bind-key <key> <command>" "Basic syntax"
    ui_command "bind <key> <command>" "Short form"
    echo ""

    engine_teach "By default, bindings use the prefix key. So 'bind x kill-pane'
means Prefix + x runs kill-pane."

    engine_pause

    engine_section "Changing the Prefix Key"

    engine_teach "Many users change the prefix from Ctrl+b to Ctrl+a (easier to reach):"
    echo ""
    printf "  ${C_WHITE}# Change prefix to Ctrl+a${C_RESET}\n"
    printf "  ${C_WHITE}unbind C-b${C_RESET}\n"
    printf "  ${C_WHITE}set -g prefix C-a${C_RESET}\n"
    printf "  ${C_WHITE}bind C-a send-prefix${C_RESET}\n"
    echo ""

    engine_teach "The 'send-prefix' line ensures that pressing Ctrl+a twice sends
a literal Ctrl+a to the underlying program (useful in bash for
going to start of line)."

    engine_pause

    engine_section "Intuitive Split Keys"

    engine_teach "The default split keys (% and \") are hard to remember. Many users
rebind them to more intuitive keys:"
    echo ""
    printf "  ${C_WHITE}# Split with | and -${C_RESET}\n"
    printf "  ${C_WHITE}bind | split-window -h${C_RESET}\n"
    printf "  ${C_WHITE}bind - split-window -v${C_RESET}\n"
    echo ""
    printf "  ${C_WHITE}# Or with \\ and - (no shift needed)${C_RESET}\n"
    printf "  ${C_WHITE}bind \\\\ split-window -h${C_RESET}\n"
    printf "  ${C_WHITE}bind - split-window -v${C_RESET}\n"
    echo ""

    engine_teach "You can also split in the current directory:"
    echo ""
    printf "  ${C_WHITE}bind | split-window -h -c '#{pane_current_path}'${C_RESET}\n"
    printf "  ${C_WHITE}bind - split-window -v -c '#{pane_current_path}'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Binding Without Prefix"

    engine_teach "Use -n flag to bind keys without the prefix:"
    echo ""
    ui_command "bind -n M-Left select-pane -L" "Alt+Left to switch pane"
    ui_command "bind -n M-Right select-pane -R" "Alt+Right to switch pane"
    ui_command "bind -n M-Up select-pane -U" "Alt+Up to switch pane"
    ui_command "bind -n M-Down select-pane -D" "Alt+Down to switch pane"
    echo ""

    engine_teach "M- means Alt/Meta key. This gives you instant pane switching
without pressing the prefix first."
    echo ""
    ui_warn "Be careful with prefix-less bindings - they can conflict with other programs."

    engine_pause

    engine_section "Key Tables"

    engine_teach "tmux organizes bindings into 'key tables':"
    echo ""
    printf "  ${C_BOLD}prefix${C_RESET}        Keys pressed after the prefix\n"
    printf "  ${C_BOLD}root${C_RESET}          Keys pressed without prefix (-n flag)\n"
    printf "  ${C_BOLD}copy-mode-vi${C_RESET}  Keys in vi copy mode\n"
    printf "  ${C_BOLD}copy-mode${C_RESET}     Keys in emacs copy mode\n"
    echo ""

    engine_teach "Specify a table with -T:"
    echo ""
    ui_command "bind -T copy-mode-vi v send -X begin-selection" "vi: v to select"
    ui_command "bind -T copy-mode-vi y send -X copy-selection" "vi: y to yank"
    echo ""

    engine_pause

    engine_section "Repeated Keys"

    engine_teach "Use -r flag for keys that can be pressed repeatedly:"
    echo ""
    printf "  ${C_WHITE}# Resize panes with repeatable keys${C_RESET}\n"
    printf "  ${C_WHITE}bind -r H resize-pane -L 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r J resize-pane -D 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r K resize-pane -U 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r L resize-pane -R 5${C_RESET}\n"
    echo ""

    engine_teach "After pressing the prefix once, you can keep pressing the key
within the repeat-time window (default 500ms)."

    engine_pause

    engine_section "Viewing and Removing Bindings"

    engine_teach "See all current bindings:"
    echo ""
    ui_command "tmux list-keys" "List all keybindings"
    ui_command "tmux list-keys -T prefix" "List only prefix table"
    ui_keybinding "Prefix" "?" "Show keybindings (interactive)"
    echo ""

    engine_teach "Remove a binding:"
    echo ""
    ui_command "tmux unbind-key x" "Remove Prefix + x binding"
    ui_command "tmux unbind-key -n M-Left" "Remove Alt+Left binding"
    echo ""

    engine_pause

    engine_section "Useful Custom Bindings"

    engine_teach "Here are some popular custom bindings:"
    echo ""
    printf "  ${C_WHITE}# Reload config${C_RESET}\n"
    printf "  ${C_WHITE}bind r source-file ~/.tmux.conf \\; display 'Reloaded!'${C_RESET}\n\n"
    printf "  ${C_WHITE}# Quick pane cycling${C_RESET}\n"
    printf "  ${C_WHITE}bind -n C-o select-pane -t :.+${C_RESET}\n\n"
    printf "  ${C_WHITE}# Synchronize panes (type in all panes at once)${C_RESET}\n"
    printf "  ${C_WHITE}bind S setw synchronize-panes${C_RESET}\n\n"
    printf "  ${C_WHITE}# New window in current directory${C_RESET}\n"
    printf "  ${C_WHITE}bind c new-window -c '#{pane_current_path}'${C_RESET}\n"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "keybindings-1" \
        "Create a Custom Binding" \
        "Bind 'Prefix + R' to reload the tmux config.

Run this command:
  tmux bind R source-file ~/.tmux.conf

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux bind R source-file ~/.tmux.conf" \
        "none"

    engine_teach "Custom keybindings make tmux feel like YOUR tool. Everyone's
ideal setup is different - experiment and find what works for you."
}

verify_exercise_1() {
    verify_keybinding " R " "source-file"
}
