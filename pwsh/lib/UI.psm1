# UI.psm1 - Terminal UI helpers using ANSI escape codes

# Colors
$script:C_RESET    = "`e[0m"
$script:C_BOLD     = "`e[1m"
$script:C_DIM      = "`e[2m"
$script:C_ITALIC   = "`e[3m"
$script:C_UNDERLINE = "`e[4m"
$script:C_RED      = "`e[31m"
$script:C_GREEN    = "`e[32m"
$script:C_YELLOW   = "`e[33m"
$script:C_BLUE     = "`e[34m"
$script:C_MAGENTA  = "`e[35m"
$script:C_CYAN     = "`e[36m"
$script:C_WHITE    = "`e[37m"
$script:C_BG_BLUE  = "`e[44m"
$script:C_BG_GREEN = "`e[42m"
$script:C_BG_RED   = "`e[41m"
$script:C_BG_YELLOW = "`e[43m"

# Unicode box-drawing characters
$script:BOX_TL = [char]0x2554; $script:BOX_TR = [char]0x2557
$script:BOX_BL = [char]0x255A; $script:BOX_BR = [char]0x255D
$script:BOX_H  = [char]0x2550; $script:BOX_V  = [char]0x2551
$script:BOX_TL_S = [char]0x250C; $script:BOX_TR_S = [char]0x2510
$script:BOX_BL_S = [char]0x2514; $script:BOX_BR_S = [char]0x2518
$script:BOX_H_S  = [char]0x2500; $script:BOX_V_S  = [char]0x2502
$script:CHECKMARK = [char]0x2713
$script:CROSSMARK = [char]0x2717
$script:ARROW     = [char]0x2192
$script:BULLET    = [char]0x2022
$script:LOCK      = [char]0x1F512
$script:BOOK      = [char]0x1F4D7
$script:PROGRESS_FULL  = [char]0x2588
$script:PROGRESS_EMPTY = [char]0x2591

function UI-Clear {
    Write-Host "`e[2J`e[H" -NoNewline
}

function UI-TermWidth {
    try {
        if ($env:TMUX) {
            $w = tmux display-message -p '#{pane_width}' 2>$null
            if ($w) { return [int]$w }
        }
        return [Console]::WindowWidth
    } catch {
        return 80
    }
}

function UI-Repeat {
    param([string]$Str, [int]$Count)
    if ($Count -le 0) { return "" }
    return ($Str * $Count)
}

function UI-Center {
    param([string]$Text)
    $width = UI-TermWidth
    $pad = [Math]::Max(0, [Math]::Floor(($width - $Text.Length) / 2))
    Write-Host ("{0}{1}" -f (' ' * $pad), $Text)
}

function UI-Header {
    param([string]$Title)
    $width = 50
    $inner = $width - 2
    $titleLen = $Title.Length
    $leftPad = [Math]::Floor(($inner - $titleLen) / 2)
    $rightPad = $inner - $titleLen - $leftPad

    Write-Host ""
    Write-Host "  ${script:C_CYAN}${script:BOX_TL}$(UI-Repeat $script:BOX_H $inner)${script:BOX_TR}${script:C_RESET}"
    Write-Host "  ${script:C_CYAN}${script:BOX_V}${script:C_RESET}$(' ' * $leftPad)${script:C_BOLD}${script:C_WHITE}${Title}${script:C_RESET}$(' ' * $rightPad)${script:C_CYAN}${script:BOX_V}${script:C_RESET}"
    Write-Host "  ${script:C_CYAN}${script:BOX_BL}$(UI-Repeat $script:BOX_H $inner)${script:BOX_BR}${script:C_RESET}"
    Write-Host ""
}

function UI-SubHeader {
    param([string]$Title)
    $width = 46
    $titleLen = $Title.Length
    $rightPad = [Math]::Max(0, $width - $titleLen - 2)

    Write-Host ""
    Write-Host "  ${script:C_YELLOW}${script:BOX_TL_S}$(UI-Repeat $script:BOX_H_S $width)${script:BOX_TR_S}${script:C_RESET}"
    Write-Host "  ${script:C_YELLOW}${script:BOX_V_S}${script:C_RESET} ${script:C_BOLD}${Title}${script:C_RESET}$(' ' * $rightPad) ${script:C_YELLOW}${script:BOX_V_S}${script:C_RESET}"
    Write-Host "  ${script:C_YELLOW}${script:BOX_BL_S}$(UI-Repeat $script:BOX_H_S $width)${script:BOX_BR_S}${script:C_RESET}"
    Write-Host ""
}

