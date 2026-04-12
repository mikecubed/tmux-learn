# Lesson: Pair Programming with tmux

function Lesson-Info {
    Set-LessonInfo `
        -Title "Pair Programming with tmux" `
        -Module "05-advanced" `
        -Description "Share tmux sessions for real-time collaboration and pair programming." `
        -Time "8 minutes" `
        -Prerequisites "05-advanced/02-plugins-tpm"
}

function Lesson-Run {
    Engine-Section "Why tmux for Pair Programming?"

    Engine-Teach @"
tmux lets multiple people work in the same terminal session
simultaneously. Unlike screen sharing:
  - Zero latency (both users are on the same machine)
  - Both users can type at the same time
  - Works over SSH with minimal bandwidth
  - No video/screen sharing overhead
"@

    Engine-Pause

    Engine-Section "Method 1: Shared Session (Same Account)"

    Engine-Teach @"
The simplest approach - both users SSH into the same account
and attach to the same session:
"@

    Write-Host ""
    Write-Host "  ${C_WHITE}# User 1 creates the session${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -s pair${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# User 2 attaches to the same session${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t pair${C_RESET}"
    Write-Host ""

    Engine-Teach @"
Both users see the SAME view - same window, same pane.
When one person types or switches windows, the other sees it.
"@

    Engine-Pause

    Engine-Section "Independent Windows (Session Groups)"

    Engine-Teach @"
For more flexibility, use session groups. Each user can view
different windows independently:
"@

    Write-Host ""
    Write-Host "  ${C_WHITE}# User 1 creates the session${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -s pair${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# User 2 creates a grouped session${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -t pair -s pair-user2${C_RESET}"
    Write-Host ""

    Engine-Teach @"
Now both users share the same windows, but can independently
choose which window to view. Changes to pane content are shared,
but window selection is independent.
"@

    Engine-Pause

    Engine-Section "Method 2: Shared Socket (Different Accounts)"

    Engine-Teach "For users with different system accounts, use a shared socket:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Create a shared tmux socket${C_RESET}"
    Write-Host "  ${C_WHITE}tmux -S /tmp/pair-session new-session -s pair${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Set permissions so the other user can access it${C_RESET}"
    Write-Host "  ${C_WHITE}chmod 777 /tmp/pair-session${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Other user connects via the socket${C_RESET}"
    Write-Host "  ${C_WHITE}tmux -S /tmp/pair-session attach -t pair${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The -S flag specifies a custom socket path. Both users must
use the same socket path.
"@

    Engine-Pause

    Engine-Section "Method 3: Using tmate"

    Engine-Teach @"
tmate is a fork of tmux specifically designed for pair programming.
It provides a secure, easy-to-share session over the internet:
"@

    Write-Host ""
    UI-Command "tmate" "Start a tmate session"
    Write-Host ""

    Engine-Teach @"
tmate displays a connection URL that you share with your pair.
They can connect from anywhere - no SSH setup required.

Install: brew install tmate (macOS) or apt install tmate (Ubuntu)
"@

    Engine-Pause

    Engine-Section "Read-Only Access"

    Engine-Teach "Give someone view-only access (they can see but not type):"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Viewer connects in read-only mode${C_RESET}"
    Write-Host "  ${C_WHITE}tmux -S /tmp/pair-session attach -t pair -r${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The -r flag makes the connection read-only. Perfect for:
  - Code reviews
  - Teaching/demonstrations
  - Monitoring
"@

    Engine-Pause

    Engine-Section "Best Practices for Pair Programming"

    Engine-Teach "Tips for effective tmux pair sessions:"

    Write-Host ""
    Write-Host "  ${C_BOLD}1.${C_RESET} Use session groups for independent navigation"
    Write-Host "  ${C_BOLD}2.${C_RESET} Set up a shared tmux.conf with agreed keybindings"
    Write-Host "  ${C_BOLD}3.${C_RESET} Use a voice channel alongside (tmux doesn't do audio!)"
    Write-Host "  ${C_BOLD}4.${C_RESET} Agree on a prefix key everyone is comfortable with"
    Write-Host "  ${C_BOLD}5.${C_RESET} Use synchronized panes sparingly"
    Write-Host "  ${C_BOLD}6.${C_RESET} Consider using wemux for easier multi-user management"
    Write-Host ""

    Engine-Pause

    Engine-Section "wemux - Enhanced Multi-User tmux"

    Engine-Teach "wemux adds multi-user features on top of tmux:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Host starts session${C_RESET}"
    Write-Host "  ${C_WHITE}wemux start${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Users join in different modes${C_RESET}"
    Write-Host "  ${C_WHITE}wemux mirror${C_RESET}    ${C_DIM}# Read-only${C_RESET}"
    Write-Host "  ${C_WHITE}wemux pair${C_RESET}      ${C_DIM}# Full collaboration${C_RESET}"
    Write-Host "  ${C_WHITE}wemux rogue${C_RESET}     ${C_DIM}# Independent windows${C_RESET}"
    Write-Host ""

    Engine-Teach "wemux simplifies the setup process and provides user management."

    Engine-Pause

    Engine-Teach @"
tmux pair programming is one of the most efficient ways to
collaborate on code. Once set up, it's faster and lighter than
any screen sharing tool.
"@

    Engine-Section "Quick Quiz"

    Engine-Quiz "What flag makes a tmux connection read-only?" @("-l", "-v", "-r", "-o") 3

    Write-Host ""

    Engine-Quiz "What does the -S flag do?" @("Start a new server", "Specify a socket path", "Set session name", "Silent mode") 2
}
