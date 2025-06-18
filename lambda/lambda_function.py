import json

def lambda_handler(event, context):
    print("S3 Event Triggered:")
    print(json.dumps(event))
    return {
        'statusCode': 200,
        'body': json.dumps('DevOps Group1 S3 trigger processed successfully!')
    }