function UI-WordWrap {
    param([string]$Text, [int]$MaxWidth)
    $words = $Text -split '\s+'
    $lines = @()
    $currentLine = ""
    foreach ($word in $words) {
        if ($currentLine.Length -eq 0) {
            $currentLine = $word
        } elseif (($currentLine.Length + 1 + $word.Length) -le $MaxWidth) {
            $currentLine += " $word"
        } else {
            $lines += $currentLine
            $currentLine = $word
        }
    }
    if ($currentLine.Length -gt 0) { $lines += $currentLine }
    return $lines
}

function UI-Info {
    param([string]$Text)
    $width = UI-TermWidth
    $maxWidth = [Math]::Min($width - 6, 76)
    foreach ($line in ($Text -split "`n")) {
        foreach ($wrapped in (UI-WordWrap $line $maxWidth)) {
            Write-Host "  $wrapped"
        }
    }
    Write-Host ""
}

function UI-Print {
    param([string]$Color, [string]$Text)
    Write-Host "  ${Color}${Text}${script:C_RESET}"
}

function UI-Success {
    param([string]$Message)
    Write-Host "  ${script:C_GREEN}${script:C_BOLD}${script:CHECKMARK} ${Message}${script:C_RESET}"
}

function UI-Warn {
    param([string]$Message)
    Write-Host "  ${script:C_YELLOW}${script:C_BOLD}! ${Message}${script:C_RESET}"
}

function UI-Error {
    param([string]$Message)
    Write-Host "  ${script:C_RED}${script:C_BOLD}${script:CROSSMARK} ${Message}${script:C_RESET}"
}

function UI-PressEnter {
    param([string]$Message = "Press Enter to continue...")
    Write-Host ""
    Write-Host "  ${script:C_DIM}${Message}${script:C_RESET}" -NoNewline
    $null = Read-Host
}

function UI-Confirm {
    param([string]$Question)
    Write-Host "  ${script:C_CYAN}${script:C_BOLD}?${script:C_RESET} ${Question} ${script:C_DIM}(y/n)${script:C_RESET} " -NoNewline
    $answer = Read-Host
    return ($answer -match '^[Yy]')
}

function UI-Menu {
    param([string]$Title, [string[]]$Options)

    if ($Title) {
        Write-Host ""
        Write-Host "  ${script:C_BOLD}${Title}${script:C_RESET}"
        Write-Host ""
    }

    for ($i = 0; $i -lt $Options.Count; $i++) {
        $num = $i + 1
        Write-Host "  ${script:C_CYAN}${script:C_BOLD}$("{0,2}" -f $num)${script:C_RESET}${script:C_DIM})${script:C_RESET} $($Options[$i])"
    }

    Write-Host ""
    while ($true) {
        Write-Host "  ${script:C_CYAN}${script:C_BOLD}>${script:C_RESET} Enter choice: " -NoNewline
        $choice = Read-Host
        if ($choice -eq 'q' -or $choice -eq 'Q') {
            return -1
        }
        if ($choice -match '^\d+$') {
            $num = [int]$choice
            if ($num -ge 1 -and $num -le $Options.Count) {
                return ($num - 1)
            }
        }
        UI-Error "Invalid choice. Enter 1-$($Options.Count) or 'q' to quit."
    }
}

function UI-ProgressBar {
    param([int]$Current, [int]$Total, [int]$Width = 30)
    if ($Total -eq 0) { $Total = 1 }
    $filled = [Math]::Floor($Current * $Width / $Total)
    $empty = $Width - $filled
    $pct = [Math]::Floor($Current * 100 / $Total)
    $bar = "${script:C_GREEN}$(UI-Repeat $script:PROGRESS_FULL $filled)${script:C_DIM}$(UI-Repeat $script:PROGRESS_EMPTY $empty)${script:C_RESET}"
    Write-Host "  ${bar} ${script:C_BOLD}$("{0,3}" -f $pct)%${script:C_RESET}  (${Current}/${Total})"
}

function UI-Typewriter {
    param([string]$Text, [double]$Delay = 0.02)
    $skip = $false
    foreach ($char in $Text.ToCharArray()) {
        if (-not $skip -and [Console]::KeyAvailable) {
            $null = [Console]::ReadKey($true)
            $skip = $true
        }
        if ($skip) {
            $remaining = $Text.Substring($Text.IndexOf($char))
            Write-Host $remaining -NoNewline
            break
        }
        Write-Host $char -NoNewline
        Start-Sleep -Milliseconds ([int]($Delay * 1000))
    }
    if (-not $skip) { Write-Host "" } else { Write-Host "" }
}

