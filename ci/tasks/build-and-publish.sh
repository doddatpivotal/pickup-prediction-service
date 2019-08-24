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
    <profiles>
      <profile>
        <repositories>
          <repository>
            <snapshots>
              <enabled>false</enabled>
            </snapshots>
            <id>central</id>
            <name>libs-release</name>
            <url>http://artifactory.kingslanding.pks.lab.winterfell.live:80/artifactory/libs-release</url>
          </repository>
          <repository>
            <snapshots />
            <id>snapshots</id>
            <name>libs-snapshot</name>
            <url>http://artifactory.kingslanding.pks.lab.winterfell.live:80/artifactory/libs-snapshot</url>
          </repository>
        </repositories>
        <pluginRepositories>
          <pluginRepository>
            <snapshots>
              <enabled>false</enabled>
            </snapshots>
            <id>central</id>
            <name>libs-release</name>
            <url>http://artifactory.kingslanding.pks.lab.winterfell.live:80/artifactory/libs-release</url>
          </pluginRepository>
          <pluginRepository>
            <snapshots />
            <id>snapshots</id>
            <name>libs-snapshot</name>
            <url>http://artifactory.kingslanding.pks.lab.winterfell.live:80/artifactory/libs-snapshot</url>
          </pluginRepository>
        </pluginRepositories>
        <id>artifactory</id>
      </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>artifactory</activeProfile>
    </activeProfiles>
</settings>


EOF
echo "Settings xml written"

# Update version and deploy to remote maven repository
echo "Running mvn deploy command"
./mvnw versions:set \
    -DnewVersion=${version}
./mvnw deploy \
    -DskipTests

# Create file with tag name to be used in later put step
echo "version-${version}-artifactory-deploy-$(date +%Y%m%d_%H%M%S)" > ../results/tag.txt

#mkdir ../results/repository
#cp -a ${M2_HOME}/repository/. ../results/repository