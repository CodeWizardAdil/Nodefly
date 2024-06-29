import os

print(""" _________ 
/ \ 
| NodeFly | 
\ / 
_______/ 
-- by Adil
(https://x.com/adil_emmi)""")
os.system('sudo apt update -y && sudo apt install python3-pip')
print("Your SSH Deployment key is : ")
GITHUB_REPO = input("Enter Github Repo: ")

os.system('cd ~ && mkdir Node-project')