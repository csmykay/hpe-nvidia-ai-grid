#!/bin/bash
# getfavicon.sh — fetch favicon from hpe.com (macOS compatible)

TARGET_URL="https://www.hpe.com/us/en/home.html"
BASE_URL="https://www.hpe.com"
OUT_DIR="."

echo "Fetching page..."

HTML=$(curl -sL \
  -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" \
  "$TARGET_URL")

# Extract href from <link rel="icon"> or <link rel="shortcut icon"> — BSD grep compatible
FAVICON_PATH=$(echo "$HTML" \
  | grep -i 'rel=.*icon' \
  | grep -i 'href=' \
  | sed 's/.*href=["'"'"']\([^"'"'"' >]*\).*/\1/' \
  | head -1)

# Fallback: apple-touch-icon (usually higher resolution)
if [ -z "$FAVICON_PATH" ]; then
  FAVICON_PATH=$(echo "$HTML" \
    | grep -i 'apple-touch-icon' \
    | sed 's/.*href=["'"'"']\([^"'"'"' >]*\).*/\1/' \
    | head -1)
fi

# Last resort: standard /favicon.ico path
if [ -z "$FAVICON_PATH" ]; then
  echo "No <link> tag found, trying /favicon.ico directly..."
  FAVICON_PATH="/favicon.ico"
fi

# Build absolute URL if path is relative
if [[ "$FAVICON_PATH" == http* ]]; then
  FAVICON_URL="$FAVICON_PATH"
else
  FAVICON_URL="${BASE_URL}${FAVICON_PATH}"
fi

echo "Downloading: $FAVICON_URL"

# Determine file extension
EXT="${FAVICON_URL##*.}"
case "$EXT" in
  ico|png|svg|webp) ;;
  *) EXT="ico" ;;
esac
OUTFILE="${OUT_DIR}/favicon.${EXT}"

curl -sL \
  -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  "$FAVICON_URL" -o "$OUTFILE"

echo "Saved → $OUTFILE ($(wc -c < "$OUTFILE" | tr -d ' ') bytes)"
echo ""
echo "Add to your index.html <head>:"
echo "  <link rel=\"icon\" type=\"image/${EXT}\" href=\"favicon.${EXT}\">"