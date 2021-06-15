This README is for running the tests. See the README in the client
folder for how the SMO NETCONF client is setup.

The run_tests.sh script 
1. Brings up simulators(RU & DU)
2. Brings up SDNR
3. Add simulators to SDNR
4. Checks connectivity status by fetching the capabilities
5. Updates DU and RU config and prints the output
6. Teardown the services

The environmental variables used to setup and run the simulators is stored in a .env file.

Note: This script should be executed from the root of the repository.
