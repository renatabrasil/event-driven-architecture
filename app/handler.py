import re
import boto3
print('Loading function')


def lambda_handler(event, context):
    client = boto3.client('logs')

    log_group_name = '/aws/lambda/hello-world-lambda-dev-hello'
    log_stream_name = '2024/07/03/[$LATEST]7a18dcc2643f4b3b826c0354a0232d26'

    print("oi")

    response = client.get_log_events(logGroupName=log_group_name, logStreamName=log_stream_name, startFromHead=True)

    events = response['events']

    print(events)

    request_pattern = re.compile(r'\"request\":\"(.*?)\"')

    for event in events:
        message = event['message']

        request_match = request_pattern.search(message)

        if request_match:
            print(f"Request: {request_match.group(1)}")


    #raise Exception('Something went wrong')
