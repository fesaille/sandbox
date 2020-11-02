# DVC

## Init a repository and display status

As with git:

```bash
# Remove stats usage
dvc config --global core.analytics false

# Init DVC
dvc init

# Print DVC status
dvc status
```

## Storage

A S3 sandbox can be generated with:
```bash
# Generate id and secret access key
aws_access_key_id=dvc_user
aws_secret_access_key=$(openssl rand --hex 64)

# Configure the credentials
# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
[ ! -d ~/.aws ] && mkdir ~/.aws && touch ~/.aws/credentials
cat << EOF >> ~/.aws/credentials
[dvc]
aws_access_key_id=${aws_access_key_id}
ws_secret_access_key=${aws_secret_access_key}
EOF

# Launch a MinIO container on docker
docker run --rm -d -p 9000:9000 \
   -e "MINIO_ACCESS_KEY=${aws_access_key_id}" \
   -e "MINIO_SECRET_KEY=${aws_secret_access_key}" \
    minio/minio server /data

# Configure the minio client
bash -c "
  echo -e \"${aws_access_key_id}\\n${aws_secret_access_key}\" | \
      mc config host add dvc http://localhost:9000 \
      --api \"S3v4\"
"
```

Add a remote storage with `dvc remote add` and modify attributes with `dvc remote modify`.

```bash
dvc remote add -fd minio s3://dvc
# Add previously configured aws profile *dvc*
dvc remote modify minio profile dvc
dvc remote modify minio endpoint url http://localhost:9000
```

## DVC files

Placeholders <badge-doc href="https://dvc.org/doc/user-guide/dvc-files-and-directories"></badge-doc> to track data files and directories, are added when using data related commands: `dvc add`, `dvc import`, or `dvc import-url`

| Fields | Mandatory | Decription                                                                                       |
|--------|:---------:|--------------------------------------------------------------------------------------------------|
| `outs` |     ✓     | List of output entries (details below) that represent the files or directories tracked with DVC. |
