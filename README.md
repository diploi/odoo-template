Run Odoo 16 - Open source ERP and CRM on Diploi

Includes an internal PostgreSQL database.

- 💻 [Odoo](https://www.odoo.com/)
- 💿 [PostgreSQL](https://www.postgresql.org)

## Odoo

Odoo version 16 docker file plus diploi customizations.

Login to Odoo with user `admin`, an initial password is generated for every project. In Diploi, see project options.

There separate ssh logins for users `odoo` and `root`.

Custom modules are linked to git repository, hosted at `/mnt/extra-addons`. This folder is persisted 
in the development version and non-persisted for staging and development.

Data folder `/var/lib/odoo` is persisted always


## PostgreSQL

Available with a VSCode extension ([SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)) or by CLI.

### Connect via SQLTools

1. Open VSCode remote connection to your deployment.
2. Install the [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools) and [SQLTools PostgreSQL/Redshift Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg) extensions.
3. Open the "SQLTools" tab in the sidebar and click "Strapi".

### Connect via CLI

```bash
su postgres -c 'psql'
```
