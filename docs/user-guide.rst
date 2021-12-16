.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) <optionally add copywriters name>


User Guide
==========

This is the user guide of OSC SMO O1 Interface

.. contents::
   :depth: 3
   :local:

..  a user guide should be how to use the component or system; it should not be a requirements document
..  delete this content after edittng it


Description
-----------
.. Describe the traget users of the projcet, for example, modeler/data scientist, ORAN-OSC platform admin, marketplace user, design studio end user, etc
.. Descirbe how the target users can get use of a O-RAN SC component.
.. If the guide contains sections on third-party tools, is it clearly stated why the O-RAN-OSC platform is using those tools? Are there instructions on how to install and configure each tool/toolset?

This project is intended for operators that want to configure the RAN Network Functions (NF), i.e., O-DU, O-CU, O-RU, and the Near RT-RIC over the O1 (NETCONF/RESTCONF) interface.

Each of the NFs advertise their own capabilities over a NETCONF session that is established between the SMO and each of the NFs. Thereafter the NETCONF session is used to configure and manage each of the NFs.

This user guide assumes that Installation Guide has been followed to install the necessary hardware and software.

Feature Introduction
--------------------
.. Provide enough information that a user will be able to operate the feature on a deployed scenario. content can be added from administration, management, using, Troubleshooting sections perspectives.

The GUI interface for O1 interface can be accessed at::

    http://<host_ip>:8181/odlux/index.html

The username/password is:

admin/Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

and can be updated by updating the .env file in the repository.



    

