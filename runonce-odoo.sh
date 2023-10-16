#!/bin/sh

progress() {
  current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local action="$1"
  echo "🟩 $current_date $action"
}

# Perform tasks ths should run as odoo user at pod startup
progress "Runonce started";

cd /mnt/extra-addons;

# Seems that this is first run in devel instance
# Intialize persistant storage
if [ ! "$(ls -A /mnt/extra-addons)" ]; then

  progress "Pulling code";

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

fi

# Wait for database and initialize odoo and set admin password on first run 
progress "Initializing Odoo";
python3 /odoo-init.py;

progress "Runonce done";

exit 0;
