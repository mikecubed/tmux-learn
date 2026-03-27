#!/usr/bin/env bash
# Lesson: Pair Programming

lesson_info() {
    LESSON_TITLE="Pair Programming with tmux"
    LESSON_MODULE="05-advanced"
    LESSON_DESCRIPTION="Share tmux sessions for real-time collaboration and pair programming."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="05-advanced/02-plugins-tpm"
}

lesson_run() {
    engine_section "Why tmux for Pair Programming?"

    engine_teach "tmux lets multiple people work in the same terminal session
simultaneously. Unlike screen sharing:
  - Zero latency (both users are on the same machine)
  - Both users can type at the same time
  - Works over SSH with minimal bandwidth
  - No video/screen sharing overhead"

    engine_pause

    engine_section "Method 1: Shared Session (Same Account)"

    engine_teach "The simplest approach - both users SSH into the same account
and attach to the same session:"

    echo ""
    printf "  ${C_WHITE}# User 1 creates the session${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -s pair${C_RESET}\n\n"
    printf "  ${C_WHITE}# User 2 attaches to the same session${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t pair${C_RESET}\n"
    echo ""

    engine_teach "Both users see the SAME view - same window, same pane.
When one person types or switches windows, the other sees it."

    engine_pause

    engine_section "Independent Windows (Session Groups)"

    engine_teach "For more flexibility, use session groups. Each user can view
different windows independently:"

    echo ""
    printf "  ${C_WHITE}# User 1 creates the session${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -s pair${C_RESET}\n\n"
    printf "  ${C_WHITE}# User 2 creates a grouped session${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -t pair -s pair-user2${C_RESET}\n"
    echo ""

    engine_teach "Now both users share the same windows, but can independently
choose which window to view. Changes to pane content are shared,
but window selection is independent."

    engine_pause

    engine_section "Method 2: Shared Socket (Different Accounts)"

    engine_teach "For users with different system accounts, use a shared socket:"

    echo ""
    printf "  ${C_WHITE}# Create a shared tmux socket${C_RESET}\n"
    printf "  ${C_WHITE}tmux -S /tmp/pair-session new-session -s pair${C_RESET}\n\n"
    printf "  ${C_WHITE}# Set permissions so the other user can access it${C_RESET}\n"
    printf "  ${C_WHITE}chmod 777 /tmp/pair-session${C_RESET}\n\n"
    printf "  ${C_WHITE}# Other user connects via the socket${C_RESET}\n"
    printf "  ${C_WHITE}tmux -S /tmp/pair-session attach -t pair${C_RESET}\n"
    echo ""

    engine_teach "The -S flag specifies a custom socket path. Both users must
use the same socket path."

    engine_pause

    engine_section "Method 3: Using tmate"

    engine_teach "tmate is a fork of tmux specifically designed for pair programming.
It provides a secure, easy-to-share session over the internet:"

    echo ""
    ui_command "tmate" "Start a tmate session"
    echo ""

    engine_teach "tmate displays a connection URL that you share with your pair.
They can connect from anywhere - no SSH setup required.

Install: brew install tmate (macOS) or apt install tmate (Ubuntu)"

    engine_pause

    engine_section "Read-Only Access"

    engine_teach "Give someone view-only access (they can see but not type):"

    echo ""
    printf "  ${C_WHITE}# Viewer connects in read-only mode${C_RESET}\n"
    printf "  ${C_WHITE}tmux -S /tmp/pair-session attach -t pair -r${C_RESET}\n"
    echo ""

    engine_teach "The -r flag makes the connection read-only. Perfect for:
  - Code reviews
  - Teaching/demonstrations
  - Monitoring"

    engine_pause

    engine_section "Best Practices for Pair Programming"

    engine_teach "Tips for effective tmux pair sessions:"

    echo ""
    printf "  ${C_BOLD}1.${C_RESET} Use session groups for independent navigation\n"
    printf "  ${C_BOLD}2.${C_RESET} Set up a shared tmux.conf with agreed keybindings\n"
    printf "  ${C_BOLD}3.${C_RESET} Use a voice channel alongside (tmux doesn't do audio!)\n"
    printf "  ${C_BOLD}4.${C_RESET} Agree on a prefix key everyone is comfortable with\n"
    printf "  ${C_BOLD}5.${C_RESET} Use synchronized panes sparingly\n"
    printf "  ${C_BOLD}6.${C_RESET} Consider using wemux for easier multi-user management\n"
    echo ""

    engine_pause

    engine_section "wemux - Enhanced Multi-User tmux"

    engine_teach "wemux adds multi-user features on top of tmux:"

    echo ""
    printf "  ${C_WHITE}# Host starts session${C_RESET}\n"
    printf "  ${C_WHITE}wemux start${C_RESET}\n\n"
    printf "  ${C_WHITE}# Users join in different modes${C_RESET}\n"
    printf "  ${C_WHITE}wemux mirror${C_RESET}    ${C_DIM}# Read-only${C_RESET}\n"
    printf "  ${C_WHITE}wemux pair${C_RESET}      ${C_DIM}# Full collaboration${C_RESET}\n"
    printf "  ${C_WHITE}wemux rogue${C_RESET}     ${C_DIM}# Independent windows${C_RESET}\n"
    echo ""

    engine_teach "wemux simplifies the setup process and provides user management."

    engine_pause

    engine_teach "tmux pair programming is one of the most efficient ways to
collaborate on code. Once set up, it's faster and lighter than
any screen sharing tool."

    engine_section "Quick Quiz"

    engine_quiz "What flag makes a tmux connection read-only?" \
        "-l" "-v" "-r" "-o" \
        3

    echo ""

    engine_quiz "What does the -S flag do?" \
        "Start a new server" "Specify a socket path" "Set session name" "Silent mode" \
        2
}
