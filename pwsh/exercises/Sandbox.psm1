# Sandbox.psm1 - Sandbox session management for exercises

$script:SANDBOX_SESSION = "tmux-learn-sandbox"
$script:TUTORIAL_SESSION = "tmux-learn"

function Get-SandboxSession { return $script:SANDBOX_SESSION }

function Sandbox-Create {
    tmux kill-session -t $script:SANDBOX_SESSION 2>$null
    tmux new-session -d -s $script:SANDBOX_SESSION
}

function Sandbox-Destroy {
    tmux kill-session -t $script:SANDBOX_SESSION 2>$null
}

function Sandbox-SwitchTo {
    tmux switch-client -t $script:SANDBOX_SESSION
}

function Sandbox-SwitchBack {
    tmux switch-client -t $script:TUTORIAL_SESSION
}

function Sandbox-CreateSplit {
    $paneId = tmux split-window -h -P -F '#{pane_id}'
    return $paneId
}

function Sandbox-CloseSplit {
    param([string]$PaneId)
    tmux kill-pane -t $PaneId 2>$null
}

function Sandbox-Reset {
    Sandbox-Destroy
    Sandbox-Create
}

function Sandbox-CreateWithWindows {
    param([int]$NumWindows)
    Sandbox-Create
    for ($i = 1; $i -lt $NumWindows; $i++) {
        tmux new-window -t $script:SANDBOX_SESSION
    }
    tmux select-window -t "${script:SANDBOX_SESSION}:0" 2>$null
    if ($LASTEXITCODE -ne 0) {
        tmux select-window -t "${script:SANDBOX_SESSION}:1" 2>$null
    }
}

function Sandbox-SendText {
    param([string]$Text, [string]$Target = "")
    if (-not $Target) { $Target = $script:SANDBOX_SESSION }
    tmux send-keys -t $Target $Text Enter
}

function Sandbox-MarkPane {
    param([string]$Target, [string]$Marker)
    tmux send-keys -t $Target "echo '$Marker'" Enter
}

Export-ModuleMember -Function Sandbox-*, Get-SandboxSession -Variable SANDBOX_SESSION, TUTORIAL_SESSION
