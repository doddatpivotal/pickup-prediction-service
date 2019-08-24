#!/bin/sh

export version=`cat version/version`
echo "Build version: ${version}"

cd code-repo


M2_HOME=${HOME}/.m2

mkdir -p ${M2_HOME}

echo "M2 Local Repo: ${M2_HOME}"

# For Maven Wrapper
export MAVEN_USER_HOME=${M2_HOME}

mkdir -p "${M2_HOME}/repository"

# Create custom settings.xml file with credentials required to publish to remote maven repi
cat > "settings.xml" <<EOF

<?xml version="1.0" encoding="UTF-8"?>
<settings>
    <localRepository>${M2_HOME}/repository</localRepository>
	<servers>
		<server>
			<id>\${M2_SETTINGS_REPO_ID}</id>
			<username>\${M2_SETTINGS_REPO_USERNAME}</username>
			<password>\${M2_SETTINGS_REPO_PASSWORD}</password>
		</server>
	</servers>
</settings>


EOF
echo "Settings xml written"

# Update version and deploy to remote maven repository
echo "Running mvn deploy command"
./mvnw versions:set
    -DnewVersion=${version}\
    --settings settings.xml\
./mvnw package \
    -DskipTests \
    -Ddistribution.management.release.id="${M2_SETTINGS_REPO_ID}" \
    -Ddistribution.management.release.url="${REPO_WITH_BINARIES_FOR_UPLOAD}" \
    --settings settings.xml

# Create file with tag name to be used in later put step
echo "version-${version}-artifactory-deploy-$(date +%Y%m%d_%H%M%S)" > ../results/tag.txt

mkdir ../results/repository
cp -a ${M2_HOME}/repository/. ../results/repository