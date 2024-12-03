# !/bin/bash
# 타겟 프로젝트에서 bash 실행

REPO_PATH=${PWD}
REPO_NAME=${REPO_PATH##*/}

echo 'target path : '$REPO_PATH
echo 'target name : '$REPO_NAME

mvn -Dmaven.test.skip=true -DaltDeploymentRepository=snapshot-repo::default::file://${REPO_PATH}/snapshots clean deploy
cd ${local_occidere_maven_repo}

git add .
git status
git commit -m "release new version of ${PROJ_NAME}"
git push origin release
