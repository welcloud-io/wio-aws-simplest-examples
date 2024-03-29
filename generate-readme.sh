#!/bin/bash
region='eu-west-1'
bucketname='welcloud.io.aws-simplest-examples'

readmefile='readme.md'
cat << EOF > $readmefile
### Ready to use Cloudformation templates
###### !! These templates may incur (small) costs. Delete them when you are done !!
###### !! They are built for AWS (Amazon Web Services) and for learning/test purpose !!
###### !! You should test them in a sandbox or dev account (NOT in a production Account) !!
---
##### For simplicity we assume :
##### - You are currently logged-in an AWS account with an IAM ADMIN user or role 
##### - Your AWS account is a SANDBOX or a DEV account
##### - You are working in AWS Ireland Region (eu-west-1)
##### - You still have your "Default VPC" Network into your AWS Account
---
| Simplest Example | Stack | Template | Diagram |
| --- | --- | --- | --- |
EOF

for folder in $(ls ./cloudformation-templates); do
  for templatename in $(ls ./cloudformation-templates/$folder); do
    stackname=$(echo $templatename |cut -d. -f1)
    templatepath="cloudformation-templates/$folder/$templatename"
    
    # Create stack creation link
    cloudformationurl="https://$region.console.aws.amazon.com/cloudformation/home?region=$region#/stacks/create/review"
    templateurl="https://s3.$region.amazonaws.com/$bucketname/$templatepath"
    stackreviewurl="$cloudformationurl?templateURL=$templateurl&stackName=$stackname"
    stackreviewlink="<a href='$stackreviewurl' target='_blank'>$stackname</a>"

    # Create stack creation link
    templatecreatelink="<a href='$stackreviewurl' target='_blank'>DEPLOY</a>"
   
    # Create stack creation link
    templatedownloadlink="[open]($templateurl)"
    
    # Create architecture diagram link
    architecturediagrampath="architecture-diagrams/$folder/$stackname.png"
    architecturediagramurl="https://s3.$region.amazonaws.com/$bucketname/$architecturediagrampath"
    if [ -f $architecturediagrampath ]; then
      architecturediagramlink="[view]($architecturediagramurl)"
    else
      architecturediagramlink="-"
    fi
   
    # Add links to readme file 
    echo "| $stackreviewlink | $templatecreatelink | $templatedownloadlink | $architecturediagramlink |" >> $readmefile
  done
done
