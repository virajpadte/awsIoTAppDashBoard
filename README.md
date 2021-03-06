
<h1 align="center">awsIoTAppDashBoard</h1>
<img src="https://user-images.githubusercontent.com/3850481/27263943-15bfe5f8-5432-11e7-9dd3-2e0d0d6b596b.png">


Before you run add your own identity pool ID in AppDelegate let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,identityPoolId:"use your identityPoolID")

Important notice: For trivial data in the project -> location and node list(too less data to fetch so I have hardcoded). Can be easily updated when we need to scale.

Make sure the AWS backend is all set up. Some key pointers:

Use AWS Cognito to assign roles and add DynamoDBReadOnly policy to the role.
Make sure the role is (unauthenticated role).</br>
Make sure the following schema is re-created:


Tables -> Energy, NaturalGas,Water,WasteWater

For each table, use the following hashkey and rangekey configurations:</br>
hashkey - NodeID
hashkey - CreatedAt

Sample element structure for the above mentioned tables:
```
{
  "Cost": "524.37",
  "CreatedAt": "2005-01-01",
  "DataID": "145",
  "NodeID": "node1",
  "Place": "117 N Mason St",
  "Reading": "26.4"
}
```

Update[04/21/2017] - Added a new table (NodeRegistration) to retrive the locations an GPS coordinates of the sensing nodes 
For this table - hashkey - Place
Sample element structure - 
```
{
  "Coordinates": "40.590101,-105.081280",
  "Nodes": [
    "node13",
    "node14",
    "node15",
    "node16"
  ],
  "Place": "300 LaPorte Ave"
 }
```
Notice: This repo is a part of a bigger project which also involves an python MQTT IoT client created. 

Need access to the python MQTT client source code?
https://github.com/virajpadte/AWSIoTPythonNode

Need the assets used for designing this app's UI:
Good news! I have used sketch for designing the UI and here a repo link for the sketch project:
https://github.com/virajpadte/AWSIoTDashboard-App-mockup

If you are interested in knowing more about the entire project archicture, visit this link:</br>
page is under-construction


