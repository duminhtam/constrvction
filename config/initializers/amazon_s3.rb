s3_credentials = YAML.load(File.open(Rails.root.join('config', 's3.yml')).read)
S3_ACCESS_KEY_ID = s3_credentials['access_key_id']
S3_SECRET_ACCESS_KEY = s3_credentials['secret_access_key']