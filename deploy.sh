#!/bin/bash
#./deploy.sh C:\Users\{USER NAME}\..\{TARGET_PROJECT}
set -e

RED='\033[0;31m'
NC='\033[0m'

REPO_PATH=$(PWD)
TARG_PATH=$(realpath "${1:-$(pwd)}")

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

cd $TARG_PATH
mvn -Dmaven.test.skip=true -DaltDeploymentRepository=release::default::file://$REPO_PATH/releases clean deploy
cd $REPO_PATH
chmod -R 775 ./releases

git add .
git status
git commit -m "release new version of ${TARG_PATH##*/}"
git push origin release