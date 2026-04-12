# Lesson: Advanced Window Switching

function Lesson-Info {
    Set-LessonInfo -Title "Advanced Window Switching" `
        -Module "02-navigation" `
        -Description "Master window navigation with search, direct jumps, and activity monitoring." `
        -Time "7 minutes" `
        -Prerequisites "02-navigation/01-pane-movement"
}

function Lesson-Run {
    Engine-Section "Finding Windows"

    Engine-Teach "When you have many windows, finding the right one quickly matters:"
    Write-Host ""
    UI-Keybinding "Prefix" "w" "Interactive tree view of all sessions and windows"
    UI-Keybinding "Prefix" "f" "Find window by name (search)"
    Write-Host ""

    Engine-Teach "The tree view (Prefix + w) shows ALL sessions and their windows.`nUse arrow keys to navigate, Enter to select, and type to filter."

    Engine-Pause

    Engine-Section "Direct Window Access"

    Engine-Teach "Jump directly to any window by its index:"
    Write-Host ""
    UI-Keybinding "Prefix" "0" "Go to window 0"
    UI-Keybinding "Prefix" "1" "Go to window 1"
    UI-Keybinding "Prefix" "'" "Prompt for window index (for 10+)"
    Write-Host ""

    Engine-Teach "For windows beyond 9, use Prefix + ' which prompts for the index.`nThis is useful when you have 10+ windows."

    Engine-Pause

    Engine-Section "Last Window Toggle"

    Engine-Teach "Quickly toggle between two windows (like Alt+Tab):"
    Write-Host ""
    UI-Keybinding "Prefix" "l" "Switch to last active window"
    Write-Host ""

    Engine-Teach "This is one of the most useful shortcuts for bouncing between`nyour editor and terminal, or between two related tasks."

    Engine-Pause

    Engine-Section "Window Activity Monitoring"

    Engine-Teach "Get notified when something happens in another window:"
    Write-Host ""
    UI-Command "tmux setw -g monitor-activity on" "Monitor for activity"
    UI-Command "tmux set -g visual-activity on" "Show activity alerts"
    Write-Host ""

    Engine-Teach "When activity occurs in a monitored window, its name will be`nhighlighted in the status bar. You can also monitor for silence:"
    Write-Host ""
    UI-Command "tmux setw monitor-silence 30" "Alert after 30s of silence"
    Write-Host ""

    Engine-Teach "This is great for watching log files or waiting for long builds."

    Engine-Pause

    Engine-Section "Moving Windows Between Sessions"

    Engine-Teach "You can move windows between sessions:"
    Write-Host ""
    UI-Command "tmux move-window -t other_session:" "Move to another session"
    UI-Command "tmux link-window -t other_session:" "Link (share) to another session"
    Write-Host ""

    Engine-Teach "A linked window appears in both sessions - changes in one are`nreflected in the other. Unlink with: tmux unlink-window"

    Engine-Pause

    # ── Exercise ──
    Engine-Exercise -ExerciseId "window-switching-1" `
        -Title "Create Named Windows" `
        -Instructions "In the sandbox session 'tmux-learn-sandbox':`n`n1. Create 3 windows total`n2. Name them: 'editor', 'server', 'logs'`n`nUse Prefix + c to create, Prefix + , to rename.`n`nSwitch to sandbox with Prefix + s" `
        -VerifyFunc {
            Verify-Reset
            $names = @(tmux list-windows -t $SANDBOX_SESSION -F '#{window_name}' 2>$null)

            $hasEditor = ($names -contains "editor")
            $hasServer = ($names -contains "server")
            $hasLogs = ($names -contains "logs")

            $missing = @()
            if (-not $hasEditor) { $missing += "editor" }
            if (-not $hasServer) { $missing += "server" }
            if (-not $hasLogs) { $missing += "logs" }

            if ($missing.Count -eq 0) {
                Set-VerifyMessage "All three windows found: editor, server, logs"
                return $true
            } else {
                Set-VerifyMessage "Missing window(s): $($missing -join ', ')"
                Set-VerifyHint "Create and rename windows. Use Prefix+c then Prefix+, to rename"
                return $false
            }
        } `
        -Hint "Create windows with Prefix+c, rename with Prefix+, to 'editor', 'server', and 'logs'" `
        -UseSandbox "session"

    Engine-Teach "You're now an expert at navigating windows. Quick window switching`nis a major productivity boost in tmux."
}
