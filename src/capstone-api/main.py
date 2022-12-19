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

response = table.scan()
list = response['Items']

@capstone.get("/stations") 
async def places():
    return list

@capstone.get("/station/{place}")
async def getplace(place):
    mylist = []
    for keyvalue in list:
        if keyvalue["place"] == place:
            mylist.append(keyvalue)
    return mylist