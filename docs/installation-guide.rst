.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0



Installation Guide
==================

.. contents::
   :depth: 3
   :local:

Abstract
--------

This document describes how to install the software for SMO O1, it's dependencies and required system resources.


Version history

+--------------------+--------------------+--------------------+--------------------+
| **Date**           | **Ver.**           | **Author**         | **Comment**        |
|                    |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+
| 2021-12-13         | 0.0.1              | 		       | Initial Version    |
|                    |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+
|                    | 0.0.2              |                    |                    |
|                    |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+
|                    | 1.0                |                    |                    |
|                    |                    |                    |                    |
|                    |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+


Introduction
------------

.. <INTRODUCTION TO THE SCOPE AND INTENTION OF THIS DOCUMENT AS WELL AS TO THE SYSTEM TO BE INSTALLED>

O1:

This document describes the supported software and hardware configurations for the reference component as well as providing guidelines on how to install and configure such reference system.

The audience of this document is assumed to have good knowledge in RAN network, Docker and Linux system.


Preface
-------
.. <DESCRIBE NEEDED PREREQUISITES, PLANNING, ETC.>

Prerequisites:

Before starting the installation of O1, make sure the following hardware and software requirements are met.

.. note:any preperation you need before setting up sotfware and hardware 


Hardware Requirements
---------------------
.. <PROVIDE A LIST OF MINIMUM HARDWARE REQUIREMENTS NEEDED FOR THE INSTALL>

System:

Following minimum hardware requirements must be met for installation of SMO O1. While the system can be installed on a smaller system, it will be slow, and difficult to use:

+--------------------+----------------------------------------------------+
| **HW Aspect**      | **Requirement**                                    |
|                    |                                                    |
+--------------------+----------------------------------------------------+
| **# of servers**   | 	1	                                          |
+--------------------+----------------------------------------------------+
| **CPU**            | 	4					          |
|                    |                                                    |
+--------------------+----------------------------------------------------+
| **RAM**            | 	16G						  |
|                    |                                                    |
+--------------------+----------------------------------------------------+
| **Disk**           | 	100G				                  |
|                    |                                                    |
+--------------------+----------------------------------------------------+
| **NICs**           | 	1						  |
|                    |                                                    |
|                    | 							  |
|                    |                                                    |
|                    |  					 	  |
|                    |                                                    |
+--------------------+----------------------------------------------------+



Software Installation and Deployment
------------------------------------
.. <DESCRIBE THE FULL PROCEDURES FOR THE INSTALLATION OF THE O-RAN COMPONENT INSTALLATION AND DEPLOYMENT>

Docker and docker-compose:

This section describes the installation of the software to enable the SMO O1 interface on the referenced hardware.

The software installation has been tested on a Ubuntu 20.04 based system. Assuming such an installation, make sure that Docker and docker-compose are installed on the system.

To deploy the solution, type the following on the command line::

    $ docker-compose up -d

Once the deployment is successful, verify the deployment using the following command::

    $ docker-compose ps

Expect an output that is similar to this::

    Name               Command               State                                         Ports
    ------------------------------------------------------------------------------------------------------------------------------------
    sdnr     /bin/sh -c /opt/onap/sdnc/ ...   Up      0.0.0.0:8101->8101/tcp,:::8101->8101/tcp, 0.0.0.0:8181->8181/tcp,:::8181->8181/tcp
    sdnrdb   /tini -- /usr/local/bin/do ...   Up      9200/tcp, 9300/tcp

Thereafter, the GUI interface for O1 can be accessed at::

    http://<host_ip>:8181/odlux/index.html

The username/password is:

admin/Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

and can be updated by updating the .env file in the repository.


References
----------
.. <PROVIDE NEEDED/USEFUL REFERENCES>




