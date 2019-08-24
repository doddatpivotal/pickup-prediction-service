#!/bin/sh

set -ex

export version=`cat version/version`
echo "Build version: ${version}"

M2_HOME=${HOME}/.m2
mkdir -p ${M2_HOME}

export ROOT_FOLDER=$( pwd )
M2_LOCAL_REPO="${ROOT_FOLDER}/.m2"

mkdir -p "${M2_LOCAL_REPO}/repository"

cat > ${M2_HOME}/settings.xml <<EOF

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">
      <localRepository>${M2_LOCAL_REPO}/repository</localRepository>
</settings>

EOF
echo "Settings xml written"

cd code-repo

echo "CODE_CONTEXT_URL: ${REPO_CONTEXT_URL}"
echo "BUILD_URI: ${BUILD_URI}"
echo "BUILD_ID: ${BUILD_ID}"
export BUILD_ID=${version}
env

# Update version and deploy to remote maven repository
echo "Running mvn deploy command"
./mvnw versions:set \
    -DnewVersion=${version} \
    -s ${M2_HOME}/settings.xml
./mvnw deploy \
    -DskipTests \
    -s ${M2_HOME}/settings.xml

# Create file with tag name to be used in later put step
echo "version-${version}-artifactory-deploy-$(date +%Y%m%d_%H%M%S)" > ../results/tag.txt

#mkdir ../results/repository
#cp -a ${M2_HOME}/repository/. ../results/repository