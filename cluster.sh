#!/bin/bash
# Start container cluster
for i in $(seq 1 3); do
  # Start a container
  docker run \
    -td \
    --name "phus$i" \
    stackoverflower/phusion-baseimage-test
  # Create network interface in the container
  pipework bridge1 -i eth1 "phus$i" "172.17.99.$i/24"
done
