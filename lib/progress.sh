#!/usr/bin/env bash
# progress.sh - Progress tracking for tmux-learn

PROGRESS_DIR="$HOME/.tmux-learn"
PROGRESS_FILE="$PROGRESS_DIR/progress"

progress_init() {
    mkdir -p "$PROGRESS_DIR"
    touch "$PROGRESS_FILE"
}

progress_mark_complete() {
    local lesson_id="$1"
    local timestamp
    timestamp=$(date +%s)

    # Remove any existing entry for this lesson
    if [[ -f "$PROGRESS_FILE" ]]; then
        local tmp
        tmp=$(grep -v "^${lesson_id}=" "$PROGRESS_FILE" 2>/dev/null || true)
        echo "$tmp" > "$PROGRESS_FILE"
    fi

    echo "${lesson_id}=complete:${timestamp}" >> "$PROGRESS_FILE"
}

progress_mark_in_progress() {
    local lesson_id="$1"
    local timestamp
    timestamp=$(date +%s)

    if [[ -f "$PROGRESS_FILE" ]]; then
        local tmp
        tmp=$(grep -v "^${lesson_id}=" "$PROGRESS_FILE" 2>/dev/null || true)
        echo "$tmp" > "$PROGRESS_FILE"
    fi

    echo "${lesson_id}=in-progress:${timestamp}" >> "$PROGRESS_FILE"
}

progress_is_complete() {
    local lesson_id="$1"
    grep -q "^${lesson_id}=complete:" "$PROGRESS_FILE" 2>/dev/null
}

progress_get_status() {
    local lesson_id="$1"
    local entry
    entry=$(grep "^${lesson_id}=" "$PROGRESS_FILE" 2>/dev/null | tail -1)
    if [[ -z "$entry" ]]; then
        echo "not-started"
    else
        echo "${entry#*=}" | cut -d: -f1
    fi
}

# Count completed lessons in a module
progress_module_count() {
    local module="$1"
    grep -c "^${module}/.*=complete:" "$PROGRESS_FILE" 2>/dev/null || echo 0
}

# Get total lesson count for a module
progress_module_total() {
    local module_dir="$1"
    local count=0
    if [[ -d "$module_dir" ]]; then
        count=$(find "$module_dir" -maxdepth 1 -name '*.sh' | wc -l)
    fi
    echo "$count"
}

# Get the next incomplete lesson
progress_get_next() {
    local lessons_dir="$1"
    local module lesson

    for module_dir in "$lessons_dir"/*/; do
        [[ -d "$module_dir" ]] || continue
        local module_name
        module_name=$(basename "$module_dir")

        for lesson_file in "$module_dir"*.sh; do
            [[ -f "$lesson_file" ]] || continue
            local lesson_name
            lesson_name=$(basename "$lesson_file" .sh)
            local lesson_id="${module_name}/${lesson_name}"

            if ! progress_is_complete "$lesson_id"; then
                echo "$lesson_id"
                return 0
            fi
        done
    done

    echo ""
    return 1
}

# Get stats: completed/total
progress_get_stats() {
    local lessons_dir="$1"
    local completed=0 total=0

    for module_dir in "$lessons_dir"/*/; do
        [[ -d "$module_dir" ]] || continue
        local module_name
        module_name=$(basename "$module_dir")

        for lesson_file in "$module_dir"*.sh; do
            [[ -f "$lesson_file" ]] || continue
            ((total++))
            local lesson_name
            lesson_name=$(basename "$lesson_file" .sh)
            local lesson_id="${module_name}/${lesson_name}"
            if progress_is_complete "$lesson_id"; then
                ((completed++))
            fi
        done
    done

    echo "$completed $total"
}

progress_reset() {
    if [[ -f "$PROGRESS_FILE" ]]; then
        > "$PROGRESS_FILE"
    fi
}
