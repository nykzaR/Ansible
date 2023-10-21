#!/bin/bash
while true
do
    SERVER_IP='35.89.249.147/info.php'
    curl "http://${SERVER_IP}"
    sleep 1s
    curl "http://${SERVER_IP}"
    sleep 1s
    curl "http://${SERVER_IP}/test.html"
    sleep 1s
done