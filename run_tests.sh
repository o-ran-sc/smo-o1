#!/bin/bash

# cleanup any previous (unsuccessful) runs.
docker-compose down

cd client/tests
# bringup simulators
docker-compose up -d

cd ../
# Bringup sdnr
docker-compose up -d

# wait until sdnr up & running
for i in {1..60}; do
   res=$(curl -o /dev/null -sw %{http_code} http://localhost:8181/odlux/index.html)
   echo "$res"
   expect="200"
   if [ "$res" == "$expect" ]; then
      echo -e "SDNR is up and running\n"
      break;
   else
      sleep $i
   fi
done

# check RU 
nc -z localhost 18300
echo $?

# check DU status
nc -z localhost 18310
echo $?

# Adding delay to avoid curl failures
sleep 30

HOST_IP=$(hostname -I | awk '{print $1}')
USER_PWD=admin:Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

# Add DU
echo "Adding DU simulator"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD  -X POST "http://localhost:8181/rests/operations/netconf-node-topology:create-device" -H "accept: */*" -H "Content-Type: application/json" -d '{"input":{"pass-through":{},"login-password":{"username":"netconf","password":"netconf!"},"host":"'"$HOST_IP"'","port":"18310","node-id":"du_sim"}}')

echo Response Code $res
if [ "$res" == "204" ]; then
      echo -e "Successfully added device RU \n"
fi
sleep 2

# check DU connection
echo -e "Checking Du simulator \n"
echo $(curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/netconf-node-topology:available-capabilities?content=nonconfig" -H "accept: application/xml")


# Add RU
echo "Adding RU Simulator\n"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X POST "http://localhost:8181/rests/operations/netconf-node-topology:create-device" -H "accept: */*" -H "Content-Type: application/json" -d '{"input":{"pass-through":{},"login-password":{"username":"netconf","password":"netconf!"},"host":"'"$HOST_IP"'","port":"18300","node-id":"ru_sim"}}')

echo "Response Code: " $res
if [ "$res" == "204" ]; then
      echo -e "Successfully added device RU \n"
fi
sleep 2

# check RU connection
echo -e "Checking RU simulator connection"
echo $(curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/netconf-node-topology:available-capabilities?content=nonconfig" -H "accept: application/xml")


echo -e "\nRU cofig before update"
curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: application/xml"

echo -e "\nUpdating RU config"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X PUT "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: */*" -H "Content-Type: application/json" -d '{"transport-delay":{"t12-min":1000,"t12-max":66666,"t34-min":2000,"t34-max":55555}}')

echo -e "\nResponse Code: " $res

echo -e "\nRU cofig afer update"
curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: application/xml"


# get DU config
echo -e "\nDU cofig before update"
curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: application/xml"


# Update DU config
echo -e "Updating DU cofig"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X PUT "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: */*" -H "Content-Type: application/json" -d "{"du-to-ru-connection":[{"name":"O-RU-1","administrative-state":"UNLOCKED"}]}")

echo -e "\nResponse Code: " $res

# Validate DU config after update
echo -e "DU cofig afer update"
curl -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: application/xml"


# Bring down the sdnr
docker-compose down

# bring down the simulators
cd tests/
docker-compose down
echo -e "\nTests completed"
