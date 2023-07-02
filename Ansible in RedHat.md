## Ansible Configuration on RedHat
-----------------------------------

>### Update RHEL 8
* To install Ansible, first log in to your system and update the system packages using the command:
```
sudo dnf update -y
```

>### Install Python3 on RHEL 8 
```
sudo dnf install python3 -y
```

>### Install Ansible
```
subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms
sudo dnf install ansible -y
```

* First, Create a user **_devops_** on both Ansible control node & on the node/nodes
```
sudo adduser devops
```

* Enter the password also **_devops_** and hit enter multiple times

* Now, we need to add devops user to sudoers group
```
sudo visudo
```

* Add the following `devops  ALL=(ALL) NOPASSWD: ALL` under '## Same thing without a password' line which is 3rd line from the bottom. 

* Next, open `/etc/ssh/sshd_config` and search for '# To disable tunneled clear text passwords, change to no here!' 
  (remove comment from 'PasswordAuthentication yes' & add comment before 'PasswordAuthentication no' )
```
sudo vi /etc/ssh/sshd_config
```

* Restart sshd
```
sudo service sshd restart
```

* Ansible control node needs to have the information about the nodes which are attempting to connect. This information is referred to as inventory (hosts) file
```
ansible --inventory ./hosts --ask-pass --module-name ping all
```
or
```
ansible -i ./hosts -k -m ping all
```

* Since we got an error, so let's solve the error first
* To add the known-host entry lets manually login from ansible control node to node/nodes using ssh command
```
ssh devops@172.31.25.217
```

* Right now we are entering the password manually when connecting to the nodes which is not good for automation, So lets create a secure approach, 
  which enables password less authentication with security
* Now on the ansible control node, we will create a key pair
```
ssh-keygen
```

* Next, copy the key from ansible control node to node1 so that we can use key based authentication
```syntax
ssh-copy-id username@<destination-node-ip>
```

* In our case,
```
ssh-copy-id devops@172.31.25.217
```

* Since, we are working with automation, we need to have passwordless authentication 
* Hence, we should be able to login from Ansible control Node (ACN) to any other node/nodes in the same network without password with security 
* So, execute the following command from ACN
```
ssh 172.31.25.217
```

* Now lets exit and retry the command without password option
```
ansible --inventory ./hosts --module-name ping all
```
or
```
ansible -i ./hosts -m ping all
```

* Now lets add localhost to the inventory file and run the ansible ping command
```
ansible -i ./hosts -m ping all
```

* It fails on localhost as the key is not copied, so copy the key using `ssh-copy-id`
```
ssh-copy-id devops@localhost
```

* Now, try again ping
```
ansible -i ./hosts -m ping all
```

* To search a specific information, ansible uses a module called as 'setup' which can collect information about the Node/Nodes.
* [Gathers facts about remote hosts](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html)
* Also, [Discovering variables: facts and magic variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html)
```
ansible -i ./hosts -m setup all
``` 
* For instance, I'm searching for the os Family in the Node,
```
ansible -m setup -a "filter=*os*" -i ./hosts all
```

* Or, I'm looking for Node's distribution.
```
ansible -m setup -a "filter=*distribution*" -i ./hosts all
```


