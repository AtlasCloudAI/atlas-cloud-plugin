#!/bin/bash
# Refresh the skills vendored into the plugin from their source repo.
#
# The skills live in AtlasCloudAI/atlas-cloud-skills; this repo only carries
# copies, because Codex does not follow symlinks when it installs a plugin —
# a symlinked skills/ directory installs empty and the skills go missing with
# no error. Two of them are also renamed on the way in: Codex derives every
# visible label from the identifier, and the source names do not title-case
# into anything readable.
#
# Run after the source skills change:  bash sync-skills.sh
set -e
cd "$(dirname "$0")"

SRC_REPO="https://github.com/AtlasCloudAI/atlas-cloud-skills"
DEST="plugins/atlas-cloud/skills"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
git clone --depth 1 "$SRC_REPO" "$TMP" 2>/dev/null

rename_name() {  # rewrite the frontmatter identifier in place
  sed -i '' "s/^name: .*/name: $2/" "$1/SKILL.md" 2>/dev/null || \
  sed -i "s/^name: .*/name: $2/" "$1/SKILL.md"
}

rm -rf "$DEST"; mkdir -p "$DEST"

# atlas-cloud -> media-generation: named after what it does, not the platform.
cp -R "$TMP/atlas-cloud" "$DEST/media-generation"
rename_name "$DEST/media-generation" "media-generation"
# Drop the vendor prefix so the description opens on the capability.
sed -i '' 's/^description: "Atlas Cloud API integration skill — quickly call/description: "Quickly call/' \
  "$DEST/media-generation/SKILL.md" 2>/dev/null || true

# seedance-2-5-skill -> seedance-skill: identifiers allow no dot, so "2.5"
# would render as "Seedance 2 5".
cp -R "$TMP/skills/seedance-2-5-skill" "$DEST/seedance-skill"
rename_name "$DEST/seedance-skill" "seedance-skill"

# Everything else keeps its name.
for dir in "$TMP"/skills/*/; do
  name=$(basename "$dir")
  [ "$name" = "seedance-2-5-skill" ] && continue
  cp -R "$dir" "$DEST/$name"
done

find "$DEST" -name ".DS_Store" -delete
echo "synced $(ls "$DEST" | wc -l | tr -d ' ') skills into $DEST"
