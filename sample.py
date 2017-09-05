def lambda_handler(event, context):
    return hello()

def hello():
    return 'Hello from Lambda'
