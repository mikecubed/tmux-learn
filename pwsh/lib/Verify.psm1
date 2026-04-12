# Verify.psm1 - Exercise verification framework

$script:VERIFY_MESSAGE = ""
$script:VERIFY_HINT = ""

function Verify-Reset {
    $script:VERIFY_MESSAGE = ""
    $script:VERIFY_HINT = ""
}

function Get-VerifyMessage { return $script:VERIFY_MESSAGE }
function Get-VerifyHint { return $script:VERIFY_HINT }
function Set-VerifyMessage { param([string]$Msg) $script:VERIFY_MESSAGE = $Msg }
function Set-VerifyHint { param([string]$Hint) $script:VERIFY_HINT = $Hint }

function Verify-SessionExists {
    param([string]$Name)
    Verify-Reset
    $null = tmux has-session -t $Name 2>$null
    if ($LASTEXITCODE -eq 0) {
        $script:VERIFY_MESSAGE = "Session '$Name' exists"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Session '$Name' not found"
        $script:VERIFY_HINT = "Create a session with: tmux new-session -s $Name"
        return $false
    }
}

function Verify-SessionNotExists {
    param([string]$Name)
    Verify-Reset
    $null = tmux has-session -t $Name 2>$null
    if ($LASTEXITCODE -ne 0) {
        $script:VERIFY_MESSAGE = "Session '$Name' has been removed"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Session '$Name' still exists"
        $script:VERIFY_HINT = "Kill the session with: tmux kill-session -t $Name"
        return $false
    }
}

function Verify-SessionCount {
    param([int]$Expected)
    Verify-Reset
    $sessions = @(tmux list-sessions -F '#{session_name}' 2>$null | Where-Object { $_ -notmatch '^tmux-learn' })
    $count = $sessions.Count
    if ($count -ge $Expected) {
        $script:VERIFY_MESSAGE = "Found $count session(s) (expected at least $Expected)"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Found $count session(s), but expected at least $Expected"
        $script:VERIFY_HINT = "Create more sessions with: tmux new-session -d -s <name>"
        return $false
    }
}

function Verify-WindowCount {
    param([string]$Session, [int]$Expected)
    Verify-Reset
    $count = @(tmux list-windows -t $Session 2>$null).Count
    if ($count -ge $Expected) {
        $script:VERIFY_MESSAGE = "Session '$Session' has $count window(s) (expected at least $Expected)"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Session '$Session' has $count window(s), but expected at least $Expected"
        $script:VERIFY_HINT = "Create windows with Prefix + c or: tmux new-window -t $Session"
        return $false
    }
}

function Verify-WindowCountExact {
    param([string]$Session, [int]$Expected)
    Verify-Reset
    $count = @(tmux list-windows -t $Session 2>$null).Count
    if ($count -eq $Expected) {
        $script:VERIFY_MESSAGE = "Session '$Session' has exactly $count window(s)"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Session '$Session' has $count window(s), expected exactly $Expected"
        return $false
    }
}

function Verify-WindowName {
    param([string]$Session, [int]$Index, [string]$ExpectedName)
    Verify-Reset
    $actualName = tmux display-message -t "${Session}:${Index}" -p '#{window_name}' 2>$null
    if ($actualName -eq $ExpectedName) {
        $script:VERIFY_MESSAGE = "Window $Index is named '$ExpectedName'"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Window $Index is named '$actualName', expected '$ExpectedName'"
        $script:VERIFY_HINT = "Rename with Prefix + , or: tmux rename-window -t ${Session}:${Index} $ExpectedName"
        return $false
    }
}

function Verify-WindowNameExists {
    param([string]$Session, [string]$ExpectedName)
    Verify-Reset
    $names = @(tmux list-windows -t $Session -F '#{window_name}' 2>$null)
    if ($names -contains $ExpectedName) {
        $script:VERIFY_MESSAGE = "Found window named '$ExpectedName'"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "No window named '$ExpectedName' found"
        $script:VERIFY_HINT = "Rename a window with Prefix + , or: tmux rename-window '$ExpectedName'"
        return $false
    }
}

function Verify-PaneCount {
    param([string]$Target, [int]$Expected)
    Verify-Reset
    $count = @(tmux list-panes -t $Target 2>$null).Count
    if ($count -ge $Expected) {
        $script:VERIFY_MESSAGE = "Found $count pane(s) (expected at least $Expected)"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Found $count pane(s), but expected at least $Expected"
        $script:VERIFY_HINT = 'Split panes with Prefix + % (vertical) or Prefix + " (horizontal)'
        return $false
    }
}

function Verify-PaneCountExact {
    param([string]$Target, [int]$Expected)
    Verify-Reset
    $count = @(tmux list-panes -t $Target 2>$null).Count
    if ($count -eq $Expected) {
        $script:VERIFY_MESSAGE = "Found exactly $count pane(s)"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Found $count pane(s), expected exactly $Expected"
        return $false
    }
}

function Verify-OptionSet {
    param([string]$Option, [string]$ExpectedValue, [string]$Scope = "global")
    Verify-Reset
    $actualValue = switch ($Scope) {
        "global"  { tmux show-options -gv $Option 2>$null }
        "session" { tmux show-options -v $Option 2>$null }
        "window"  { tmux show-window-options -v $Option 2>$null }
    }
    if ($actualValue -eq $ExpectedValue) {
        $script:VERIFY_MESSAGE = "Option '$Option' is set to '$ExpectedValue'"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Option '$Option' is '$actualValue', expected '$ExpectedValue'"
        $script:VERIFY_HINT = "Set it with: tmux set-option -g $Option $ExpectedValue"
        return $false
    }
}

function Verify-Keybinding {
    param([string]$Key, [string]$CommandPattern)
    Verify-Reset
    $keys = tmux list-keys 2>$null
    $match = $keys | Where-Object { $_ -match $Key -and $_ -match $CommandPattern }
    if ($match) {
        $script:VERIFY_MESSAGE = "Keybinding for '$Key' is configured"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Keybinding for '$Key' not found or doesn't match expected command"
        $script:VERIFY_HINT = "Bind with: tmux bind-key $Key $CommandPattern"
        return $false
    }
}

function Verify-PaneContent {
    param([string]$Target, [string]$Pattern)
    Verify-Reset
    $content = tmux capture-pane -t $Target -p 2>$null
    if ($content -match $Pattern) {
        $script:VERIFY_MESSAGE = "Found expected content in pane"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Expected content not found in pane"
        return $false
    }
}

function Verify-BufferContent {
    param([string]$Pattern)
    Verify-Reset
    $content = tmux show-buffer 2>$null
    if ($content -and ($content -match $Pattern)) {
        $script:VERIFY_MESSAGE = "Buffer contains expected content"
        return $true
    } else {
        $script:VERIFY_MESSAGE = "Buffer doesn't contain expected content"
        $script:VERIFY_HINT = "Copy text in copy mode (Prefix + [), navigate, press Space to start selection, Enter to copy"
        return $false
    }
}

Export-ModuleMember -Function Verify-*, Get-Verify*, Set-Verify*
