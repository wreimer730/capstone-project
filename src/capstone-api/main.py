# this code will take all data from dynamodb
import boto3
from fastapi import FastAPI

capstone = FastAPI()

session = boto3.Session()
credentials = session.get_credentials()

client = boto3.client('dynamodb',
    aws_access_key_id=credentials.access_key,
    aws_secret_access_key=credentials.secret_key,
    region_name='us-west-2')

dynamodb = boto3.resource('dynamodb', region_name="us-west-2")
table = dynamodb.Table('capstoneDB')

@capstone.get("/stations") 
async def places():
    response = table.scan()
    list = response['Items']
    return list

@capstone.get("/stations/{place}")
async def getplace(place):
    response = table.scan()
    list = response['Items']
    mylist = []
    for keyvalue in list:
        if keyvalue["place"] == place:
            mylist.append(keyvalue)
    return mylist