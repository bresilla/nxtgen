#!/bin/bash

if [ -z "${UE5_DIR}" ]; then
        printf "Please set UE5_DIR to path of UE5 folder\n"
        exit 1
fi

#if folder does not exist exit
if [ ! command -v rsync &> /dev/null ]; then
        printf "rsync could not be found, please install it\n"
    echo "run first ./get_deps.sh"
        exit 1
fi

printf "Syncing interfaces\n"
rsync -av --ignore-existing Interfaces/ Plugins/rclUE

printf "Copying patches"
rsync -av ./Patches/ ./

if ! command -v dotnet &> /dev/null; then
    echo "dotnet is not installed, installing it"
    echo "run first ./get_deps.sh"
fi

if [ -z "${UE5_DIR}" ]; then
	printf "Please set UE5_DIR to path of UE5 UnrealEngine's parent folder\n"
	exit 1
fi

PROJ_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
${UE5_DIR}/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool Development Linux -Project="${PROJ_DIR}/nxtgen.uproject" -TargetType=Editor -Progress -NoEngineChanges -NoHotReloadFromIDE
