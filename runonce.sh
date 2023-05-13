#!/bin/sh

# Perform tasks at controller pod startup
echo "Runonce started";

# Insert accepted ssh key(s)
cat /etc/ssh/internal_ssh_host_rsa.pub >> /root/.ssh/authorized_keys;
cat /etc/ssh/internal_ssh_host_rsa.pub >> /home/odoo/.ssh/authorized_keys;

cd /mnt/extra-addons;

# Initialize symlink to /etc/config so config will outlive pod
if [ ! -d "/data/var-lib-odoo" ]; then
    echo "Initializing persistent data folder symlinks";
    mkdir /var/lib/odoo/diploi-etc-config;
    chown odoo:odoo /var/lib/odoo/diploi-etc-config;
    rm -rf /etc/config;
    ln -s /var/lib/odoo/diploi-etc-config /etc/config;
fi

# Seems that this is first run in devel instance
# Intialize persistant storage
if [ ! "$(ls -A /mnt/extra-addons)" ]; then

  echo "Empty /mnt/extra-addons, assuming development instance setup was intended"
  mkdir -p /root-persist/.vscode-server;
  touch /root-persist/.bash_history;
  touch /root-persist/.gitconfig;

  git init;
  git config credential.helper '!diploi-credential-helper';
  git remote add --fetch origin $REPOSITORY_URL;
  git checkout -f $REPOSITORY_BRANCH;
  git remote set-url origin "$REPOSITORY_URL";
  git config --unset credential.helper;
  
  # Configure the SQLTools VSCode extension
  # TODO: How to update these if env changes?
  cat > /mnt/extra-addons/.vscode/settings.json << EOL
{
  "sqltools.connections": [
    {
      "previewLimit": 50,
      "server": "$POSTGRES_HOST",
      "port": $POSTGRES_PORT,
      "driver": "PostgreSQL",
      "name": "PostgreSQL",
      "database": "$POSTGRES_DB",
      "username": "$POSTGRES_USER",
      "password": "$POSTGRES_PASSWORD",
    }
  ]
}
EOL

  #npm install;

fi

# Update internal ca certificate
update-ca-certificates

# Make all special env variables available in ssh also (ssh will wipe out env by default)
env >> /etc/environment

# Now that everything is initialized, start all services
supervisorctl start odoo

echo "Runonce done";

exit 0;
