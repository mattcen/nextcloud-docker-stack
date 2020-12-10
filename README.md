# Docker Nextcloud setup

This stack will configure the following containers:

* db: postgres database for nextcloud
* web: nginx proxy for nextcloud
* app: nextcloud via PHP FPM
* storage: minio object storage

To get up and running:

```
# Generate some secrets to use
for f in minio_access_key.txt minio_secret_key.txt nextcloud_admin_password.txt postgres_password.txt; do
  tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 > secrets/"$f"
done
docker-compose up
```

Browse to http://localhost:8000, log in with the credentials stored in `secrets/nextcloud_admin_user.txt` and `secrets/nextcloud_admin_password.txt`, and you're good to go!
