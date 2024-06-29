import os
import paramiko
print(""" _________ 
/ \ 
| NodeFly | 
\ / 
_______/ 
-- by Adil (https://x.com/adil_emmi)""")

print("Your SSH Deployment key is : ")
GITHUB_REPO = input("Enter Github Repo: ")

os.system('cd ~ && mkdir Node-project')