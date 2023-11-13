Run Odoo - Open source ERP and CRM on Diploi

Template runs Odoo version 16 plus a PostgreSQL 14.1 database.

- 💻 [Odoo](https://www.odoo.com/)
- 💿 [PostgreSQL](https://www.postgresql.org)

## Odoo

Based on Odoo version 16 docker with minor Diploi customizations.

Login to Odoo with user `admin`. An initial password is generated for every project. To find password, open Diploi project and check project options.

For the Odoo container there are separate ssh logins for users `odoo` and `root`. For security reasons there is no `sudo` from odoo to root. However 
it is possible to restart odoo using command `supervistoctl restart odoo`

Custom modules are linked to git repository, hosted at `/mnt/extra-addons`. This folder is persisted 
in the development version and non-persisted for staging and development.

Data folder `/var/lib/odoo` is persisted always


## PostgreSQL

Available eg. with a VSCode extension ([SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)) or by CLI.

### Connect via SQLTools

1. Open VSCode remote connection to your deployment.
2. Install the [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools) and [SQLTools PostgreSQL/Redshift Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg) extensions.
3. Open the "SQLTools" tab in the sidebar and click "Strapi".

### Connect via CLI

```bash
su postgres -c 'psql'
```
