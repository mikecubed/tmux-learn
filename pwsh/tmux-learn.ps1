#!/usr/bin/env pwsh
# tmux-learn - Interactive Tmux Tutorial (PowerShell Edition)
# Requires PowerShell 7+ and tmux/psmux

#Requires -Version 7.0

$ErrorActionPreference = "Stop"

# Resolve the script directory
$script:TMUX_LEARN_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Import all modules
Import-Module (Join-Path $script:TMUX_LEARN_DIR "lib/UI.psm1") -Force
Import-Module (Join-Path $script:TMUX_LEARN_DIR "lib/Progress.psm1") -Force
Import-Module (Join-Path $script:TMUX_LEARN_DIR "lib/TmuxHelpers.psm1") -Force
Import-Module (Join-Path $script:TMUX_LEARN_DIR "lib/Verify.psm1") -Force
Import-Module (Join-Path $script:TMUX_LEARN_DIR "lib/Engine.psm1") -Force
Import-Module (Join-Path $script:TMUX_LEARN_DIR "exercises/Sandbox.psm1") -Force

# Module definitions
$script:MODULE_NAMES = @{
    "01-basics"        = "Basics"
    "02-navigation"    = "Navigation"
    "03-customization" = "Customization"
    "04-scripting"     = "Scripting"
    "05-advanced"      = "Advanced"
}

$script:MODULE_DESCRIPTIONS = @{
    "01-basics"        = "Sessions, windows, panes, and basic navigation"
    "02-navigation"    = "Advanced movement, copy mode, and searching"
    "03-customization" = "Configure tmux with .tmux.conf"
    "04-scripting"     = "Automate tmux with shell scripts"
    "05-advanced"      = "Hooks, plugins, pair programming, workflows"
}

$script:MODULE_ORDER = @("01-basics", "02-navigation", "03-customization", "04-scripting", "05-advanced")

function Check-Prerequisites {
    if (-not (Tmux-CheckInstalled)) {
        Write-Host "`e[31mError: tmux/psmux is not installed`e[0m"
        Write-Host ""
        Write-Host "Install psmux (Windows):"
        Write-Host "  winget install psmux.psmux"
        Write-Host "  # or: cargo install psmux"
        Write-Host ""
        Write-Host "Install tmux (Linux/macOS):"
        Write-Host "  macOS:  brew install tmux"
        Write-Host "  Ubuntu: sudo apt install tmux"
        exit 1
    }

    if (-not (Tmux-CheckVersion)) {
        Write-Host "`e[33mWarning: tmux version detected may be below recommended.`e[0m"
        Write-Host "Some features may not work correctly."
        Start-Sleep -Seconds 2
    }
}

