#!/bin/bash 
sudo yum -y remove python36
sudo yum -y install python38
sudo update-alternatives --set python /usr/bin/python3.8
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
sudo pip install boto3

echo Please enter a valid IP address:
read ip_address
echo IP address:$ip_address
bucket=`aws s3api list-buckets --query "Buckets[].Name" | grep s3bucket | tr -d ',' | sed -e 's/"//g' | xargs`
echo export bucket=`aws s3api list-buckets --query "Buckets[].Name" | grep s3bucket | tr -d ',' | sed -e 's/"//g' | xargs` >> /home/ec2-user/.bashrc
echo export bucket_url="https://${bucket}.s3-us-west-2.amazonaws.com/index.html" >> /home/ec2-user/.bashrc
FILE_PATH="/home/ec2-user/environment/resources/website_security_policy.json"
FILE_PATH_2="/home/ec2-user/environment/resources/permissions.py"


aws s3 cp ./resources/website s3://$bucket/ --recursive --cache-control "max-age=0"

sed -i "s/<FMI_1>/$bucket/g" $FILE_PATH_2

sed -i "s/<FMI_1>/$bucket/g" $FILE_PATH
sed -i "s/<FMI_2>/$bucket/g" $FILE_PATH
sed -i "s/<FMI_3>/$ip_address/g" $FILE_PATH
sed -i "s/<FMI_4>/$bucket/g" $FILE_PATH

python /home/ec2-user/environment/resources/permissions.py