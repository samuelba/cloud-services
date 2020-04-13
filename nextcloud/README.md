# Nextcloud

## After Setup

You probably need to fix some tables.

```
docker exec --user www-data nextcloud php occ db:add-missing-indices
docker exec --user www-data nextcloud php occ db:convert-filecache-bigint
```
