#!/usr/bin/env bash
# Lesson: Copy Mode

lesson_info() {
    LESSON_TITLE="Copy Mode and Scrollback"
    LESSON_MODULE="02-navigation"
    LESSON_DESCRIPTION="Learn to scroll, search, select, and copy text in tmux."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="02-navigation/03-session-switching"
}

lesson_run() {
    engine_section "Entering Copy Mode"

    engine_teach "Copy mode lets you scroll through output, search for text, and
copy content to a paste buffer. It's like entering a read-only
view of your terminal's scrollback."
    echo ""
    ui_keybinding "Prefix" "[" "Enter copy mode"
    echo ""
    ui_command "tmux copy-mode" "Command form"
    echo ""

    engine_teach "Press 'q' or Escape to exit copy mode."

    engine_pause

    engine_section "Navigation in Copy Mode"

    engine_teach "Copy mode uses vi-style OR emacs-style keybindings depending
on your configuration. The default is emacs. Here are both:"

    echo ""
    printf "  ${C_BOLD}${C_UNDERLINE}vi mode${C_RESET} (set -g mode-keys vi)\n"
    ui_keybinding "h/j/k/l" "" "Move cursor (left/down/up/right)"
    ui_keybinding "w/b" "" "Next/previous word"
    ui_keybinding "0/$" "" "Start/end of line"
    ui_keybinding "g/G" "" "Top/bottom of scrollback"
    ui_keybinding "Ctrl+u/d" "" "Page up/down"
    echo ""

    printf "  ${C_BOLD}${C_UNDERLINE}emacs mode${C_RESET} (default)\n"
    ui_keybinding "Arrow keys" "" "Move cursor"
    ui_keybinding "Ctrl+Space" "" "Start selection"
    ui_keybinding "Alt+w" "" "Copy selection"
    ui_keybinding "Ctrl+g" "" "Cancel"
    echo ""

    engine_pause

    engine_section "Searching in Copy Mode"

    engine_teach "Search through your scrollback history:"
    echo ""

    printf "  ${C_BOLD}In copy mode:${C_RESET}\n"
    ui_keybinding "/" "" "Search forward (vi mode)"
    ui_keybinding "?" "" "Search backward (vi mode)"
    ui_keybinding "Ctrl+s" "" "Search forward (emacs mode)"
    ui_keybinding "Ctrl+r" "" "Search backward (emacs mode)"
    ui_keybinding "n/N" "" "Next/previous match"
    echo ""

    engine_pause

    engine_section "Selecting and Copying Text"

    engine_teach "To copy text in vi mode:"

    echo ""
    ui_print "$C_DIM" "  1. Enter copy mode:     Prefix + ["
    ui_print "$C_DIM" "  2. Navigate to start:   h/j/k/l"
    ui_print "$C_DIM" "  3. Start selection:     Space"
    ui_print "$C_DIM" "  4. Navigate to end:     h/j/k/l"
    ui_print "$C_DIM" "  5. Copy selection:      Enter"
    echo ""

    engine_teach "To paste:"
    echo ""
    ui_keybinding "Prefix" "]" "Paste from buffer"
    echo ""
    ui_command "tmux paste-buffer" "Command form"
    echo ""

    engine_pause

    engine_section "Managing Paste Buffers"

    engine_teach "tmux maintains multiple paste buffers (like a clipboard history):"
    echo ""
    ui_command "tmux list-buffers" "Show all buffers"
    ui_command "tmux show-buffer" "Show most recent buffer"
    ui_command "tmux choose-buffer" "Interactive buffer picker"
    ui_keybinding "Prefix" "=" "Interactive buffer picker"
    echo ""

    engine_teach "Each copy operation pushes a new buffer. You can paste from
any buffer in the stack."

    engine_pause

    engine_section "Scrollback Settings"

    engine_teach "Configure how much history tmux keeps:"
    echo ""
    ui_command "tmux set -g history-limit 10000" "Keep 10,000 lines"
    echo ""

    engine_teach "The default is 2000 lines. Increase this if you need to scroll
back through a lot of output. Be aware that very high values
use more memory."

    engine_pause

    engine_section "Vi Mode Setup"

    engine_teach "Most tmux users prefer vi mode for copy mode. Enable it with:"
    echo ""
    ui_command "tmux set -g mode-keys vi" "Enable vi keybindings in copy mode"
    echo ""

    engine_teach "For even better vi-like behavior, add these to your tmux.conf:"
    echo ""
    ui_command "bind -T copy-mode-vi v send -X begin-selection" "v to select"
    ui_command "bind -T copy-mode-vi y send -X copy-selection-and-cancel" "y to yank"
    echo ""

    engine_pause

    engine_section "Copying to System Clipboard"

    engine_teach "By default, tmux copies to its own internal buffer, not the
system clipboard. To integrate with your OS clipboard:"

    echo ""
    printf "  ${C_BOLD}macOS:${C_RESET}\n"
    ui_command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'"
    echo ""
    printf "  ${C_BOLD}Linux (X11):${C_RESET}\n"
    ui_command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -sel clip'"
    echo ""
    printf "  ${C_BOLD}Linux (Wayland):${C_RESET}\n"
    ui_command "bind -T copy-mode-vi y send -X copy-pipe-and-cancel 'wl-copy'"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_teach "Let's practice using copy mode."

    # Set up some content in the sandbox
    sandbox_create
    tmux send-keys -t "$SANDBOX_SESSION" "echo 'TMUX-LEARN-COPY-TEST: The quick brown fox jumps over the lazy dog'" Enter
    sleep 0.5
    tmux send-keys -t "$SANDBOX_SESSION" "echo 'Copy the word TMUX-LEARN-COPY-TEST from the line above'" Enter

    engine_exercise \
        "copy-mode-1" \
        "Copy Text in Copy Mode" \
        "In the sandbox session:
1. Switch to it (Prefix + s)
2. Enter copy mode (Prefix + [)
3. Find the text 'TMUX-LEARN-COPY-TEST'
4. Select it and copy it (Space to start, Enter to copy)

The text should now be in the tmux paste buffer.
Switch back here and type 'check'." \
        verify_exercise_1 \
        "In sandbox: Prefix+[ to enter copy mode, navigate to 'TMUX-LEARN-COPY-TEST', press Space, select it, press Enter to copy" \
        "current"

    engine_teach "Copy mode is essential for working with terminal output. With
practice, you'll navigate scrollback as easily as a text editor.

You've completed the Navigation module! Next up: Customization."
}

verify_exercise_1() {
    verify_buffer_content "TMUX-LEARN-COPY-TEST"
}
