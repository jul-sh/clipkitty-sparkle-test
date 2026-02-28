#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"
EDDSA_SIGNATURE="$2"
FILE_LENGTH="$3"
MIN_AUTOUPDATE_VERSION="${4:-}"

# Build optional minimumAutoupdateVersion element
MIN_AUTOUPDATE_TAG=""
if [ -n "$MIN_AUTOUPDATE_VERSION" ]; then
  MIN_AUTOUPDATE_TAG=$'\n      <sparkle:minimumAutoupdateVersion>'"${MIN_AUTOUPDATE_VERSION}"'</sparkle:minimumAutoupdateVersion>'
fi

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>ClipKittyTest Updates</title>
    <link>https://jul-sh.github.io/clipkitty-sparkle-test/appcast.xml</link>
    <language>en</language>
    <item>
      <title>ClipKittyTest ${VERSION}</title>
      <sparkle:version>${VERSION}</sparkle:version>
      <sparkle:shortVersionString>${VERSION}</sparkle:shortVersionString>
      <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>${MIN_AUTOUPDATE_TAG}
      <enclosure url="https://github.com/jul-sh/clipkitty-sparkle-test/releases/download/v${VERSION}/ClipKittyTest.dmg"
                 type="application/octet-stream"
                 sparkle:edSignature="${EDDSA_SIGNATURE}"
                 length="${FILE_LENGTH}" />
    </item>
  </channel>
</rss>
EOF
