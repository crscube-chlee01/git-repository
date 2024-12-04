#!/bin/bash
#./deploy.sh C:\Users\{USER NAME}\..\{TARGET_PROJECT}
set -e

RED='\033[0;31m'
NC='\033[0m'

REPO_PATH=$(pwd)
TARG_PATH=$(realpath "${1:-$(pwd)}")
RUN_OS=$(uname)

echo 'repository path : '$REPO_PATH
echo 'target path : '$TARG_PATH

if [ "$#" -eq 0 ]; then
  echo -e "${RED}Error: No arguments provided.${NC}"
  exit 1
fi
if [ ! -f "$TARG_PATH/pom.xml" ]; then
    echo -e "${RED}Error: pom.xml not found in ${TARG_PATH}${NC}"
    exit 1
fi
if [ RUN_OS == '*MINGW*' ]; then
  echo "Run on MINGW OS"
  REPO_PATH=$(PWD)
fi

chmod 777 $REPO_PATH/releases
cd $TARG_PATH
#mvn clean deploy -Dmaven.test.skip=true -DaltDeploymentRepository=release::default::file://$REPO_PATH/releases
mvn clean deploy -Dmaven.test.skip=true -DaltDeploymentRepository=snapshot::default::file://$REPO_PATH/snapshots
cd $REPO_PATH

git add .
git status
git commit -m "release new version of ${TARG_PATH##*/}"
git push origin release