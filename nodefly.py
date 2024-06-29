import os

print(""" _________ 
/ \ 
| NodeFly | 
\ / 
_______/ 
-- by Adil
(https://x.com/adil_emmi)""")
os.system('sudo apt update -y && sudo apt upgrade -y && sudo apt install python3-pip -y')
os.system('command -v nvm >/dev/null 2>&1 || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash')
os.system('bash -c \"[ ! -d "$HOME/.nvm" ] && export NVM_DIR="$HOME/.nvm" && [ ! -s "$NVM_DIR/nvm.sh" ] && [ ! -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/nvm.sh" && . "$NVM_DIR/bash_completion\"')
os.system('bash')
print("Your SSH Deployment key is : ")
# GITHUB_REPO = input("Enter Github Repo: ")
os.system('cd ~ && [ ! -d Node-project ] && mkdir Node-project')

