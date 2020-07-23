#!/bin/bash

SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

#start check
if [[ ! -f /etc/centos-release ]]; then
    echo OS not CentOS. This script only for CentOS!
    exit 1
fi
#finish check

OSVER=$(grep -o '[0-9]' /etc/centos-release | head -n1)
if [[ $OSVER -eq 7 ]]; then
    yum install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm
    yum clean all
    yum install -y salt-master salt-api salt-ssh
elif [[ $OSVER -eq 8 ]]; then
    dnf install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
    dnf clean all
    dnf install -y salt-master salt-api salt-ssh python3-pygit2
fi

cp "$SCRIPTDIR"/master.d/* /etc/salt/master.d/
cp "$SCRIPTDIR"/bin/*.sh /usr/local/bin/

systemctl enable salt-master --now
systemctl enable salt-api --now
firewall-cmd --permanent --add-service=salt-master
firewall-cmd --add-service=salt-master
