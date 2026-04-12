# Lesson: Copy Mode and Scrollback

function Lesson-Info {
    Set-LessonInfo -Title "Copy Mode and Scrollback" `
        -Module "02-navigation" `
        -Description "Learn to scroll, search, select, and copy text in tmux." `
        -Time "10 minutes" `
        -Prerequisites "02-navigation/03-session-switching"
}

function Lesson-Run {
    Engine-Section "Entering Copy Mode"

    Engine-Teach "Copy mode lets you scroll through output, search for text, and`ncopy content to a paste buffer. It's like entering a read-only`nview of your terminal's scrollback."
    Write-Host ""
    UI-Keybinding "Prefix" "[" "Enter copy mode"
    Write-Host ""
    UI-Command "tmux copy-mode" "Command form"
    Write-Host ""

    Engine-Teach "Press 'q' or Escape to exit copy mode."

    Engine-Pause

    Engine-Section "Navigation in Copy Mode"

    Engine-Teach "Copy mode uses vi-style OR emacs-style keybindings depending`non your configuration. The default is emacs. Here are both:"

    Write-Host ""
    UI-Print "${C_BOLD}${C_UNDERLINE}" "vi mode (set -g mode-keys vi)"
    UI-Keybinding "h/j/k/l" "" "Move cursor (left/down/up/right)"
    UI-Keybinding "w/b" "" "Next/previous word"
    UI-Keybinding "0/$" "" "Start/end of line"
    UI-Keybinding "g/G" "" "Top/bottom of scrollback"
    UI-Keybinding "Ctrl+u/d" "" "Page up/down"
    Write-Host ""

    UI-Print "${C_BOLD}${C_UNDERLINE}" "emacs mode (default)"
    UI-Keybinding "Arrow keys" "" "Move cursor"
    UI-Keybinding "Ctrl+Space" "" "Start selection"
    UI-Keybinding "Alt+w" "" "Copy selection"
    UI-Keybinding "Ctrl+g" "" "Cancel"
    Write-Host ""

    Engine-Pause

    Engine-Section "Searching in Copy Mode"

    Engine-Teach "Search through your scrollback history:"
    Write-Host ""

    UI-Print $C_BOLD "In copy mode:"
    UI-Keybinding "/" "" "Search forward (vi mode)"
    UI-Keybinding "?" "" "Search backward (vi mode)"
    UI-Keybinding "Ctrl+s" "" "Search forward (emacs mode)"
    UI-Keybinding "Ctrl+r" "" "Search backward (emacs mode)"
    UI-Keybinding "n/N" "" "Next/previous match"
    Write-Host ""

    Engine-Pause

    Engine-Section "Selecting and Copying Text"

    Engine-Teach "To copy text in vi mode:"

    Write-Host ""
    UI-Print $C_DIM "  1. Enter copy mode:     Prefix + ["
    UI-Print $C_DIM "  2. Navigate to start:   h/j/k/l"
    UI-Print $C_DIM "  3. Start selection:      Space"
    UI-Print $C_DIM "  4. Navigate to end:     h/j/k/l"
    UI-Print $C_DIM "  5. Copy selection:      Enter"
    Write-Host ""

    Engine-Teach "To paste:"
    Write-Host ""
    UI-Keybinding "Prefix" "]" "Paste from buffer"
    Write-Host ""
    UI-Command "tmux paste-buffer" "Command form"
    Write-Host ""

    Engine-Pause

    Engine-Section "Managing Paste Buffers"

    Engine-Teach "tmux maintains multiple paste buffers (like a clipboard history):"
    Write-Host ""
    UI-Command "tmux list-buffers" "Show all buffers"
    UI-Command "tmux show-buffer" "Show most recent buffer"
    UI-Command "tmux choose-buffer" "Interactive buffer picker"
    UI-Keybinding "Prefix" "=" "Interactive buffer picker"
    Write-Host ""

    Engine-Teach "Each copy operation pushes a new buffer. You can paste from`nany buffer in the stack."

    Engine-Pause

    Engine-Section "Scrollback Settings"

    Engine-Teach "Configure how much history tmux keeps:"
    Write-Host ""
    UI-Command "tmux set -g history-limit 10000" "Keep 10,000 lines"
    Write-Host ""

    Engine-Teach "The default is 2000 lines. Increase this if you need to scroll`nback through a lot of output. Be aware that very high values`nuse more memory."

    Engine-Pause

    Engine-Section "Vi Mode Setup"

    Engine-Teach "Most tmux users prefer vi mode for copy mode. Enable it with:"
    Write-Host ""
    UI-Command "tmux set -g mode-keys vi" "Enable vi keybindings in copy mode"
    Write-Host ""

    Engine-Teach "For even better vi-like behavior, add these to your tmux.conf:"
    Write-Host ""
    UI-Command "bind -T copy-mode-vi v send -X begin-selection" "v to select"
    UI-Command "bind -T copy-mode-vi y send -X copy-selection-and-cancel" "y to yank"
    Write-Host ""

    Engine-Pause

    Engine-Section "Copying to System Clipboard"

    Engine-Teach "By default, tmux copies to its own internal buffer, not the`nsystem clipboard. To integrate with your OS clipboard:"

    Write-Host ""
    UI-Print $C_BOLD "macOS:"
    UI-Command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'"
    Write-Host ""
    UI-Print $C_BOLD "Linux (X11):"
    UI-Command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -sel clip'"
    Write-Host ""
    UI-Print $C_BOLD "Linux (Wayland):"
    UI-Command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'wl-copy'"
    Write-Host ""

    Engine-Pause

    # ── Exercise ──
    Engine-Teach "Let's practice using copy mode."

    # Set up some content in the sandbox
    Sandbox-Create
    tmux send-keys -t $SANDBOX_SESSION "echo 'TMUX-LEARN-COPY-TEST: The quick brown fox jumps over the lazy dog'" Enter
    Start-Sleep -Milliseconds 500
    tmux send-keys -t $SANDBOX_SESSION "echo 'Copy the word TMUX-LEARN-COPY-TEST from the line above'" Enter

    Engine-Exercise -ExerciseId "copy-mode-1" `
        -Title "Copy Text in Copy Mode" `
        -Instructions "In the sandbox session:`n1. Switch to it (Prefix + s)`n2. Enter copy mode (Prefix + [)`n3. Find the text 'TMUX-LEARN-COPY-TEST'`n4. Select it and copy it (Space to start, Enter to copy)`n`nThe text should now be in the tmux paste buffer.`nSwitch back here and type 'check'." `
        -VerifyFunc {
            Verify-BufferContent "TMUX-LEARN-COPY-TEST"
        } `
        -Hint "In sandbox: Prefix+[ to enter copy mode, navigate to 'TMUX-LEARN-COPY-TEST', press Space, select it, press Enter to copy" `
        -UseSandbox "current"

    Engine-Teach "Copy mode is essential for working with terminal output. With`npractice, you'll navigate scrollback as easily as a text editor.`n`nYou've completed the Navigation module! Next up: Customization."
}
