# Progress.psm1 - Progress tracking for tmux-learn

$script:ProgressDir = Join-Path $HOME ".tmux-learn"
$script:ProgressFile = Join-Path $script:ProgressDir "progress"

function Progress-Init {
    if (-not (Test-Path $script:ProgressDir)) {
        New-Item -ItemType Directory -Path $script:ProgressDir -Force | Out-Null
    }
    if (-not (Test-Path $script:ProgressFile)) {
        New-Item -ItemType File -Path $script:ProgressFile -Force | Out-Null
    }
}

function Progress-MarkComplete {
    param([string]$LessonId)
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $lines = @()
    if (Test-Path $script:ProgressFile) {
        $lines = @(Get-Content $script:ProgressFile | Where-Object { $_ -notmatch "^${LessonId}=" })
    }
    $lines += "${LessonId}=complete:${timestamp}"
    $lines | Set-Content $script:ProgressFile
}

function Progress-MarkInProgress {
    param([string]$LessonId)
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $lines = @()
    if (Test-Path $script:ProgressFile) {
        $lines = @(Get-Content $script:ProgressFile | Where-Object { $_ -notmatch "^${LessonId}=" })
    }
    $lines += "${LessonId}=in-progress:${timestamp}"
    $lines | Set-Content $script:ProgressFile
}

function Progress-IsComplete {
    param([string]$LessonId)
    if (-not (Test-Path $script:ProgressFile)) { return $false }
    $match = Select-String -Path $script:ProgressFile -Pattern "^${LessonId}=complete:" -Quiet
    return [bool]$match
}

function Progress-GetStatus {
    param([string]$LessonId)
    if (-not (Test-Path $script:ProgressFile)) { return "not-started" }
    $entry = Get-Content $script:ProgressFile | Where-Object { $_ -match "^${LessonId}=" } | Select-Object -Last 1
    if (-not $entry) { return "not-started" }
    $status = ($entry -split '=', 2)[1] -split ':' | Select-Object -First 1
    return $status
}

function Progress-ModuleCount {
    param([string]$Module)
    if (-not (Test-Path $script:ProgressFile)) { return 0 }
    $count = @(Get-Content $script:ProgressFile | Where-Object { $_ -match "^${Module}/.*=complete:" }).Count
    return $count
}

function Progress-ModuleTotal {
    param([string]$ModuleDir)
    if (-not (Test-Path $ModuleDir)) { return 0 }
    return @(Get-ChildItem -Path $ModuleDir -Filter "*.ps1").Count
}

function Progress-GetNext {
    param([string]$LessonsDir)
    $modules = Get-ChildItem -Path $LessonsDir -Directory | Sort-Object Name
    foreach ($moduleDir in $modules) {
        $lessons = Get-ChildItem -Path $moduleDir.FullName -Filter "*.ps1" | Sort-Object Name
        foreach ($lessonFile in $lessons) {
            $lessonName = [System.IO.Path]::GetFileNameWithoutExtension($lessonFile.Name)
            $lessonId = "$($moduleDir.Name)/${lessonName}"
            if (-not (Progress-IsComplete $lessonId)) {
                return $lessonId
            }
        }
    }
    return $null
}

function Progress-GetStats {
    param([string]$LessonsDir)
    $completed = 0
    $total = 0
    $modules = Get-ChildItem -Path $LessonsDir -Directory | Sort-Object Name
    foreach ($moduleDir in $modules) {
        $lessons = Get-ChildItem -Path $moduleDir.FullName -Filter "*.ps1" | Sort-Object Name
        foreach ($lessonFile in $lessons) {
            $total++
            $lessonName = [System.IO.Path]::GetFileNameWithoutExtension($lessonFile.Name)
            $lessonId = "$($moduleDir.Name)/${lessonName}"
            if (Progress-IsComplete $lessonId) {
                $completed++
            }
        }
    }
    return @{ Completed = $completed; Total = $total }
}

function Progress-Reset {
    if (Test-Path $script:ProgressFile) {
        "" | Set-Content $script:ProgressFile
    }
}

Export-ModuleMember -Function Progress-*
