awsIoTAppDashBoard

Before you run add your own identity pool ID in AppDelegate let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,identityPoolId:"use your identityPoolID")

Important notice: For trivial data in the project -> location and node list(too less data to fetch so I have hardcoded). Can be easily updated when we need to scale.

Make sure the AWS backend is all set up. Some key pointers:

Use AWS Cognito to assign roles and add DynamoDBReadOnly policy to the role.
Make sure the role is (unauthenticated role)
Make sure the following schema is re-created:
Tables -> Energy, NaturalGas,Water,WasteWater

For each table, use the following hashkey and rangekey configurations:

hashkey - NodeID
hashkey - CreatedAt
