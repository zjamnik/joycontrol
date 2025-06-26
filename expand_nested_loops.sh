#!/usr/bin/env bash
set -euo pipefail

# Recursively read lines until EOF or a "loopend" is encountered.
# Prints everything it reads, expanding any nested loops.
expand() {
  local line repeat body
  # Read one line at a time
  while IFS= read -r line; do
    # If this is the start of a loop, grab the count
    if [[ $line =~ ^[[:space:]]*loop[[:space:]]+([0-9]+)[[:space:]]*$ ]]; then
      repeat=${BASH_REMATCH[1]}
      # Recursively collect inner block into an array
      mapfile -t body < <( expand )
      # Print that block "repeat" times
      for ((i=0; i<repeat; i++)); do
        printf '%s\n' "${body[@]}"
      done

    # If this is the end of the current loop, return to caller
    elif [[ $line =~ ^[[:space:]]*loopend[[:space:]]*$ ]]; then
      return

    # Otherwise, just print the line verbatim
    else
      printf '%s\n' "$line"
    fi
  done
}

# Kick it off: read from file if given, otherwise stdin
expand < "${1:-/dev/stdin}"
