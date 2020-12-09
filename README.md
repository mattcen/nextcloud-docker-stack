# Docker Nextcloud setup

This stack will configure the following containers:

* db: postgres database for nextcloud
* web: nginx proxy for nextcloud
* app: nextcloud via PHP FPM
* storage: minio object storage

The intent is that you will be able to store all your Nextcloud files in an S3-compatible object store, but I've not yet completed the automated config for this, so there's some manual work to get it working.

To get up and running:

```
# Generate some secrets to use
for f in minio_access_key.txt minio_secret_key.txt nextcloud_admin_password.txt postgres_password.txt; do
  tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 > secrets/"$f"
done
docker-compose up -d
# Wait for the server to be up and running. Check this with `docker-compose logs app | grep installed`
# Once the server is up and running, run this to point it at the object store
./nextcloud-s3-config.sh
