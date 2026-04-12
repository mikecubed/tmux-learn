# TmuxHelpers.psm1 - Tmux/psmux introspection wrappers

$script:TMUX_MIN_VERSION = "2.6"
$script:TmuxVersion = ""

function Tmux-CheckInstalled {
    $cmd = Get-Command tmux -ErrorAction SilentlyContinue
    if (-not $cmd) { return $false }
    $versionOutput = tmux -V 2>$null
    if ($versionOutput -match '(\d+\.\d+)') {
        $script:TmuxVersion = $Matches[1]
    }
    return $true
}

function Tmux-VersionGte {
    param([string]$Ver1, [string]$Ver2)
    $v1Parts = $Ver1 -split '\.'
    $v2Parts = $Ver2 -split '\.'
    $v1Major = [int]($v1Parts[0] -replace '[a-z]','')
    $v1Minor = [int]($v1Parts[1] -replace '[a-z]','')
    $v2Major = [int]($v2Parts[0] -replace '[a-z]','')
    $v2Minor = [int]($v2Parts[1] -replace '[a-z]','')

    if ($v1Major -gt $v2Major) { return $true }
    if ($v1Major -lt $v2Major) { return $false }
    return ($v1Minor -ge $v2Minor)
}

function Tmux-CheckVersion {
    if (-not $script:TmuxVersion) {
        if (-not (Tmux-CheckInstalled)) { return $false }
    }
    return (Tmux-VersionGte $script:TmuxVersion $script:TMUX_MIN_VERSION)
}

function Tmux-SessionExists {
    param([string]$Name)
    $null = tmux has-session -t $Name 2>$null
    return ($LASTEXITCODE -eq 0)
}

function Tmux-ListSessions {
    tmux list-sessions -F '#{session_name}' 2>$null
}

function Tmux-CountSessions {
    $sessions = @(tmux list-sessions 2>$null)
    return $sessions.Count
}

function Tmux-CurrentSession {
    tmux display-message -p '#{session_name}' 2>$null
}

function Tmux-CountWindows {
    param([string]$Session = "")
    if ($Session) {
        $windows = @(tmux list-windows -t $Session 2>$null)
    } else {
        $windows = @(tmux list-windows 2>$null)
    }
    return $windows.Count
}

function Tmux-GetWindowName {
    param([string]$Session, [int]$Index)
    tmux display-message -t "${Session}:${Index}" -p '#{window_name}' 2>$null
}

function Tmux-ListWindowNames {
    param([string]$Session = "")
    if ($Session) {
        tmux list-windows -t $Session -F '#{window_name}' 2>$null
    } else {
        tmux list-windows -F '#{window_name}' 2>$null
    }
}

function Tmux-CountPanes {
    param([string]$Target = "")
    if ($Target) {
        $panes = @(tmux list-panes -t $Target 2>$null)
    } else {
        $panes = @(tmux list-panes 2>$null)
    }
    return $panes.Count
}

function Tmux-GetPaneWidth {
    param([string]$Target = "")
    if ($Target) {
        tmux display-message -t $Target -p '#{pane_width}' 2>$null
    } else {
        tmux display-message -p '#{pane_width}' 2>$null
    }
}

function Tmux-GetPaneHeight {
    param([string]$Target = "")
    if ($Target) {
        tmux display-message -t $Target -p '#{pane_height}' 2>$null
    } else {
        tmux display-message -p '#{pane_height}' 2>$null
    }
}

function Tmux-PaneContent {
    param([string]$Target = "", [string]$Start = "", [string]$End = "")
    $args_ = @("-t", $Target, "-p")
    if ($Start) { $args_ += @("-S", $Start) }
    if ($End) { $args_ += @("-E", $End) }
    tmux capture-pane @args_ 2>$null
}

function Tmux-GetOption {
    param([string]$Option, [string]$Scope = "global")
    switch ($Scope) {
        "global"  { tmux show-options -gv $Option 2>$null }
        "session" { tmux show-options -v $Option 2>$null }
        "window"  { tmux show-window-options -v $Option 2>$null }
    }
}

function Tmux-GetLayout {
    param([string]$Target = "")
    if ($Target) {
        tmux display-message -t $Target -p '#{window_layout}' 2>$null
    } else {
        tmux display-message -p '#{window_layout}' 2>$null
    }
}

function Tmux-HasKeybinding {
    param([string]$Key, [string]$CommandPattern = "")
    $keys = tmux list-keys 2>$null
    if ($CommandPattern) {
        return [bool]($keys | Where-Object { $_ -match $Key -and $_ -match $CommandPattern })
    } else {
        return [bool]($keys | Where-Object { $_ -match $Key })
    }
}

function Tmux-GetPrefix {
    $prefix = tmux show-options -gv prefix 2>$null
    if (-not $prefix) { return "C-b" }
    return $prefix
}

function Tmux-CheckMinSize {
    param([int]$MinWidth = 80, [int]$MinHeight = 24)
    $width = [int](tmux display-message -p '#{window_width}' 2>$null)
    $height = [int](tmux display-message -p '#{window_height}' 2>$null)
    if (-not $width) { $width = 80 }
    if (-not $height) { $height = 24 }
    return ($width -ge $MinWidth -and $height -ge $MinHeight)
}

Export-ModuleMember -Function Tmux-* -Variable TMUX_MIN_VERSION, TmuxVersion
