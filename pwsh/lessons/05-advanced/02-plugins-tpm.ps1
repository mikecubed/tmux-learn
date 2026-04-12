# Lesson: Plugins and TPM (Tmux Plugin Manager)

function Lesson-Info {
    Set-LessonInfo `
        -Title "Plugins and TPM (Tmux Plugin Manager)" `
        -Module "05-advanced" `
        -Description "Extend tmux with plugins using TPM, the tmux plugin manager." `
        -Time "8 minutes" `
        -Prerequisites "05-advanced/01-hooks"
}

function Lesson-Run {
    Engine-Section "The tmux Plugin Ecosystem"

    Engine-Teach @"
tmux has a rich ecosystem of plugins that add features like:
  - Session persistence (survive reboots)
  - Vim-like pane navigation
  - Clipboard integration
  - Status bar widgets
  - Themes and color schemes
"@

    Engine-Pause

    Engine-Section "Installing TPM"

    Engine-Teach "TPM (Tmux Plugin Manager) is the standard way to manage plugins:"
    Write-Host ""
    UI-Command "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" ""
    Write-Host ""

    Engine-Teach "Then add to the bottom of your ~/.tmux.conf:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# List of plugins${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tpm'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-sensible'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Initialize TPM (keep this at the very bottom)${C_RESET}"
    Write-Host "  ${C_WHITE}run '~/.tmux/plugins/tpm/tpm'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Managing Plugins"

    Engine-Teach "TPM keybindings (after prefix):"
    Write-Host ""
    UI-Keybinding "Prefix" "I" "Install new plugins"
    UI-Keybinding "Prefix" "U" "Update plugins"
    UI-Keybinding "Prefix" "Alt+u" "Uninstall removed plugins"
    Write-Host ""

    Engine-Teach @"
Add a plugin by adding a set -g @plugin line to tmux.conf,
then press Prefix + I to install it.
"@

    Engine-Pause

    Engine-Section "Essential Plugins"

    Engine-Teach "Here are the most popular and useful plugins:"

    Write-Host ""
    Write-Host "  ${C_BOLD}${C_CYAN}tmux-sensible${C_RESET}"
    Write-Host "  ${C_DIM}  tmux-plugins/tmux-sensible${C_RESET}"
    Write-Host "  A set of reasonable default options. Addresses common"
    Write-Host "  annoyances without being opinionated."
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_CYAN}tmux-resurrect${C_RESET}"
    Write-Host "  ${C_DIM}  tmux-plugins/tmux-resurrect${C_RESET}"
    Write-Host "  Save and restore tmux sessions across reboots."
    Write-Host "  ${C_WHITE}  Prefix + Ctrl+s${C_RESET}  Save sessions"
    Write-Host "  ${C_WHITE}  Prefix + Ctrl+r${C_RESET}  Restore sessions"
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_CYAN}tmux-continuum${C_RESET}"
    Write-Host "  ${C_DIM}  tmux-plugins/tmux-continuum${C_RESET}"
    Write-Host "  Automatic saving and restoring. Works with tmux-resurrect."
    Write-Host "  Auto-saves every 15 minutes, restores on tmux server start."
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_CYAN}tmux-yank${C_RESET}"
    Write-Host "  ${C_DIM}  tmux-plugins/tmux-yank${C_RESET}"
    Write-Host "  Copy to system clipboard. Works on macOS, Linux, WSL."
    Write-Host "  Integrates with copy mode automatically."
    Write-Host ""

    Engine-Pause

    Write-Host "  ${C_BOLD}${C_CYAN}tmux-pain-control${C_RESET}"
    Write-Host "  ${C_DIM}  tmux-plugins/tmux-pain-control${C_RESET}"
    Write-Host "  Better pane navigation and resizing keybindings."
    Write-Host "  Adds intuitive mappings for splits and movement."
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_CYAN}vim-tmux-navigator${C_RESET}"
    Write-Host "  ${C_DIM}  christoomey/vim-tmux-navigator${C_RESET}"
    Write-Host "  Seamless navigation between vim splits and tmux panes."
    Write-Host "  Ctrl+h/j/k/l works in both vim and tmux."
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_CYAN}tmux-fzf${C_RESET}"
    Write-Host "  ${C_DIM}  sainnhe/tmux-fzf${C_RESET}"
    Write-Host "  Use fzf for fuzzy-finding sessions, windows, panes,"
    Write-Host "  and keybindings."
    Write-Host ""

    Engine-Pause

    Engine-Section "Example Plugin Configuration"

    Engine-Teach "A complete tmux.conf with popular plugins:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Plugins${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tpm'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-sensible'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-resurrect'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-continuum'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'tmux-plugins/tmux-yank'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @plugin 'christoomey/vim-tmux-navigator'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Plugin settings${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @continuum-restore 'on'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g @resurrect-capture-pane-contents 'on'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Initialize TPM (must be last)${C_RESET}"
    Write-Host "  ${C_WHITE}run '~/.tmux/plugins/tpm/tpm'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Writing Your Own Plugin"

    Engine-Teach "A tmux plugin is just a shell script. The basic structure:"

    Write-Host ""
    Write-Host "  ${C_DIM}~/.tmux/plugins/my-plugin/${C_RESET}"
    Write-Host "  ${C_DIM}├── my-plugin.tmux${C_RESET}     ${C_DIM}# Entry point (sourced by TPM)${C_RESET}"
    Write-Host "  ${C_DIM}└── scripts/${C_RESET}"
    Write-Host "  ${C_DIM}    └── helpers.sh${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The .tmux file is executed when the plugin loads. It typically
sets keybindings and configures hooks.
"@

    Engine-Pause

    Engine-Teach @"
Plugins extend tmux's capabilities significantly. Start with
tmux-sensible and tmux-resurrect, then add more as needed.
"@

    Engine-Section "Quick Quiz"

    Engine-Quiz "What key installs plugins in TPM?" @("Prefix + i", "Prefix + I (capital)", "Prefix + p", "Prefix + P") 2

    Write-Host ""

    Engine-Quiz "Which plugin saves sessions across reboots?" @("tmux-sensible", "tmux-yank", "tmux-resurrect", "tmux-continuum") 3
}
