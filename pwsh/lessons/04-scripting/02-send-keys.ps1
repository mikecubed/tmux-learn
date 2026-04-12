# Lesson: send-keys and Automation

function Lesson-Info {
    Set-LessonInfo `
        -Title "Automation with send-keys" `
        -Module "04-scripting" `
        -Description "Use send-keys to type commands, simulate keystrokes, and automate workflows." `
        -Time "8 minutes" `
        -Prerequisites "04-scripting/01-tmux-commands"
}

function Lesson-Run {
    Engine-Section "The send-keys Command"

    Engine-Teach @"
send-keys simulates typing into a pane. It's the key to automating
workflows in tmux.
"@
    Write-Host ""
    UI-Command "tmux send-keys 'echo hello' Enter" "Type and press Enter"
    UI-Command "tmux send-keys -t work:0 'ls -la' Enter" "Type in specific pane"
    Write-Host ""

    Engine-Teach @"
The 'Enter' at the end is a special key name. Without it, the
text is typed but not executed.
"@

    Engine-Pause

    Engine-Section "Special Key Names"

    Engine-Teach "send-keys recognizes these special keys:"
    Write-Host ""
    Write-Host "  ${C_BOLD}Enter${C_RESET}        Return/Enter key"
    Write-Host "  ${C_BOLD}Escape${C_RESET}       Escape key"
    Write-Host "  ${C_BOLD}Space${C_RESET}        Space bar"
    Write-Host "  ${C_BOLD}Tab${C_RESET}          Tab key"
    Write-Host "  ${C_BOLD}BSpace${C_RESET}       Backspace"
    Write-Host "  ${C_BOLD}Up/Down${C_RESET}      Arrow keys"
    Write-Host "  ${C_BOLD}Left/Right${C_RESET}   Arrow keys"
    Write-Host "  ${C_BOLD}C-c${C_RESET}          Ctrl+C"
    Write-Host "  ${C_BOLD}C-z${C_RESET}          Ctrl+Z"
    Write-Host "  ${C_BOLD}C-l${C_RESET}          Ctrl+L (clear screen)"
    Write-Host ""

    Engine-Pause

    Engine-Section "Literal vs Key Names"

    Engine-Teach @"
By default, send-keys interprets special key names. Use -l to
send text literally (no key interpretation):
"@
    Write-Host ""
    UI-Command "tmux send-keys 'Enter'" "Sends the Enter KEY"
    UI-Command "tmux send-keys -l 'Enter'" "Types the WORD 'Enter'"
    Write-Host ""

    Engine-Teach "This is important when you need to type text that matches a key name."

    Engine-Pause

    Engine-Section "Clearing a Pane"

    Engine-Teach "Before running a command, you might want to clear the pane:"
    Write-Host ""
    UI-Command "tmux send-keys C-c" "Cancel any running command"
    UI-Command "tmux send-keys C-l" "Clear the screen"
    UI-Command "tmux send-keys '' Enter" "Send a blank Enter"
    Write-Host ""

    Engine-Teach "A common pattern for scripts:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Clear and run a command${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t work:0 C-c${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t work:0 C-l${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t work:0 'npm start' Enter${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Automating Multiple Panes"

    Engine-Teach "Set up a multi-pane workflow:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}# Start a 3-pane dev environment${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux new-session -d -s dev${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Pane 0: editor${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t dev 'vim .' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Pane 1: server${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -h -t dev${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t dev 'npm run dev' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Pane 2: terminal${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -v -t dev${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t dev 'git status' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Focus on the editor${C_RESET}"
    Write-Host "  ${C_WHITE}tmux select-pane -t dev:0.0${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Attach to the session${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t dev${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Synchronized Panes"

    Engine-Teach "Type the same command in ALL panes simultaneously:"
    Write-Host ""
    UI-Command "tmux setw synchronize-panes on" "Enable sync"
    UI-Command "tmux setw synchronize-panes off" "Disable sync"
    Write-Host ""

    Engine-Teach @"
This is extremely useful for:
  - Running the same command on multiple servers
  - Updating multiple environments at once
  - Comparing command output side-by-side
"@

    Engine-Pause

    Engine-Section "Capturing Output"

    Engine-Teach "Capture what's currently displayed in a pane:"
    Write-Host ""
    UI-Command "tmux capture-pane -p" "Print pane content to stdout"
    UI-Command "tmux capture-pane -p -S -100" "Last 100 lines"
    UI-Command "tmux capture-pane -p > output.txt" "Save to file"
    UI-Command "tmux capture-pane -t work:0 -p" "Capture specific pane"
    Write-Host ""

    Engine-Teach @"
This is useful for logging, testing, and extracting information
from running processes.
"@

    Engine-Pause

    # -- Exercise --
    Engine-Exercise -ExerciseId "send-keys-1" `
        -Title "Automate with send-keys" `
        -Instructions @"
Create a sandbox session and send a command to it:

1. tmux new-session -d -s automated
2. tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset

            $null = tmux has-session -t "automated" 2>$null
            if ($LASTEXITCODE -ne 0) {
                Set-VerifyMessage "Session 'automated' not found"
                Set-VerifyHint "Run: tmux new-session -d -s automated"
                return $false
            }

            $content = tmux capture-pane -t "automated" -p 2>$null

            if ($content -match "HELLO_AUTOMATED") {
                Set-VerifyMessage "Found 'HELLO_AUTOMATED' in the automated session"
                return $true
            } else {
                Set-VerifyMessage "'HELLO_AUTOMATED' not found in session output"
                Set-VerifyHint "Run: tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter"
                return $false
            }
        } `
        -Hint "Run both commands: tmux new-session -d -s automated && sleep 0.5 && tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter" `
        -UseSandbox "none"

    # Cleanup
    tmux kill-session -t automated 2>$null

    Engine-Teach @"
send-keys is incredibly powerful for automation. Combined with
session/window/pane management, you can script entire workflows.
"@
}
