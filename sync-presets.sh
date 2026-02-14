#!/bin/bash
set -e

WORKFLOW_FILE=".github/workflows/build-and-release.yml"
PRESETS_DIR="presets"

# Get all preset filenames without .yml extension
PRESETS=$(ls "$PRESETS_DIR"/*.yml 2>/dev/null | xargs -n1 basename | sed 's/\.yml$//' | sort)

if [ -z "$PRESETS" ]; then
  echo "No presets found in $PRESETS_DIR/"
  exit 1
fi

# Create temp file with updated options
TEMP_FILE=$(mktemp)
IN_OPTIONS=false

while IFS= read -r line; do
  if [[ "$line" == "        options:" ]]; then
    echo "$line"
    echo "          - custom"
    for preset in $PRESETS; do
      echo "          - $preset"
    done
    IN_OPTIONS=true
  elif $IN_OPTIONS && [[ "$line" =~ ^\ {6}[a-z] ]]; then
    # End of options section (next input field)
    echo "$line"
    IN_OPTIONS=false
  elif ! $IN_OPTIONS; then
    echo "$line"
  fi
done < "$WORKFLOW_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$WORKFLOW_FILE"

echo "✓ Updated workflow with presets:"
echo "  - custom"
for preset in $PRESETS; do
  echo "  - $preset"
done
