#!/bin/bash

# This script should be running on the ec2 instance
cd /home/ec2-user
aws s3 cp s3://wladistanknotifier730/capstone-api.zip capstone-api.zip 
unzip capstone-api.zip

pip3 install boto3 uvicorn fastapi

/usr/local/bin/uvicorn main:capstone --host 0.0.0.0 --port 8000
