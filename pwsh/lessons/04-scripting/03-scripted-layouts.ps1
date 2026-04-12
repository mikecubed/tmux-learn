# Lesson: Scripted Layouts

function Lesson-Info {
    Set-LessonInfo `
        -Title "Building Scripted Layouts" `
        -Module "04-scripting" `
        -Description "Create complex, reproducible tmux layouts with scripts." `
        -Time "10 minutes" `
        -Prerequisites "04-scripting/02-send-keys"
}

function Lesson-Run {
    Engine-Section "Why Script Layouts?"

    Engine-Teach @"
Instead of manually setting up your tmux environment every time,
write a script that creates your ideal layout instantly.

Benefits:
  - Consistent workspace every time
  - Share setups with your team
  - Quick recovery after reboots
  - Per-project configurations
"@

    Engine-Pause

    Engine-Section "Layout Script Pattern"

    Engine-Teach "Here's the standard pattern for a layout script:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"myproject`"${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Kill existing session if any${C_RESET}"
    Write-Host "  ${C_WHITE}tmux kill-session -t `$SESSION 2>/dev/null${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Create new session (detached)${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -d -s `$SESSION -c ~/projects/myproject${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Set up windows and panes...${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Attach at the end${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t `$SESSION${C_RESET}"
    Write-Host ""

    Engine-Teach "The -c flag sets the starting directory for the session."

    Engine-Pause

    Engine-Section "Example: Web Dev Layout"

    Engine-Teach "A typical web development environment:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"webapp`"${C_RESET}"
    Write-Host "  ${C_WHITE}PROJECT=~/projects/webapp${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux kill-session -t `$SESSION 2>/dev/null${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Window 1: Editor${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -d -s `$SESSION -n editor -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:editor 'vim .' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Window 2: Server + Logs${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-window -t `$SESSION -n server -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:server 'npm run dev' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -v -t `$SESSION:server -c `$PROJECT -p 30${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:server.1 'tail -f logs/dev.log' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Window 3: Git + Terminal${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-window -t `$SESSION -n git -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:git 'git status' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -h -t `$SESSION:git -c `$PROJECT${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# Select first window and attach${C_RESET}"
    Write-Host "  ${C_WHITE}tmux select-window -t `$SESSION:editor${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t `$SESSION${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Using Percentage Splits"

    Engine-Teach "Control pane sizes precisely with -p (percentage) or -l (lines/columns):"
    Write-Host ""
    UI-Command "tmux split-window -v -p 30" "Bottom pane gets 30% height"
    UI-Command "tmux split-window -h -p 70" "Right pane gets 70% width"
    UI-Command "tmux split-window -v -l 10" "Bottom pane gets 10 rows"
    Write-Host ""

    Engine-Pause

    Engine-Section "Idempotent Scripts"

    Engine-Teach "Make your scripts safe to run multiple times:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"work`"${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Attach if session already exists${C_RESET}"
    Write-Host "  ${C_WHITE}tmux has-session -t `$SESSION 2>/dev/null${C_RESET}"
    Write-Host "  ${C_WHITE}if [ `$? -eq 0 ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}  echo `"Session exists. Attaching...`"${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux attach -t `$SESSION${C_RESET}"
    Write-Host "  ${C_WHITE}  exit 0${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Otherwise create it...${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -d -s `$SESSION${C_RESET}"
    Write-Host "  ${C_WHITE}# ... set up layout ...${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t `$SESSION${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Using select-layout for Precision"

    Engine-Teach "For complex layouts, create panes then apply a layout checksum:"
    Write-Host ""
    UI-Command "tmux list-windows -F '#{window_layout}'" "Get current layout checksum"
    Write-Host ""

    Engine-Teach "You can save this checksum and replay it:"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux select-layout '5b0f,191x47,0,0{95x47,0,0,0,95x47,96,0[95x23,96,0,1,95x23,96,24,2]}'${C_RESET}"
    Write-Host ""

    Engine-Teach @"
This precisely reproduces a complex layout. The checksum encodes
all pane positions and sizes.
"@

    Engine-Pause

    # -- Exercise --
    Engine-Exercise -ExerciseId "scripted-layouts-1" `
        -Title "Build a Scripted Layout" `
        -Instructions @"
Create a session named 'layout-test' with:
1. A session named 'layout-test'
2. The first window named 'main'
3. At least 2 panes in that window

Run these commands:
  tmux new-session -d -s layout-test -n main
  tmux split-window -h -t layout-test:main

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset

            $null = tmux has-session -t "layout-test" 2>$null
            if ($LASTEXITCODE -ne 0) {
                Set-VerifyMessage "Session 'layout-test' not found"
                Set-VerifyHint "Run: tmux new-session -d -s layout-test -n main"
                return $false
            }

            $winName = tmux list-windows -t "layout-test" -F '#{window_name}' 2>$null | Select-Object -First 1

            if ($winName -ne "main") {
                Set-VerifyMessage "First window is named '$winName', expected 'main'"
                Set-VerifyHint "Kill and recreate: tmux kill-session -t layout-test && tmux new-session -d -s layout-test -n main"
                return $false
            }

            $paneCount = (tmux list-panes -t "layout-test:main" 2>$null | Measure-Object -Line).Lines

            if ($paneCount -ge 2) {
                Set-VerifyMessage "Session 'layout-test' has window 'main' with $paneCount panes"
                return $true
            } else {
                Set-VerifyMessage "Window 'main' has $paneCount pane(s), expected at least 2"
                Set-VerifyHint "Run: tmux split-window -h -t layout-test:main"
                return $false
            }
        } `
        -Hint "Run: tmux new-session -d -s layout-test -n main && tmux split-window -h -t layout-test:main" `
        -UseSandbox "none"

    # Cleanup
    tmux kill-session -t layout-test 2>$null

    Engine-Teach @"
Scripted layouts transform tmux from a tool into a personalized
development environment. Many developers have a script per project.
"@
}
