Cloud tools for initial VM bringup
==================================

Here you will find scripts and templates to automate the
bringup of inital systems.  E.g. a bastion host on the 
OpenStack environment, or user-data scripts to automate
OpenStack tool installs.

Ubuntu Images:
Tested against the 'trusty' Ubuntu-Server-14.04 image
ubuntu-user-data.sh

Tested against the centos7 image
centos-user-data.sh

To use these scripts, you will need a few pieces of
information for your project:

In addition to the user data scripts, there is an example HOT script that can be used as an example for a HEAT deployment. And there is a test script that creates an example auto deploy/test/delete cycle.

