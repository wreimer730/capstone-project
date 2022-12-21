import json
from decimal import Decimal

import boto3
import requests

apikey = "541d5d5f-65dd-deea-5adf-e7388100a4b2"
lat = "52.516327657577186"
lng = "13.377902885138017"
rad = "25"
type = "all"
url = "https://creativecommons.tankerkoenig.de/json/list.php?lat={0}&lng={1}&rad={2}&type={3}&apikey={4}".format(lat,lng,rad,type,apikey)

dynamodb = "capstoneDB"

def put_dynamodb_data(jsondata, dynamodb):
    #API expect data in dictionary format
    database = boto3.resource('dynamodb')
    table = database.Table(dynamodb)
    for job in jsondata["stations"]:
        data = json.loads(json.dumps(job), parse_float=Decimal)
        table.put_item(Item = data)

def get_data(url):
    response = requests.get(url)
    job_data = response.json()
    return job_data

#TODO: implement get data from postal code dynamodb table
# def get_all_data():
#     # get all dynamodb postal code data - json
#     database = boto3.resource('dynamodb')
#     table = database.Table(dynamodb)
#     # create jsondatalist
#     jsondatalist = []
#     # iterate json, get every city and get lat, lng
#         # pick every lng, lat for every city
#         # create temp_url
#         get_data(temp_url)
#         # create jsondata and attach to global jsondatalist
#     # return global jsondatalist

def lambda_handler(event, context): 
    put_dynamodb_data(get_data(url), dynamodb)
