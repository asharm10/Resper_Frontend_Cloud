curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&
source ~/.nvm/nvm.sh &&
nvm install --lts &&

# Clone the repo form github on the EC2 instance
mkdir resper_frontend && cd resper_frontend &&
git clone https://github.com/asharm10/Front-End-With-Veutify.git &&
cd Front-End-With-Veutify && 

npm install && screen -d -m npm run build && sleep 10