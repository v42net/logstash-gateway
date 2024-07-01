#!/bin/bash
set -e

mkdir -p /data/log/backend /data/log/frontend /data/log/kafka
chown nobody:nogroup /data/log /data/log/backend /data/log/frontend /data/log/kafka
chmod 02755 /data/log /data/log/backend /data/log/frontend /data/log/kafka

if [ -d /data/cfg ]; then
    rm -rf /data/cfg
fi
export HOME=/root
echo '#!/bin/bash'>~/.git_askpass
echo 'echo GITHUB_CONFIG_KEY'>>~/.git_askpass
chmod 0700 ~/.git_askpass
export GIT_ASKPASS=~/.git_askpass
echo 'Cloning from GITHUB_CONFIG_URL'
git clone GITHUB_CONFIG_URL /data/cfg
unset GIT_ASKPASS
rm -f ~/.git_askpass
