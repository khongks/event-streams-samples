#
# kskhong@kks-mbp16 libs % java -jar kafka-java-console-sample-2.0.jar 
# WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.

# Usage:
#     java -jar build/libs/kafka-java-console-sample-2.0.jar \
#               <kafka_brokers_sasl> { <api_key> | <user = token>:<password> } [-consumer] \
#               [-producer] [-topic]
# Where:
#     kafka_broker_sasl
#         Required. Comma separated list of broker endpoints to connect to, for
#         example "host1:port1,host2:port2".
#     api_key or user/password
#         Required. An Event Streams API key or user/password used to authenticate access to Kafka.
#         Use user/password if the user is defined as "token"
#     -consumer
#         Optional. Only consume message (do not produce messages to the topic).
#         If omitted this sample will both produce and consume messages.
#     -producer
#         Optional. Only produce messages (do not consume messages from the
#         topic). If omitted this sample will both produce and consume messages.
#     -topic
#         Optional. Specifies the Kafka topic name to use. If omitted the
#         default used is 'kafka-java-console-sample-topic'

## https://es-dev-kafka-bootstrap-es.itzroks-3100015379-hrl65h-6ccd7f378ae819553d37d5f2ee142bd6-0000.us-south.containers.appdomain.cloud:443
## https://es-dev-ibm-es-recapi-external-es.itzroks-3100015379-hrl65h-6ccd7f378ae819553d37d5f2ee142bd6-0000.us-south.containers.appdomain.cloud

NAMESPACE=es
RELEASE_NAME=es-dev
USER_CREDENTIAL_NAME=my-client-user
MODE=${1:-consumer}
TOPIC=${2:-APPTOPIC}

## pass: WssicjOr4Psh
## es-cert.p12
## openssl pkcs12 -info -in es-cert.p12 -nodes

# 26:69:7a:d5:37:fc:5a:1a:ed:0d:00:d6:e4:12:b2:e6:0d:96:9c:b0
# 1a:2a:b8:ee:3f:b7:73:71:e3:f8:3b:c5:e5:25:95:64:16:3c:90:90
# 1a:2a:b8:ee:3f:b7:73:71:e3:f8:3b:c5:e5:25:95:64:16:3c:90:90

BROKER_ENDPOINT="$(oc get route -n $NAMESPACE $RELEASE_NAME-kafka-bootstrap -ojson | jq -r '.spec.host'):443"

oc get secret -n $NAMESPACE $RELEASE_NAME-cluster-ca-cert -ojson | jq -r '.data."ca.crt"' | base64 -d > ca.crt

PASSWORD=$(oc get secret -n $NAMESPACE $USER_CREDENTIAL_NAME -ojson | jq -r '.data.password' | base64 -d)

SASL_JAAS_CONFIG=$(oc get secret -n $NAMESPACE $USER_CREDENTIAL_NAME -ojson | jq -r '.data."sasl.jaas.config"' | base64 -d)
echo ${SASL_JAAS_CONFIG}

echo "java -jar build/libs/kafka-java-console-sample-2.0.jar $BROKER_ENDPOINT $PASSWORD -${MODE}" -topic ${TOPIC}