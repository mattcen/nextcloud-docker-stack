#!/bin/bash

bucket=nextcloud
key=$(cat secrets/minio_access_key.txt)
secret=$(cat secrets/minio_secret_key.txt)
hostname=storage
port=9000

docker-compose exec -T -u 33 app ./occ config:import <<EOF
{
    "system": {
        "objectstore": {
            "class": "\\\\OC\\\\Files\\\\ObjectStore\\\\S3",
            "arguments": {
                "bucket": "$bucket",
                "autocreate": true,
                "key": "$key",
                "secret": "$secret",
                "hostname": "$hostname",
                "port": $port,
                "use_ssl": false,
                "use_path_style": true,
                "legacy_auth": true
            }
        }
    }
}
EOF
