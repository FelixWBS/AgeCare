import os
import boto3
from dotenv import load_dotenv

load_dotenv()

brt = boto3.client(
    service_name="bedrock-runtime",
    region_name="eu-central-1",
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
)

def call_bedrock(model_id, messages, max_tokens=512):
    return brt.converse(
        modelId=model_id,
        messages=messages,
        inferenceConfig={
            "maxTokens": max_tokens,
            "temperature": 0.2,
            "topP": 0.9
        },
    )
