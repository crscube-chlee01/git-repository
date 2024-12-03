#!/bin/bash
#./deploy.sh C:\Users\{USER NAME}\..\{TARGET_PROJECT}
set -e

RED='\033[0;31m'
NC='\033[0m'

REPO_PATH=${PWD}
TARG_PATH=${0}

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

mvn -Dmaven.test.skip=true -DaltDeploymentRepository=snapshot-repo::default::file://$REPO_PATH/snapshots clean deploy
cd $TARG_PATH

git add .
git status
git commit -m "release new version of ${TARG_PATH##*/}"
git push origin release