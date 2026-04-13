# Engine.psm1 - Lesson runner engine

# Lesson metadata (set by lesson_info)
$script:LESSON_TITLE = ""
$script:LESSON_MODULE = ""
$script:LESSON_DESCRIPTION = ""
$script:LESSON_TIME = ""
$script:LESSON_PREREQUISITES = ""

# Engine state
$script:ENGINE_LESSON_ID = ""
$script:ENGINE_EXERCISE_COUNT = 0
$script:ENGINE_SANDBOX_PANE = ""

function Set-LessonInfo {
    param(
        [string]$Title,
        [string]$Module,
        [string]$Description = "",
        [string]$Time = "",
        [string]$Prerequisites = ""
    )
    $script:LESSON_TITLE = $Title
    $script:LESSON_MODULE = $Module
    $script:LESSON_DESCRIPTION = $Description
    $script:LESSON_TIME = $Time
    $script:LESSON_PREREQUISITES = $Prerequisites
}

function Get-LessonTitle { return $script:LESSON_TITLE }

function Engine-RunLesson {
    param([string]$LessonFile, [string]$LessonId)
    $script:ENGINE_LESSON_ID = $LessonId
    $script:ENGINE_EXERCISE_COUNT = 0

    # Source the lesson (dot-source to get functions in scope)
    . $LessonFile

    # Get lesson info
    Lesson-Info

    # Show lesson header
    UI-Clear
    UI-Header $script:LESSON_TITLE

    if ($script:LESSON_DESCRIPTION) {
        UI-Info $script:LESSON_DESCRIPTION
    }

    if ($script:LESSON_TIME) {
        UI-Print $script:C_DIM "Estimated time: $($script:LESSON_TIME)"
        Write-Host ""
    }

    UI-Separator
    UI-PressEnter "Press Enter to begin..."

    # Mark in progress
    Progress-MarkInProgress $LessonId

    # Run the lesson
    Lesson-Run

    # Mark complete
    Progress-MarkComplete $LessonId

    # Cleanup sandbox if used
    if ($script:ENGINE_SANDBOX_PANE) {
        Sandbox-CloseSplit $script:ENGINE_SANDBOX_PANE
        $script:ENGINE_SANDBOX_PANE = ""
    }

    # Completion message
    UI-Clear
    UI-Header "Lesson Complete!"
    UI-Success $script:LESSON_TITLE
    Write-Host ""
    UI-Info "Great work! You've completed this lesson."

    $stats = Progress-GetStats (Join-Path $script:TMUX_LEARN_DIR "lessons")
    UI-Info "Overall progress:"
    UI-ProgressBar $stats.Completed $stats.Total
    Write-Host ""

    UI-PressEnter "Press Enter to return to the menu..."
}

function Engine-Teach {
    param([string]$Text)
    Write-Host ""
    $width = UI-TermWidth
    $maxWidth = [Math]::Min($width - 6, 76)

    foreach ($line in ($Text -split "`n")) {
        foreach ($wrapped in (UI-WordWrap $line $maxWidth)) {
            Write-Host "  " -NoNewline
            UI-Typewriter $wrapped 0.01
        }
    }
    Write-Host ""
}

function Engine-Section {
    param([string]$Title)
    UI-SubHeader $Title
}

function Engine-Demo {
    param([string]$Description, [string]$Cmd, [bool]$Execute = $false)
    UI-Info $Description
    UI-Command $Cmd
    Write-Host ""
    if ($Execute) {
        Invoke-Expression $Cmd 2>$null
        Start-Sleep -Milliseconds 500
    }
}

function Engine-ShowKey {
    param([string]$Prefix, [string]$Key, [string]$Description)
    UI-Keybinding $Prefix $Key $Description
}

