S3_BUCKET_NAME=wladistanknotifier730
TF_BUCKET_NAME=wladistanknotifier730-state
REGION=us-west-2
if aws s3 ls "s3://$S3_BUCKET_NAME" 2>&1 | grep -q 'An error occurred'
then
    aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "bucket already exists"
fi

if aws s3 ls "s3://$TF_BUCKET_NAME" 2>&1 | grep -q 'An error occurred'
then
    aws s3api create-bucket --bucket $TF_BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "bucket already exists"
fi

cd ../../src/capstone-api/
./create_package.sh
cd -

aws s3 cp ../../src/zip/capstone-api.zip s3://wladistanknotifier730/capstone-api.zip

cd ../../src/lambda/
./create_package.sh
cd -
