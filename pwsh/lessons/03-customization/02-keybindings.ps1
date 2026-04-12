# Lesson: Keybindings

function Lesson-Info {
    Set-LessonInfo `
        -Title "Custom Keybindings" `
        -Module "03-customization" `
        -Description "Create and customize tmux keybindings for a more efficient workflow." `
        -Time "10 minutes" `
        -Prerequisites "03-customization/01-tmux-conf-basics"
}

function Lesson-Run {
    Engine-Section "The bind-key Command"

    Engine-Teach "Customize what happens when you press keys in tmux:"
    Write-Host ""
    UI-Command "bind-key <key> <command>" "Basic syntax"
    UI-Command "bind <key> <command>" "Short form"
    Write-Host ""

    Engine-Teach @"
By default, bindings use the prefix key. So 'bind x kill-pane'
means Prefix + x runs kill-pane.
"@

    Engine-Pause

    Engine-Section "Changing the Prefix Key"

    Engine-Teach "Many users change the prefix from Ctrl+b to Ctrl+a (easier to reach):"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Change prefix to Ctrl+a${C_RESET}"
    Write-Host "  ${C_WHITE}unbind C-b${C_RESET}"
    Write-Host "  ${C_WHITE}set -g prefix C-a${C_RESET}"
    Write-Host "  ${C_WHITE}bind C-a send-prefix${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The 'send-prefix' line ensures that pressing Ctrl+a twice sends
a literal Ctrl+a to the underlying program (useful in bash for
going to start of line).
"@

    Engine-Pause

    Engine-Section "Intuitive Split Keys"

    Engine-Teach @"
The default split keys (% and ") are hard to remember. Many users
rebind them to more intuitive keys:
"@
    Write-Host ""
    Write-Host "  ${C_WHITE}# Split with | and -${C_RESET}"
    Write-Host "  ${C_WHITE}bind | split-window -h${C_RESET}"
    Write-Host "  ${C_WHITE}bind - split-window -v${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Or with \ and - (no shift needed)${C_RESET}"
    Write-Host "  ${C_WHITE}bind \ split-window -h${C_RESET}"
    Write-Host "  ${C_WHITE}bind - split-window -v${C_RESET}"
    Write-Host ""

    Engine-Teach "You can also split in the current directory:"
    Write-Host ""
    Write-Host "  ${C_WHITE}bind | split-window -h -c '#{pane_current_path}'${C_RESET}"
    Write-Host "  ${C_WHITE}bind - split-window -v -c '#{pane_current_path}'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Binding Without Prefix"

    Engine-Teach "Use -n flag to bind keys without the prefix:"
    Write-Host ""
    UI-Command "bind -n M-Left select-pane -L" "Alt+Left to switch pane"
    UI-Command "bind -n M-Right select-pane -R" "Alt+Right to switch pane"
    UI-Command "bind -n M-Up select-pane -U" "Alt+Up to switch pane"
    UI-Command "bind -n M-Down select-pane -D" "Alt+Down to switch pane"
    Write-Host ""

    Engine-Teach @"
M- means Alt/Meta key. This gives you instant pane switching
without pressing the prefix first.
"@
    Write-Host ""
    UI-Warn "Be careful with prefix-less bindings - they can conflict with other programs."

    Engine-Pause

    Engine-Section "Key Tables"

    Engine-Teach "tmux organizes bindings into 'key tables':"
    Write-Host ""
    Write-Host "  ${C_BOLD}prefix${C_RESET}        Keys pressed after the prefix"
    Write-Host "  ${C_BOLD}root${C_RESET}          Keys pressed without prefix (-n flag)"
    Write-Host "  ${C_BOLD}copy-mode-vi${C_RESET}  Keys in vi copy mode"
    Write-Host "  ${C_BOLD}copy-mode${C_RESET}     Keys in emacs copy mode"
    Write-Host ""

    Engine-Teach "Specify a table with -T:"
    Write-Host ""
    UI-Command "bind -T copy-mode-vi v send -X begin-selection" "vi: v to select"
    UI-Command "bind -T copy-mode-vi y send -X copy-selection" "vi: y to yank"
    Write-Host ""

    Engine-Pause

    Engine-Section "Repeated Keys"

    Engine-Teach "Use -r flag for keys that can be pressed repeatedly:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Resize panes with repeatable keys${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r H resize-pane -L 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r J resize-pane -D 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r K resize-pane -U 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r L resize-pane -R 5${C_RESET}"
    Write-Host ""

    Engine-Teach @"
After pressing the prefix once, you can keep pressing the key
within the repeat-time window (default 500ms).
"@

    Engine-Pause

    Engine-Section "Viewing and Removing Bindings"

    Engine-Teach "See all current bindings:"
    Write-Host ""
    UI-Command "tmux list-keys" "List all keybindings"
    UI-Command "tmux list-keys -T prefix" "List only prefix table"
    UI-Keybinding "Prefix" "?" "Show keybindings (interactive)"
    Write-Host ""

    Engine-Teach "Remove a binding:"
    Write-Host ""
    UI-Command "tmux unbind-key x" "Remove Prefix + x binding"
    UI-Command "tmux unbind-key -n M-Left" "Remove Alt+Left binding"
    Write-Host ""

    Engine-Pause

    Engine-Section "Useful Custom Bindings"

    Engine-Teach "Here are some popular custom bindings:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Reload config${C_RESET}"
    Write-Host "  ${C_WHITE}bind r source-file ~/.tmux.conf \; display 'Reloaded!'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Quick pane cycling${C_RESET}"
    Write-Host "  ${C_WHITE}bind -n C-o select-pane -t :.+${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Synchronize panes (type in all panes at once)${C_RESET}"
    Write-Host "  ${C_WHITE}bind S setw synchronize-panes${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# New window in current directory${C_RESET}"
    Write-Host "  ${C_WHITE}bind c new-window -c '#{pane_current_path}'${C_RESET}"
    Write-Host ""

    Engine-Pause

    # -- Exercise --
    Engine-Exercise `
        -ExerciseId "keybindings-1" `
        -Title "Create a Custom Binding" `
        -Instructions @"
Bind 'Prefix + R' to reload the tmux config.

Run this command:
  tmux bind R source-file ~/.tmux.conf

Then type 'check' to verify.
"@ `
        -VerifyFunc { Verify-Keybinding " R " "source-file" } `
        -Hint "Run: tmux bind R source-file ~/.tmux.conf" `
        -UseSandbox "none"

    Engine-Teach @"
Custom keybindings make tmux feel like YOUR tool. Everyone's
ideal setup is different - experiment and find what works for you.
"@
}
