##
##  node app.js <kafka_brokers_sasl> <api_key> <cert_location> [ -consumer | -producer ]
## 

## https://es-dev-kafka-bootstrap-es.itzroks-3100015379-hrl65h-6ccd7f378ae819553d37d5f2ee142bd6-0000.us-south.containers.appdomain.cloud:443
## https://es-dev-ibm-es-recapi-external-es.itzroks-3100015379-hrl65h-6ccd7f378ae819553d37d5f2ee142bd6-0000.us-south.containers.appdomain.cloud

NAMESPACE=es
RELEASE_NAME=es-dev
USER_CREDENTIAL_NAME=my-client-user
MODE=$1

## pass: WssicjOr4Psh
## es-cert.p12
## openssl pkcs12 -info -in es-cert.p12 -nodes

# 26:69:7a:d5:37:fc:5a:1a:ed:0d:00:d6:e4:12:b2:e6:0d:96:9c:b0
# 1a:2a:b8:ee:3f:b7:73:71:e3:f8:3b:c5:e5:25:95:64:16:3c:90:90
# 1a:2a:b8:ee:3f:b7:73:71:e3:f8:3b:c5:e5:25:95:64:16:3c:90:90

BROKER_ENDPOINT=$(oc get route -n $NAMESPACE $RELEASE_NAME-kafka-bootstrap -ojson | jq -r '.spec.host')

oc get secret -n $NAMESPACE $RELEASE_NAME-cluster-ca-cert -ojson | jq -r '.data."ca.crt"' | base64 -d | openssl x509 -noout -text > ca.crt

PASSWORD=$(oc get secret -n $NAMESPACE $USER_CREDENTIAL_NAME -ojson | jq -r '.data.password' | base64 -d)

echo "node app.js $BROKER_ENDPOINT $PASSWORD ./ca.crt -${MODE}"