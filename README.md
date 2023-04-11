# Odoo template

A template for running Odoo on Dipoi

Features full PostgreSQL etc. etc.

- 💻 [Next.js](https://nextjs.org)
- 💿 [PostgreSQL](https://www.postgresql.org)

## Odoo

Available at `/`.

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
