kubectl -n default run injector 
    --image=alpine:3.10 \
    --generator=run-pod/v1 \ 
    -- \
        /bin/sh -c "apk add --no-cache curl; \
        while true; do curl -sS --max-time 3 \
        https://pickup-prediction.cfapps.io/predict; done"
    
mvn clean deploy -Ddistribution.management.release.id=central -Ddistribution.management.release.url=http://artifactory.kingslanding.pks.lab.winterfell.live/artifactory/libs-release-local
