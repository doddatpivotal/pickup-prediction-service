kubectl -n default run injector 
    --image=alpine:3.10 \
    --generator=run-pod/v1 \ 
    -- \
        /bin/sh -c "apk add --no-cache curl; \
        while true; do curl -sS --max-time 3 \
        https://pickup-prediction.cfapps.io/predict; done"
    
mvn clean deploy -Ddistribution.management.release.id=central -Ddistribution.management.release.url=http://artifactory.kingslanding.pks.lab.winterfell.live/artifactory/libs-release-local

```bash
fly -t lab login -k

fly -t lab set-pipeline  -p pickup-prediction-service-spinnaker \
    --config ci/pipeline-spinnaker.yml \
    --load-vars-from ci/.secrets.yml \
    --non-interactive

fly -t lab unpause-pipeline -p pickup-prediction-service-spinnaker
```
