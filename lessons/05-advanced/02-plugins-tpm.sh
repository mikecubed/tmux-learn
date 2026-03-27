#!/usr/bin/env bash
# Lesson: Plugins and TPM

lesson_info() {
    LESSON_TITLE="Plugins and TPM (Tmux Plugin Manager)"
    LESSON_MODULE="05-advanced"
    LESSON_DESCRIPTION="Extend tmux with plugins using TPM, the tmux plugin manager."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="05-advanced/01-hooks"
}

lesson_run() {
    engine_section "The tmux Plugin Ecosystem"

    engine_teach "tmux has a rich ecosystem of plugins that add features like:
  - Session persistence (survive reboots)
  - Vim-like pane navigation
  - Clipboard integration
  - Status bar widgets
  - Themes and color schemes"

    engine_pause

    engine_section "Installing TPM"

    engine_teach "TPM (Tmux Plugin Manager) is the standard way to manage plugins:"
    echo ""
    ui_command "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" ""
    echo ""

    engine_teach "Then add to the bottom of your ~/.tmux.conf:"

    echo ""
    printf "  ${C_WHITE}# List of plugins${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tpm'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-sensible'${C_RESET}\n\n"
    printf "  ${C_WHITE}# Initialize TPM (keep this at the very bottom)${C_RESET}\n"
    printf "  ${C_WHITE}run '~/.tmux/plugins/tpm/tpm'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Managing Plugins"

    engine_teach "TPM keybindings (after prefix):"
    echo ""
    ui_keybinding "Prefix" "I" "Install new plugins"
    ui_keybinding "Prefix" "U" "Update plugins"
    ui_keybinding "Prefix" "Alt+u" "Uninstall removed plugins"
    echo ""

    engine_teach "Add a plugin by adding a set -g @plugin line to tmux.conf,
then press Prefix + I to install it."

    engine_pause

    engine_section "Essential Plugins"

    engine_teach "Here are the most popular and useful plugins:"

    echo ""
    printf "  ${C_BOLD}${C_CYAN}tmux-sensible${C_RESET}\n"
    printf "  ${C_DIM}  tmux-plugins/tmux-sensible${C_RESET}\n"
    printf "  A set of reasonable default options. Addresses common\n"
    printf "  annoyances without being opinionated.\n\n"

    printf "  ${C_BOLD}${C_CYAN}tmux-resurrect${C_RESET}\n"
    printf "  ${C_DIM}  tmux-plugins/tmux-resurrect${C_RESET}\n"
    printf "  Save and restore tmux sessions across reboots.\n"
    printf "  ${C_WHITE}  Prefix + Ctrl+s${C_RESET}  Save sessions\n"
    printf "  ${C_WHITE}  Prefix + Ctrl+r${C_RESET}  Restore sessions\n\n"

    printf "  ${C_BOLD}${C_CYAN}tmux-continuum${C_RESET}\n"
    printf "  ${C_DIM}  tmux-plugins/tmux-continuum${C_RESET}\n"
    printf "  Automatic saving and restoring. Works with tmux-resurrect.\n"
    printf "  Auto-saves every 15 minutes, restores on tmux server start.\n\n"

    printf "  ${C_BOLD}${C_CYAN}tmux-yank${C_RESET}\n"
    printf "  ${C_DIM}  tmux-plugins/tmux-yank${C_RESET}\n"
    printf "  Copy to system clipboard. Works on macOS, Linux, WSL.\n"
    printf "  Integrates with copy mode automatically.\n"
    echo ""

    engine_pause

    printf "  ${C_BOLD}${C_CYAN}tmux-pain-control${C_RESET}\n"
    printf "  ${C_DIM}  tmux-plugins/tmux-pain-control${C_RESET}\n"
    printf "  Better pane navigation and resizing keybindings.\n"
    printf "  Adds intuitive mappings for splits and movement.\n\n"

    printf "  ${C_BOLD}${C_CYAN}vim-tmux-navigator${C_RESET}\n"
    printf "  ${C_DIM}  christoomey/vim-tmux-navigator${C_RESET}\n"
    printf "  Seamless navigation between vim splits and tmux panes.\n"
    printf "  Ctrl+h/j/k/l works in both vim and tmux.\n\n"

    printf "  ${C_BOLD}${C_CYAN}tmux-fzf${C_RESET}\n"
    printf "  ${C_DIM}  sainnhe/tmux-fzf${C_RESET}\n"
    printf "  Use fzf for fuzzy-finding sessions, windows, panes,\n"
    printf "  and keybindings.\n"
    echo ""

    engine_pause

    engine_section "Example Plugin Configuration"

    engine_teach "A complete tmux.conf with popular plugins:"

    echo ""
    printf "  ${C_WHITE}# Plugins${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tpm'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-sensible'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-resurrect'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-continuum'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-yank'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @plugin 'christoomey/vim-tmux-navigator'${C_RESET}\n\n"

    printf "  ${C_WHITE}# Plugin settings${C_RESET}\n"
    printf "  ${C_WHITE}set -g @continuum-restore 'on'${C_RESET}\n"
    printf "  ${C_WHITE}set -g @resurrect-capture-pane-contents 'on'${C_RESET}\n\n"

    printf "  ${C_WHITE}# Initialize TPM (must be last)${C_RESET}\n"
    printf "  ${C_WHITE}run '~/.tmux/plugins/tpm/tpm'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Writing Your Own Plugin"

    engine_teach "A tmux plugin is just a shell script. The basic structure:"

    echo ""
    printf "  ${C_DIM}~/.tmux/plugins/my-plugin/${C_RESET}\n"
    printf "  ${C_DIM}├── my-plugin.tmux${C_RESET}     ${C_DIM}# Entry point (sourced by TPM)${C_RESET}\n"
    printf "  ${C_DIM}└── scripts/${C_RESET}\n"
    printf "  ${C_DIM}    └── helpers.sh${C_RESET}\n"
    echo ""

    engine_teach "The .tmux file is executed when the plugin loads. It typically
sets keybindings and configures hooks."

    engine_pause

    engine_teach "Plugins extend tmux's capabilities significantly. Start with
tmux-sensible and tmux-resurrect, then add more as needed."

    engine_section "Quick Quiz"

    engine_quiz "What key installs plugins in TPM?" \
        "Prefix + i" "Prefix + I (capital)" "Prefix + p" "Prefix + P" \
        2

    echo ""

    engine_quiz "Which plugin saves sessions across reboots?" \
        "tmux-sensible" "tmux-yank" "tmux-resurrect" "tmux-continuum" \
        3
}
