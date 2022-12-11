import boto3
from fastapi import FastAPI

capstone = FastAPI()

client = boto3.client('dynamodb',
  aws_access_key_id='ASIAUKNDBQNGML5AZRWU',
  aws_secret_access_key='V/Qp3YHwEomknVDrgM0BkX0vm/FkAhZFPkWndt8l',
  region_name='us-west-2')

dynamodb = boto3.resource('dynamodb', region_name="us-west-2")
table = dynamodb.Table('capstoneDB')
response = table.scan()

list = response['Items']

@capstone.get("/stations")
async def jobs():
    return list

@capstone.get("/station/{item}")
async def getjob(item):
    mylist = []
    for keyvalue in list:
        if keyvalue["place"] == item:
            mylist.append(keyvalue)
    return mylist