function UI-Keybinding {
    param([string]$Prefix, [string]$Key, [string]$Description)
    Write-Host "  ${script:C_BG_BLUE}${script:C_WHITE}${script:C_BOLD} ${Prefix} ${script:C_RESET}" -NoNewline
    if ($Key) {
        Write-Host " + ${script:C_BG_BLUE}${script:C_WHITE}${script:C_BOLD} ${Key} ${script:C_RESET}" -NoNewline
    }
    Write-Host "  ${script:C_DIM}${script:ARROW}${script:C_RESET}  ${Description}"
}

function UI-Command {
    param([string]$Cmd, [string]$Description = "")
    Write-Host "  ${script:C_GREEN}$ ${script:C_BOLD}${Cmd}${script:C_RESET}" -NoNewline
    if ($Description) {
        Write-Host "  ${script:C_DIM}# ${Description}${script:C_RESET}" -NoNewline
    }
    Write-Host ""
}

function UI-Separator {
    $width = UI-TermWidth
    $sepWidth = [Math]::Min($width - 4, 76)
    Write-Host "  ${script:C_DIM}$(UI-Repeat $script:BOX_H_S $sepWidth)${script:C_RESET}"
}

function UI-Tip {
    param([string]$Text)
    Write-Host ""
    Write-Host "  ${script:C_YELLOW}${script:C_BOLD}TIP:${script:C_RESET} ${script:C_YELLOW}${Text}${script:C_RESET}"
    Write-Host ""
}

function UI-ExerciseBox {
    param([string]$Title, [string]$Instructions)
    $width = 46

    Write-Host ""
    Write-Host "  ${script:C_GREEN}${script:BOX_TL_S}$(UI-Repeat $script:BOX_H_S $width)${script:BOX_TR_S}${script:C_RESET}"

    $titleLine = "EXERCISE: ${Title}"
    $titleLen = $titleLine.Length
    $rpad = [Math]::Max(0, $width - $titleLen - 1)
    Write-Host "  ${script:C_GREEN}${script:BOX_V_S}${script:C_RESET} ${script:C_BOLD}${script:C_GREEN}${titleLine}${script:C_RESET}$(' ' * $rpad) ${script:C_GREEN}${script:BOX_V_S}${script:C_RESET}"

    Write-Host "  ${script:C_GREEN}${script:BOX_V_S}$(' ' * $width)${script:BOX_V_S}${script:C_RESET}"

    foreach ($line in ($Instructions -split "`n")) {
        foreach ($wrapped in (UI-WordWrap $line ($width - 2))) {
            $pad = [Math]::Max(0, $width - $wrapped.Length - 1)
            Write-Host "  ${script:C_GREEN}${script:BOX_V_S}${script:C_RESET} ${wrapped}$(' ' * $pad)${script:C_GREEN}${script:BOX_V_S}${script:C_RESET}"
        }
    }

    Write-Host "  ${script:C_GREEN}${script:BOX_BL_S}$(UI-Repeat $script:BOX_H_S $width)${script:BOX_BR_S}${script:C_RESET}"
    Write-Host ""
}

function UI-Logo {
    Write-Host "${script:C_CYAN}${script:C_BOLD}"
    Write-Host ""
    Write-Host "     _                           _"
    Write-Host "    | |_ _ __ ___  _   ___  __ | | ___  __ _ _ __ _ __"
    Write-Host "    | __| '_ `` _ \| | | \ \/ / | |/ _ \/ _`` | '__| '_ \"
    Write-Host "    | |_| | | | | | |_| |>  <  | |  __/ (_| | |  | | | |"
    Write-Host "     \__|_| |_| |_|\__,_/_/\_\ |_|\___|\__,_|_|  |_| |_|"
    Write-Host ""
    Write-Host "${script:C_RESET}"
    UI-Center "Interactive Tmux Tutorial (PowerShell Edition)"
    Write-Host ""
}

Export-ModuleMember -Function UI-*, -Variable C_*, BOX_*, CHECKMARK, CROSSMARK, ARROW, BULLET, LOCK, BOOK, PROGRESS_FULL, PROGRESS_EMPTY
