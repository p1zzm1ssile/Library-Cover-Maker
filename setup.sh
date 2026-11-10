#!/bin/sh
# Runs when the container starts, after nginx has filled in its settings file.
CONF=/etc/nginx/conf.d/default.conf

# Also listen on IPv6, but only when this host has it: nginx won't start at all if asked to
# listen on an IPv6 address the host doesn't have.
if [ -f /proc/net/if_inet6 ]; then
    sed -i 's/^\(\s*\)listen 8097;$/\1listen 8097;\n\1listen [::]:8097;/' "$CONF"
else
    echo "Library Cover Maker: no IPv6 on this host, so listening on IPv4 only"
fi

# Optional sign-in: with AUTH_USER and AUTH_PASSWORD set, the page and everything it uses ask
# for that username and password. Without them the page is open to anyone who can reach it.
if [ -n "$AUTH_USER" ] && [ -n "$AUTH_PASSWORD" ]; then
    hash=$(printf '%s' "$AUTH_PASSWORD" | mkpasswd -m sha512 -P 0)
    printf '%s:%s\n' "$AUTH_USER" "$hash" > /etc/nginx/lcm.htpasswd
    chmod 644 /etc/nginx/lcm.htpasswd
    printf 'auth_basic "Library Cover Maker";\nauth_basic_user_file /etc/nginx/lcm.htpasswd;\n' > /etc/nginx/lcm-auth.conf
    echo "Library Cover Maker: sign-in is on for $AUTH_USER"
else
    : > /etc/nginx/lcm-auth.conf
    [ -n "$AUTH_USER$AUTH_PASSWORD" ] && echo "Library Cover Maker: set both AUTH_USER and AUTH_PASSWORD to turn sign-in on; it's off for now"
fi
exit 0
