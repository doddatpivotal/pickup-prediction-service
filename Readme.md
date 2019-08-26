# Concourse/Spinnaker Demo Application

This demo application works through a CI/CD pipeline exclusively with Concourse.  An then
follows up with a CI pipeline with concourse and CD pipeline with Spinnaker.

**CI/CD Pipeline with Concourse Only**

![CI/CD Pipeline with Concourse](docs/concourse-cicd-pipeline.png)

**CI/CD Pipeline with Concourse and Spinnaker**

![CI Pipeline with Concourse](docs/concourse-ci-pipeline.png)

![CD Pipeline with Concourse](docs/spinnaker-cd-pipeline.png)

## Generate load on the production Spinnaker deployed service
```bash
kubectl -n default run injector --image=alpine:3.10 --generator=run-pod/v1  -- \
    /bin/sh -c "apk add --no-cache curl; \
    while true; do curl -sS --max-time 3 \
    https://pickup-prediction.cfapps.io/predict; done"
```

## Deploy to Artifactory Locally    

```bash
export REPO_CONTEXT_URL=$REPO_CONTEXT_URL
export M2_SETTINGS_REPO_USERNAME=$M2_SETTINGS_REPO_USERNAME
export M2_SETTINGS_REPO_PASSWORD=$M2_SETTINGS_REPO_PASSWORD

REPO_CONTEXT_URL=$REPO_CONTEXT_URL \
    M2_SETTINGS_REPO_USERNAME=$M2_SETTINGS_REPO_USERNAME \
    M2_SETTINGS_REPO_PASSWORD=$M2_SETTINGS_REPO_PASSWORD \
    BUILD_ID=123 \
    BUILD_URI=local-machine \
    mvn clean deploy
```

## Unit test tasks

```bash
fly -t lab execute -c ci/tasks/unit-test.yml -i code-repo=. -i ci-scripts=.
```

## Setup Concourse Pipeline

```bash
fly -t lab login -k

fly -t lab set-pipeline  -p pickup-prediction-service-spinnaker \
    --config ci/pipeline-spinnaker.yml \
    --load-vars-from ci/.secrets.yml \
    --non-interactive
 
fly -t lab unpause-pipeline -p pickup-prediction-service-spinnaker

fly -t lab set-pipeline  -p pickup-prediction-service-concourse \
    --config ci/pipeline.yml \
    --load-vars-from ci/.secrets.yml \
    --non-interactive

fly -t lab unpause-pipeline -p pickup-prediction-service-concourse

```

### Example .secrets.yml file

```yaml
m2-settings-repo-username: username
m2-settings-repo-password: SuperSecretPassword
repo-context-url: http://artifactory.kingslanding.pks.lab.winterfell.live/artifactory
artifactory-repo: libs-release-local
code-repo-uri: git@github.com:doddatpivotal/todos-webflux.git
code-repo-branch: master
code-repo-group-id: io.todos
code-repo-artifact-id: todos-webflux
code-repo-owner: doddatpivotal
code-repo-repository: todos-webflux
code-repo-access-token: SuperSecretAccessToken
version-repo-uri: git@github.com:doddatpivotal/todos-webflux.git
version-repo-branch: version
code-repo-private-key: |
  -----BEGIN OPENSSH PRIVATE KEY----- fake
  fake TEST-KEY-CONTENTS fake
  -----END OPENSSH PRIVATE KEY-----
spinnaker-api: https://api.spinnaker.ingress.kingslanding.pks.lab.winterfell.live
webhook-source: pickup-prediction-service-ci
cf-test-api: https://api.run.pcfone.io
cf-test-username: username
cf-test-password: SuperSecretPassword
cf-test-org: pivot-dpfeffer
cf-test-space: test
cf-test-route: dodd-todos-test.apps.pcfone.io
cf-test-app-name: test-pickup-prediction-service
cf-prod-api: https://api.run.pcfone.io
cf-prod-username: username
cf-prod-password: SuperSecretPassword
cf-prod-org: pivot-dpfeffer
cf-prod-space: production
cf-prod-route: dodd-todos-prod.apps.pcfone.io
cf-prod-app-name: prod-pickup-prediction-service
```

## Run e2e tests

```bash
APPLICATION_URL="https://pickup-prediction.cfapps.io" mvn clean verify -Pe2e
```

## Cleanup Smoke Test Jobs

```bash
kubectl delete job -l spinnaker-job=e2e-test
```

## Deploy Spinnaker Application, Canary Config and Pipeline    

>Note: spin cli does not have methods to work on canary configs, so we have to use curl

```bash
spin application save \
  --application-name pickuppredictionservice \
  --cloud-providers cloudfoundry,kubernetes \
  --file ci/spinnaker/pickup-prediction-service/application.json \
  --owner-email dpfeffer@pivotal.io \
  --gate-endpoint https://api.spinnaker.ingress.kingslanding.pks.lab.winterfell.live \
  --insecure

curl -X POST 
  https://api.spinnaker.ingress.kingslanding.pks.lab.winterfell.live/v2/canaryConfig \
  --header 'Content-Type: application/json' \
  --data @ci/spinnaker/pickup-prediction-service/canary-config/keyenta-test.json \
  --insecure 

spin pipeline save \
  --file ci/spinnaker/pickup-prediction-service/pipeline/delivery.json \
  --gate-endpoint https://api.spinnaker.ingress.kingslanding.pks.lab.winterfell.live \
  --insecure
```

## Credit where credit is do

This sample app is inspired and kickstarted from my co-workers at Pivotal, Amith Nambiar and Pas Apicella.
They had a great [presentation at CF Summit 2019](https://www.youtube.com/watch?v=9C8m7n_sG38&list=PLhuMOCWn4P9h-9tcBVRFCaQ7rmdof66pe&index=94).
