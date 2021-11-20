# bastion userdata
#!/bin/bash
yum -y update
yum install -y mysql
yum install -y git tmux
yum install -y ansible