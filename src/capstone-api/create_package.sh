#!/bin/bash

mkdir -p package
pip install --target ./package requests
cd package
zip -r ../capstone-api.zip .
cd ..
zip capstone-api.zip main.py
mv capstone-api.zip ../zip
rm -rf package