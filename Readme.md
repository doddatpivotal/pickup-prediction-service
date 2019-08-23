kubectl -n default run injector --image=alpine:3.10 -- \
    /bin/sh -c "apk add --no-cache curl; \
    while true; do curl -sS --max-time 3 \
    https://spinnaker-test-app.cfapps.io/predict; done"
    
https://api.github.com/repos/doddatpivotal/pickup-prediction-service/contents/manifest.yml