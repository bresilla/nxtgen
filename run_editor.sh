#!/bin/bash
# Copyright 2020-2022 Rapyuta Robotics Co., Ltd.
# Modified for Artemy Digital Twin by Wageningen University and Research

if [ -z "${UE5_DIR}" ]; then
        printf "Please set UE5_DIR to path of UE5 folder\n"
        exit 1
fi

#if folder does not exist exit
if [ ! command -v rsync &> /dev/null ]; then
        printf "rsync could not be found, please install it\n"
        printf "in Debian based systems, run: sudo apt install rsync\n"
        exit 1
fi

printf "Syncing interfaces\n"
rsync -av --ignore-existing Interfaces/ Plugins/rclUE

CURRENT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_DIR=${2:-"${CURRENT_DIR}"}

DISCOVERY_SERVER=${1:-true}
if $DISCOVERY_SERVER; then
        (exec "${PROJECT_DIR}/ros_discovery.sh")
fi

DEFAULT_LEVEL=${LEVEL_NAME:-"DigitalTwin"} 
DEFAULT_RATE=${FIXED_FRAME_RATE:-"30.0"}
DEFAULT_RTF=${TARGET_RTF:-"1.0"} 
sed -e 's/${LEVEL_NAME}/'${DEFAULT_LEVEL}'/g' Config/DefaultEngineBase.ini > Config/DefaultEngine.in
sed -i -e 's/${FIXED_FRAME_RATE}/'${DEFAULT_RATE}'/g' Config/DefaultEngine.ini
sed -i -e 's/${TARGET_RTF}/'${DEFAULT_RTF}'/g' Config/DefaultEngine.ini

UE_EDITOR="${UE5_DIR}/Engine/Binaries/Linux/UnrealEditor"
(exec "$UE_EDITOR" "${PROJECT_DIR}/nxtgen.uproject")
