#!/bin/bash
# Mutes bad ssh handling by disabling strict host checking

# CPR : Jd Daniel :: Ehime-ken
# MOD : 2016-01-27 @ 19:28:27
# REF : https://goo.gl/a5ZUqx
# VER : Version 1.0.1-dev

touch /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config

cat << 'EOF' >> /home/vagrant/.ssh/config

  StrictHostKeyChecking no

EOF

exit 0
