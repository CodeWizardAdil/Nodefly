import os

print(""" _________ 
/ \ 
| NodeFly | 
\ / 
_______/ 
-- by Adil
(https://x.com/adil_emmi)""")
os.system('sudo apt update -y && sudo apt upgrade -y && sudo apt install python3-pip -y')
print("Your SSH Deployment key is : ")
GITHUB_REPO = input("Enter Github Repo: ")

os.system('cd ~ && mkdir Node-project')

os.system('cd ~/Node-project && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash')