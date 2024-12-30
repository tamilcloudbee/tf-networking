# AWS Networking

### Create a 3 VP's in ( us-east-1 ) region
#### Each VPC contains
     ## 1 Private and 1 public subnet
     a# main public route table and associated InternetGateway 
        - Public sublic is associated with main route table of VPC
        - Private subnet has its own route table and it is isolated from outside world.
    

#### TransitGateway.

     ## There is One Transit Gateway created in <b> us-east-1 </b> region