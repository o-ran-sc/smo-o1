#!/bin/bash

cd client/tests
# cleanup any previous (unsuccessful) runs.
docker-compose down

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
if [ $? == 0 ]; then
    echo -e "RU is up.\n"
else
    echo -e "RU failed to connect.\n"
    exit 1
fi

# check DU status
nc -z localhost 18310
if [ $? == 0 ]; then
    echo -e "DU is up.\n"
else
    echo -e "DU failed to connect.\n"
    exit 1
fi

# Adding delay to avoid curl failures
sleep 30

HOST_IP=$(hostname -I | awk '{print $1}')
USER_PWD=admin:Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

# Add DU
echo "Adding DU simulator"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD  -X POST "http://localhost:8181/rests/operations/netconf-node-topology:create-device" -H "accept: */*" -H "Content-Type: application/json" -d '{"input":{"pass-through":{},"login-password":{"username":"netconf","password":"netconf!"},"host":"'"$HOST_IP"'","port":"18310","node-id":"du_sim"}}')

if [ "$res" == "204" ]; then
    echo -e "Successfully added device DU \n"
else
    echo -e "Failed to add DU.\n"
    exit 1
fi
sleep 2

# check DU connection
echo -e "Checking DU simulator \n"
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/netconf-node-topology:available-capabilities?content=nonconfig" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "DU simulator is alive.\n"
else
    echo -e "DU simulator is not responding.\n"
    exit 1
fi

# Add RU
echo ""
echo "Adding RU Simulator\n"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X POST "http://localhost:8181/rests/operations/netconf-node-topology:create-device" -H "accept: */*" -H "Content-Type: application/json" -d '{"input":{"pass-through":{},"login-password":{"username":"netconf","password":"netconf!"},"host":"'"$HOST_IP"'","port":"18300","node-id":"ru_sim"}}')

if [ "$res" == "204" ]; then
    echo -e "Successfully added device RU \n"
else
    echo -e "Failed to add RU.\n"
    exit 1
fi
sleep 2

# check RU connection
echo -e "Checking RU simulator connection"
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/netconf-node-topology:available-capabilities?content=nonconfig" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "RU simulator is alive.\n"
else
    echo -e "RU simulator is not responding.\n"
    exit 1
fi

echo -e "\nRU cofig before update"
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "RU config check before update succeeded.\n"
else
    echo -e "RU config check before update failed.\n"
    exit 1
fi

echo -e "\nUpdating RU config"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X PUT "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: */*" -H "Content-Type: application/json" -d '{"transport-delay":{"t12-min":1000,"t12-max":66666,"t34-min":2000,"t34-max":55555}}')
if [ "$res" == "204" ]; then
    echo -e "Successfully updated RU config.\n"
else
    echo -e "Failed to update RU config.\n"
    exit 1
fi

echo -e "\nRU config afer update."
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=ru_sim/yang-ext:mount/o-ran-delay-management:delay-management/adaptive-delay-configuration/transport-delay" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "RU config after update succeeded.\n"
else
    echo -e "RU config after update failed.\n"
    exit 1
fi

# get DU config
echo -e "\nDU config before update."
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "DU config before update succeeded.\n"
else
    echo -e "DU config before update failed.\n"
    exit 1
fi

# Update DU config
echo -e "Updating DU config"
res=$(curl -o /dev/null -sw %{http_code} -u $USER_PWD -X PUT "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: */*" -H "Content-Type: application/json" -d "{"du-to-ru-connection":[{"name":"O-RU-1","administrative-state":"UNLOCKED"}]}")
if [ "$res" == "204" ]; then
    echo -e "Successfully updated DU config.\n"
else
    echo -e "Failed to update DU config.\n"
    exit 1
fi

# Validate DU config after update
echo -e "DU cofig afer update"
res=$(curl -o /dev/null -sw '%{http_code}' -u $USER_PWD -X GET "http://localhost:8181/rests/data/network-topology:network-topology/topology=topology-netconf/node=du_sim/yang-ext:mount/o-ran-sc-du-hello-world:network-function/du-to-ru-connection=O-RU-1" -H "accept: application/xml")
if [ $res == 200 ]; then
    echo -e "DU config after update succeeded.\n"
else
    echo -e "DU config after update failed.\n"
    exit 1
fi

# Bring down the sdnr
docker-compose down

# bring down the simulators
cd tests/
docker-compose down
echo -e "\nTests completed"
exit 0
