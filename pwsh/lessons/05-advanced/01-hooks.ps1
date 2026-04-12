# Lesson: tmux Hooks and Events

function Lesson-Info {
    Set-LessonInfo `
        -Title "tmux Hooks and Events" `
        -Module "05-advanced" `
        -Description "Automate actions with tmux hooks that trigger on events." `
        -Time "8 minutes" `
        -Prerequisites "04-scripting/04-session-scripts"
}

function Lesson-Run {
    Engine-Section "What are Hooks?"

    Engine-Teach @"
Hooks let you run commands automatically when specific events
happen in tmux. For example:
  - Run a script when a new session is created
  - Adjust layout when a window is resized
  - Log when a pane is closed

This enables powerful automation without user interaction.
"@

    Engine-Pause

    Engine-Section "Setting Hooks"

    Engine-Teach "Use set-hook to register a hook:"
    Write-Host ""
    UI-Command "tmux set-hook -g after-new-session 'display-message `"New session!`"'" ""
    UI-Command "tmux set-hook -g after-new-window 'setw automatic-rename on'" ""
    Write-Host ""

    Engine-Teach @"
The -g flag sets a global hook. Without it, the hook applies only
to the current session.
"@

    Engine-Pause

    Engine-Section "Common Hook Events"

    Engine-Teach "Session events:"
    Write-Host ""
    Write-Host "  ${C_BOLD}after-new-session${C_RESET}       After a session is created"
    Write-Host "  ${C_BOLD}session-closed${C_RESET}          When a session is destroyed"
    Write-Host "  ${C_BOLD}client-attached${C_RESET}         When a client attaches"
    Write-Host "  ${C_BOLD}client-detached${C_RESET}         When a client detaches"
    Write-Host "  ${C_BOLD}client-resized${C_RESET}          When the terminal is resized"
    Write-Host ""

    Engine-Teach "Window and pane events:"
    Write-Host ""
    Write-Host "  ${C_BOLD}after-new-window${C_RESET}        After a window is created"
    Write-Host "  ${C_BOLD}window-linked${C_RESET}           When a window is linked"
    Write-Host "  ${C_BOLD}after-split-window${C_RESET}      After a pane split"
    Write-Host "  ${C_BOLD}pane-exited${C_RESET}             When a pane process exits"
    Write-Host "  ${C_BOLD}after-select-pane${C_RESET}       After switching panes"
    Write-Host "  ${C_BOLD}after-select-window${C_RESET}     After switching windows"
    Write-Host "  ${C_BOLD}after-resize-pane${C_RESET}       After a pane is resized"
    Write-Host ""

    Engine-Pause

    Engine-Section "Practical Hook Examples"

    Engine-Teach "Auto-rename windows based on the current directory:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set-hook -g after-select-pane \${C_RESET}"
    Write-Host "  ${C_WHITE}  'run-shell `"tmux rename-window \`"#(basename #{pane_current_path})\`"`"'${C_RESET}"
    Write-Host ""

    Engine-Teach "Log session activity:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set-hook -g client-attached \${C_RESET}"
    Write-Host "  ${C_WHITE}  'run-shell `"echo \`"attached: #{session_name}\`" >> ~/tmux.log`"'${C_RESET}"
    Write-Host ""

    Engine-Teach "Auto-rebalance panes after split:"
    Write-Host ""
    Write-Host "  ${C_WHITE}set-hook -g after-split-window 'select-layout tiled'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Managing Hooks"

    Engine-Teach "View and remove hooks:"
    Write-Host ""
    UI-Command "tmux show-hooks -g" "Show all global hooks"
    UI-Command "tmux show-hooks" "Show session hooks"
    UI-Command "tmux set-hook -gu after-new-session" "Remove a global hook"
    Write-Host ""

    Engine-Teach "The -u flag unsets (removes) a hook."

    Engine-Pause

    Engine-Section "Run-Shell"

    Engine-Teach "Hooks often use run-shell to execute external commands:"
    Write-Host ""
    UI-Command "tmux run-shell 'echo hello'" "Run a shell command"
    UI-Command "tmux run-shell -b 'sleep 5 && notify-send done'" "Run in background"
    Write-Host ""

    Engine-Teach @"
The -b flag runs the command in the background so it doesn't
block tmux. Important for commands that take time.
"@

    Engine-Pause

    Engine-Section "Alert Hooks"

    Engine-Teach "Combined with monitoring, hooks can create a notification system:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Monitor for activity and bell${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g monitor-activity on${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g monitor-bell on${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Hook: run a command when alert triggers${C_RESET}"
    Write-Host "  ${C_WHITE}set-hook -g alert-activity \${C_RESET}"
    Write-Host "  ${C_WHITE}  'run-shell `"notify-send tmux \`"Activity in #{window_name}\`"`"'${C_RESET}"
    Write-Host ""

    Engine-Pause

    # -- Exercise --
    Engine-Exercise `
        -ExerciseId "hooks-1" `
        -Title "Set Up a Hook" `
        -Instructions @"
Create a hook that displays a message when
a new window is created.

Run this command:
  tmux set-hook -g after-new-window 'display-message "Window created!"'

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset
            $hooks = $null
            try {
                $hooks = tmux show-hooks -g 2>$null
            } catch { }

            if ($hooks -and ($hooks | Out-String) -match "after-new-window") {
                Set-VerifyMessage "Hook 'after-new-window' is configured"
                return $true
            } else {
                Set-VerifyMessage "No 'after-new-window' hook found"
                Set-VerifyHint "Run: tmux set-hook -g after-new-window 'display-message `"Window created!`"'"
                return $false
            }
        } `
        -Hint "Run: tmux set-hook -g after-new-window 'display-message `"Window created!`"'" `
        -UseSandbox "none"

    # Cleanup
    try { tmux set-hook -gu after-new-window 2>$null } catch { }

    Engine-Teach @"
Hooks are a powerful automation mechanism that makes tmux reactive
to events. Combined with scripting, they create intelligent workflows.
"@
}
