import json
import boto3
import requests
from decimal import Decimal

mybucket = "testbucket-wladmir-reimer-202211121456"
url = "https://creativecommons.tankerkoenig.de/json/list.php?lat=53.482549290794765&sort=dist&lng=10.148804885001583&rad=10&type=all&apikey=541d5d5f-65dd-deea-5adf-e7388100a4b2"
dynamodb = "CapstoneDB"

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

def upload_data(jsondata, bucket_name):
    s3 = boto3.client('s3')
    for job in jsondata["stations"]:
        s3.put_object(Body=json.dumps(job), Bucket=bucket_name, Key=job["slug"]+ ".json")

def empty_bucket(bucket_name):
    bucket = boto3.resource('s3').Bucket(bucket_name)
    bucket.objects.all().delete()

def lambda_handler(event, context): 
    ### main section
    #empty_bucket(mybucket)
    #upload_data(get_data(url),mybucket)
    put_dynamodb_data(get_data(url), dynamodb)
