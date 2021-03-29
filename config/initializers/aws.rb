
Aws.config.update({
   credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id], Rails.application.credentials.aws[:secret_access_key]),
   region: 'eu-west-3',
})

$S3_CLIENT = Aws::S3::Client.new
$BUCKET_NAME = 'greeneye'
$BUCKET_URL = 'https://greeneye.s3.eu-west-3.amazonaws.com/'
