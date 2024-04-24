#!/bin/bash
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh
# sudo usermod -a G docker ubuntu
# sudo usermod -a G docker ec2-user

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&
source ~/.nvm/nvm.sh &&
nvm install --lts &&

# Clone the repo form github on the EC2 instance
mkdir resper && cd resper &&
git clone https://github.com/rijalaasish0/resper-backend-mongo.git &&
cd resper-backend-mongo && 
# docker build -t resper-backend-mongo . &&
# docker run -p 5000:5000 -d resper-backend-mongo
npm install && screen -d -m npm start && sleep 10