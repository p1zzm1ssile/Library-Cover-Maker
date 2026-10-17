#!/bin/sh
# nginx writes to /data as its own user, so let it into the folder mapped there.
# Only the folder itself is changed; nothing inside it is touched.
mkdir -p /data/.uploads
chmod a+rwx /data /data/.uploads 2>/dev/null || echo "Library Cover Maker: /data isn't writable, so Put back and making them all at once are off"
