#!/bin/bash

exec > >(tee ~ubuntu/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&
source ~/.nvm/nvm.sh &&
nvm install 17.3.0 &&

# Clone the repo form github on the EC2 instance
mkdir resper_frontend && cd resper_frontend &&
git clone https://github.com/asharm10/Resper_Frontend_Cloud.git &&
cd Resper_Frontend_Cloud && 

npm install && npm run serve