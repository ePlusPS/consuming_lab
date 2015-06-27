Cloud tools for initial VM bringup
==================================

Here you will find scripts and templates to automate the
bringup of inital systems.  E.g. a bastion host on the 
OpenStack environment, or user-data scripts to automate
OpenStack tool installs.

Ubuntu Images:
Tested against the Ubuntu-Server-14.04 image
ubuntu-bastion-hot.yaml
ubuntu-user-data.sh

Tested against the CentOS-Server-7-x86_64 image
centos-bastion-hot.yaml
centos-user-data.sh

To use these scripts, you will need a few pieces of
information for your project:

Tenant name (aka Project name)
User name (aka your EID or service account name)
a Floating IP address ID (for the HOT templates)
  - note this is not the floating IP Address
  - this is the ID of an IP that has been allocated
    to your project

