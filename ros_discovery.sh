#!/bin/bash

source /opt/ros/jazzy/setup.bash

export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_DISCOVERY_SERVER="127.0.0.1:11811"
export FASTRTPS_DEFAULT_PROFILES_FILE=${PWD}/fastdds_config.xml

fastdds discovery -i 0 &
ros2 daemon start