function Bootstrap-Tmux {
    if (-not $env:TMUX) {
        # Not inside tmux - create a session and re-launch
        $scriptPath = $MyInvocation.ScriptName
        if (-not $scriptPath) { $scriptPath = $PSCommandPath }
        exec tmux new-session -s "tmux-learn" "pwsh -NoLogo -File `"$scriptPath`""
    }
}

function Module-IsUnlocked {
    param([string]$Module)
    if ($Module -eq "01-basics") { return $true }

    $prevModule = $null
    foreach ($m in $script:MODULE_ORDER) {
        if ($m -eq $Module) { break }
        $prevModule = $m
    }

    if (-not $prevModule) { return $true }

    $prevDir = Join-Path $script:TMUX_LEARN_DIR "lessons/$prevModule"
    $prevTotal = Progress-ModuleTotal $prevDir
    $prevCompleted = Progress-ModuleCount $prevModule

    if ($prevTotal -eq 0) { return $true }

    $threshold = [Math]::Max(1, [Math]::Floor($prevTotal * 80 / 100))
    return ($prevCompleted -ge $threshold)
}

function Get-LessonTitleFromFile {
    param([string]$LessonFile)
    # Source the lesson in a child scope to get title
    $title = & {
        . $LessonFile
        Lesson-Info
        return (Get-LessonTitle)
    }
    return $title
}

function Show-ModuleMenu {
    param([string]$Module)
    $moduleDir = Join-Path $script:TMUX_LEARN_DIR "lessons/$Module"

    while ($true) {
        UI-Clear
        UI-Header $script:MODULE_NAMES[$Module]
        UI-Info $script:MODULE_DESCRIPTIONS[$Module]
        UI-Separator
        Write-Host ""

        $lessons = @()
        $lessonIds = @()
        $lessonFiles = @()

        $files = Get-ChildItem -Path $moduleDir -Filter "*.ps1" | Sort-Object Name
        foreach ($lessonFile in $files) {
            $lessonName = [System.IO.Path]::GetFileNameWithoutExtension($lessonFile.Name)
            $lessonId = "${Module}/${lessonName}"
            $title = Get-LessonTitleFromFile $lessonFile.FullName
            $status = Progress-GetStatus $lessonId

            $statusIcon = switch ($status) {
                "complete"    { "${script:C_GREEN}${script:CHECKMARK}${script:C_RESET}" }
                "in-progress" { "${script:C_YELLOW}${script:ARROW}${script:C_RESET}" }
                default       { "${script:C_DIM}${script:BULLET}${script:C_RESET}" }
            }

            $lessons += "${statusIcon} ${title}"
            $lessonIds += $lessonId
            $lessonFiles += $lessonFile.FullName
        }

        $lessons += "${script:C_DIM}Back to main menu${script:C_RESET}"

        $choice = UI-Menu "" $lessons

        if ($choice -eq -1 -or $choice -eq $lessonFiles.Count) {
            return
        }

        if ($choice -ge 0 -and $choice -lt $lessonFiles.Count) {
            Engine-RunLesson $lessonFiles[$choice] $lessonIds[$choice]
        }
    }
}

function Continue-Lesson {
    $lessonsDir = Join-Path $script:TMUX_LEARN_DIR "lessons"
    $next = Progress-GetNext $lessonsDir

    if (-not $next) {
        UI-Success "All lessons completed! You're a tmux master!"
        UI-PressEnter
        return
    }

    $parts = $next -split '/'
    $module = $parts[0]
    $lesson = $parts[1]
    $lessonFile = Join-Path $script:TMUX_LEARN_DIR "lessons/$module/${lesson}.ps1"

    if (-not (Test-Path $lessonFile)) {
        UI-Error "Lesson file not found: $lessonFile"
        UI-PressEnter
        return
    }

    if (-not (Module-IsUnlocked $module)) {
        UI-Warn "Next lesson is in a locked module. Complete more of the previous module first."
        UI-PressEnter
        return
    }

    Engine-RunLesson $lessonFile $next
}

function Show-MainMenu {
    while ($true) {
        UI-Clear
        UI-Logo

        # Show progress
        $lessonsDir = Join-Path $script:TMUX_LEARN_DIR "lessons"
        $stats = Progress-GetStats $lessonsDir

        Write-Host "  ${script:C_BOLD}Progress:${script:C_RESET} $($stats.Completed)/$($stats.Total) lessons complete"
        UI-ProgressBar $stats.Completed $stats.Total
        Write-Host ""
        UI-Separator

        # Build module list
        $menuItems = @()

        foreach ($module in $script:MODULE_ORDER) {
            $moduleDir = Join-Path $script:TMUX_LEARN_DIR "lessons/$module"
            $modTotal = Progress-ModuleTotal $moduleDir
            $modCompleted = Progress-ModuleCount $module
            $name = $script:MODULE_NAMES[$module]
            $desc = $script:MODULE_DESCRIPTIONS[$module]

            if (Module-IsUnlocked $module) {
                if ($modCompleted -eq $modTotal -and $modTotal -gt 0) {
                    $menuItems += "${script:C_GREEN}${script:CHECKMARK} ${script:C_BOLD}${name}${script:C_RESET}  ${script:C_DIM}(${modCompleted}/${modTotal})${script:C_RESET}  ${script:C_DIM}${desc}${script:C_RESET}"
                } else {
                    $menuItems += "${script:BOOK} ${script:C_BOLD}${name}${script:C_RESET}  ${script:C_DIM}(${modCompleted}/${modTotal})${script:C_RESET}  ${script:C_DIM}${desc}${script:C_RESET}"
                }
            } else {
                $menuItems += "${script:LOCK} ${script:C_DIM}${name}  (locked - complete previous module)${script:C_RESET}"
            }
        }

        $menuItems += "${script:C_CYAN}Continue from last position${script:C_RESET}"
        $menuItems += "${script:C_YELLOW}Reset progress${script:C_RESET}"
        $menuItems += "${script:C_DIM}Quit${script:C_RESET}"

        $choice = UI-Menu "" $menuItems

        if ($choice -eq -1) { break }

        $numModules = $script:MODULE_ORDER.Count

        if ($choice -ge 0 -and $choice -lt $numModules) {
            $selectedModule = $script:MODULE_ORDER[$choice]
            if (Module-IsUnlocked $selectedModule) {
                Show-ModuleMenu $selectedModule
            } else {
                UI-Warn "This module is locked. Complete the previous module first."
                UI-PressEnter
            }
        } elseif ($choice -eq $numModules) {
            Continue-Lesson
        } elseif ($choice -eq ($numModules + 1)) {
            if (UI-Confirm "Reset all progress? This cannot be undone.") {
                Progress-Reset
                UI-Success "Progress reset."
                Start-Sleep -Seconds 1
            }
        } elseif ($choice -eq ($numModules + 2)) {
            break
        }
    }
}

# Cleanup on exit
$cleanupAction = {
    Sandbox-Destroy 2>$null
}

try {
    # Register cleanup
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action $cleanupAction -ErrorAction SilentlyContinue | Out-Null

    # Main entry point
    Check-Prerequisites
    Bootstrap-Tmux
    Progress-Init
    Show-MainMenu

    UI-Clear
    Write-Host ""
    Write-Host "  ${script:C_CYAN}Thanks for using tmux-learn! Happy tmuxing!${script:C_RESET}"
    Write-Host ""
} finally {
    & $cleanupAction
}
