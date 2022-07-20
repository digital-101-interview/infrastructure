import os
def lambda_handler(event, context):
    
    #1 - Log the event
    print('*********** The event is: ***************')
    print(event)
    region = os.environ['REGION']
    account_id = os.environ['ACCOUNT_ID']
    api_id = os.environ['API_ID']
    token = os.environ['TOKEN']
    #2 - See if the person's token is valid
    if event['authorizationToken'] == token:
        auth = 'Allow'
    else:
        auth = 'Deny'
    
    #3 - Construct and return the response
    authResponse = { "principalId": token, "policyDocument": { "Version": "2012-10-17", "Statement": [{"Action": "execute-api:Invoke", "Resource": [f"arn:aws:execute-api:{region}:{account_id}:{api_id}/*/*"], "Effect": auth}] }}
    return authResponse
