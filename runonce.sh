#!/bin/sh

# Perform tasks at controller pod startup
echo "Runonce started";

# Update internal ca certificate
update-ca-certificates

# Make all special env variables available in ssh also (ssh will wipe out env by default)
env >> /etc/environment

# Home seems empty, probably running development version first time, initialize it
if [ ! "$(ls -A /home/odoo)" ]; then
  tar xvf /root/initial-odoo-home.tar -C /home/odoo --strip-components 2;
fi

# Insert accepted ssh key(s)
cat /etc/ssh/internal_ssh_host_rsa.pub >> /root/.ssh/authorized_keys;
cat /etc/ssh/internal_ssh_host_rsa.pub >> /home/odoo/.ssh/authorized_keys;
chown odoo:odoo /home/odoo/.ssh/authorized_keys;

# Initialize symlink to /etc/odoo so config will outlive pod
if [ ! -d "/var/lib/odoo/etc-odoo" ]; then
  echo "Initializing persistent data folders";
  mv /etc/odoo /var/lib/odoo/etc-odoo;
  ln -s /var/lib/odoo/etc-odoo /etc/odoo;
  ls -la /etc/ | grep odoo
  sed 's/^\s*; admin_passwd = admin\s*$/admin_passwd = '$INITIAL_ADMIN_PASSWORD'/' "/etc/odoo/odoo.conf" > /etc/odoo/odoo-modified.conf;
  rm /etc/odoo/odoo.conf;
  mv /etc/odoo/odoo-modified.conf /etc/odoo/odoo.conf;
  chown odoo:odoo /etc/odoo/odoo.conf /var/lib/odoo/etc-odoo
  cat /etc/odoo/odoo.conf | grep "passwd";

  # Configure VSCode
  mkdir -p /root/.local/share/code-server/User
  cp /usr/local/etc/diploi-vscode-settings.json /root/.local/share/code-server/User/settings.json

fi

touch /var/log/git-credential-helper.log
chown odoo:odoo /var/log/git-credential-helper.log

# Run tasks that should be done as odoo user
su -s /home/odoo/runonce-odoo.sh -g odoo odoo

# Now that everything is initialized, start all services
echo "Start odoo";
supervisorctl start odoo
supervisorctl start status
supervisorctl start code-server

echo "Runonce done";

exit 0;
