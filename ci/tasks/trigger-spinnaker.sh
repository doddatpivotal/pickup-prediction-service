#!/bin/sh

set -e

export version=`cat version/version`
echo "Build version: ${version}"

curl -X POST \
  ${SPINNKER_API}/webhooks/webhook/${WEBHOOK_SOURCE} \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
	"artifacts": [
		{
        "reference": "'${GROUP_ID}':'${ARTIFACT_ID}':'${version}'",
        "type": "maven/file"
        }
	]
}
' -k

cd deployment

# Create github tag file to be used in later put step
echo "${version}-spinnaker-trigger-$(date +%Y%m%d_%H%M%S)" > tag.txt