#!/bin/bash

mkdir -p package
pip install --target ./package requests
cd package
zip -r ../capstone-lambda.zip .
cd ..
zip capstone-lambda.zip lambda_function.py
mv capstone-lambda.zip ../src
rm -rf package