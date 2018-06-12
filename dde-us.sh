#!/bin/bash

# Make sure script run with sudo privileges
echo "$(whoami)"

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install SSM agent

#mkdir /tmp/ssm
#cd /tmp/ssm
#yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#status amazon-ssm-agent
#cd

# Add QRadar ip in rsyslog
echo "*.*     @182.95.255.8" >> /etc/rsyslog.conf
service rsyslog restart

# Install Tenable/Nessus

wget https://s3.ap-south-1.amazonaws.com/tenable-bucket/NessusAgent-7.0.3-amzn.x86_64.rpm
rpm -ivh NessusAgent-7.0.3-amzn.x86_64.rpm
/opt/nessus_agent/sbin/nessuscli agent link --key=9d4777f71733214d2a35566bd5f4bee3fda2b19462083c5f692dc86a2306d771 --host=cloud.tenable.com --port=443 --groups="ThirdPillar_AWS" --name="AWSCLI"

# Start nessus agent
/opt/nessus_agent/sbin/nessuscli agent start


# Install TM-DSM agent for US region
# This will detects platform and architecture, then downloads and installs the matching Deep Security Agent package
if type curl >/dev/null 2>&1; then
  SOURCEURL='https://dsm.genpact.com:443'
  curl $SOURCEURL/software/deploymentscript/platform/linux/ -o /tmp/DownloadInstallAgentPackage --insecure --silent --tlsv1.2

  if [ -s /tmp/DownloadInstallAgentPackage ]; then
    if echo '31A52951335226FCD8BF73F58EBED5860E8298A3B396DC0D747052791ECEDBE1  /tmp/DownloadInstallAgentPackage' | sha256sum -c; then
      . /tmp/DownloadInstallAgentPackage
      Download_Install_Agent
    else
      echo "Failed to validate the agent installation script."
      logger -t Failed to validate the agent installation script
      false
    fi
  else
     echo "Failed to download the agent installation script."
     logger -t Failed to download the Deep Security Agent installation script
     false
  fi
else
  echo Please install CURL before running this script
  logger -t Please install CURL before running this script
  false
fi
sleep 15
/opt/ds_agent/dsa_control -r
/opt/ds_agent/dsa_control -a dsm://hb.genpact.com:443/ "policyid:23"


# Basic Hardening of the server
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "ClientAliveInterval 900" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
service sshd restart
echo "TMOUT=900" >> /etc/bashrc
echo "TMOUT=900" >> /etc/profile
chown root:root /etc/passwd
chown root:root /etc/shadow
chmod 644 /etc/passwd
chmod 400 /etc/shadow

# Stop update-motd servic for AmazonLinux
update-motd --disable
cat > /etc/motd << EOF
|-----------------------------------------------------------------|
|                       GENPACT                                   |
|  This system is for the use of authorized users only.           |
| Individuals using this computer system without authority, or in |
| excess of their authority, are subject to having all of their   |
| activities on this system monitored and recorded by system      |
| personnel.                                                      |
|                                                                 |
| In the course of monitoring individuals improperly using this   |
| system, or in the course of system maintenance, the activities  |
| of authorized users may also be monitored.                      |
|                                                                 |
| Anyone using this system expressly consents to such monitoring  |
| and is advised that if such monitoring reveals possible         |
| evidence of criminal activity, system personnel may provide the |
| evidence of such monitoring to law enforcement officials.       |
|-----------------------------------------------------------------|
EOF

#Check status of tools
ps aux | egrep -i 'nessus|ssm|ds'
