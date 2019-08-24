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

export BUILD_ID=`cat ${ROOT_FOLDER}/meta/build-id`
export BUILD_TEAM_NAME=`cat ${ROOT_FOLDER}/meta/build-team-name`
export BUILD_PIPELINE_NAME=`cat ${ROOT_FOLDER}/meta/build-pipeline-name`
export ATC_EXTERNAL_URL=`cat ${ROOT_FOLDER}/meta/atc-external-url`
export BUILD_URI=${ATC_EXTERNAL_URL}/teams/${BUILD_TEAM_NAME}/pipelines/${BUILD_PIPELINE_NAME}

echo "BUILD_ID: ${BUILD_ID}"
echo "BUILD_TEAM_NAME: ${BUILD_TEAM_NAME}"
echo "BUILD_PIPELINE_NAME: ${BUILD_PIPELINE_NAME}"
echo "BUILD_URI: ${BUILD_URI}"

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