function Engine-Exercise {
    param(
        [string]$ExerciseId,
        [string]$Title,
        [string]$Instructions,
        [scriptblock]$VerifyFunc,
        [string]$Hint = "",
        [string]$UseSandbox = "session"
    )

    $script:ENGINE_EXERCISE_COUNT++

    UI-Clear
    UI-ExerciseBox $Title $Instructions

    # Create sandbox environment
    switch ($UseSandbox) {
        "session" {
            Sandbox-Create
            UI-Info "A sandbox session '$(Get-SandboxSession)' has been created for you."
            UI-Info "Switch to it with: Prefix + ( or Prefix + s to see session list"
        }
        "split" {
            $script:ENGINE_SANDBOX_PANE = Sandbox-CreateSplit
            UI-Info "A sandbox pane has been opened on the right."
            UI-Info "Click it or use Prefix + Right Arrow to switch to it."
        }
        "current" { }
        "none" { }
    }

    Write-Host ""
    UI-Print $script:C_DIM "Commands: 'check' to verify | 'hint' for help | 'skip' to skip | 'quit' to exit"
    UI-Separator

    $attempts = 0
    $maxAttemptsForHint = 2

    while ($true) {
        Write-Host ""
        Write-Host "  ${script:C_CYAN}${script:C_BOLD}exercise>${script:C_RESET} " -NoNewline
        $userInput = Read-Host

        switch ($userInput) {
            "check" {
                $result = & $VerifyFunc
                if ($result) {
                    Write-Host ""
                    UI-Success (Get-VerifyMessage)
                    UI-Success "Exercise passed!"
                    Write-Host ""
                    UI-PressEnter
                    # Cleanup sandbox
                    if ($UseSandbox -eq "session") { Sandbox-Destroy }
                    elseif ($UseSandbox -eq "split" -and $script:ENGINE_SANDBOX_PANE) {
                        Sandbox-CloseSplit $script:ENGINE_SANDBOX_PANE
                        $script:ENGINE_SANDBOX_PANE = ""
                    }
                    return
                } else {
                    $attempts++
                    Write-Host ""
                    UI-Error (Get-VerifyMessage)
                    $verifyHint = Get-VerifyHint
                    if ($attempts -ge $maxAttemptsForHint -and ($verifyHint -or $Hint)) {
                        Write-Host ""
                        UI-Tip ($verifyHint ? $verifyHint : $Hint)
                    }
                }
            }
            "hint" {
                Write-Host ""
                $verifyHint = Get-VerifyHint
                if ($Hint) { UI-Tip $Hint }
                elseif ($verifyHint) { UI-Tip $verifyHint }
                else { UI-Info "No hints available for this exercise. Keep trying!" }
            }
            "skip" {
                Write-Host ""
                UI-Warn "Skipping exercise..."
                if ($UseSandbox -eq "session") { Sandbox-Destroy }
                elseif ($UseSandbox -eq "split" -and $script:ENGINE_SANDBOX_PANE) {
                    Sandbox-CloseSplit $script:ENGINE_SANDBOX_PANE
                    $script:ENGINE_SANDBOX_PANE = ""
                }
                return
            }
            { $_ -eq "quit" -or $_ -eq "q" } {
                if ($UseSandbox -eq "session") { Sandbox-Destroy }
                elseif ($UseSandbox -eq "split" -and $script:ENGINE_SANDBOX_PANE) {
                    Sandbox-CloseSplit $script:ENGINE_SANDBOX_PANE
                    $script:ENGINE_SANDBOX_PANE = ""
                }
                return
            }
            default {
                UI-Print $script:C_DIM "Type 'check' to verify, 'hint' for help, 'skip' to skip, or 'quit' to exit"
            }
        }
    }
}

function Engine-Checkpoint {
    param([string]$Message = "Progress saved")
    Progress-MarkInProgress $script:ENGINE_LESSON_ID
    UI-Success $Message
}

function Engine-Pause {
    param([string]$Message = "Press Enter to continue...")
    UI-PressEnter $Message
}

function Engine-Quiz {
    param([string]$Question, [string[]]$Options, [int]$CorrectIndex)

    Write-Host ""
    Write-Host "  ${script:C_BOLD}${script:C_YELLOW}QUIZ:${script:C_RESET} ${Question}"
    Write-Host ""

    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "    ${script:C_CYAN}$($i + 1))${script:C_RESET} $($Options[$i])"
    }

    Write-Host ""
    while ($true) {
        Write-Host "  ${script:C_CYAN}answer>${script:C_RESET} " -NoNewline
        $answer = Read-Host
        if ($answer -match '^\d+$') {
            $num = [int]$answer
            if ($num -ge 1 -and $num -le $Options.Count) {
                if ($num -eq $CorrectIndex) {
                    UI-Success "Correct!"
                    return
                } else {
                    UI-Error "Not quite. Try again!"
                }
            } else {
                UI-Print $script:C_DIM "Enter a number 1-$($Options.Count)"
            }
        } else {
            UI-Print $script:C_DIM "Enter a number 1-$($Options.Count)"
        }
    }
}

Export-ModuleMember -Function Engine-*, Set-LessonInfo, Get-LessonTitle
