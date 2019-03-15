BASEDIR=$(readlink -f $(dirname "$0") )
ENV_FILE=${BASEDIR}/env


[ -f ${ENV_FILE} ] || {
    echo "Configuration file missing: ${ENV_FILE}"
    exit 1
}

. $ENV_FILE

export SONARQUBE_JDBC_USERNAME="${DB_USER}"
export SONARQUBE_JDBC_PASSWORD="${DB_PASS}"
export SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/${DB_NAME}?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false"

docker run \
    --name sonarqube \
    -d \
    --restart=unless-stopped \
    -p 9000:9000 \
    --link mysql:mysql \
    -v ${BASEDIR}/conf:/opt/sonarqube/conf \
    -v /var/log/sonar:/opt/sonarqube/logs \
    -e SONARQUBE_JDBC_USERNAME \
    -e SONARQUBE_JDBC_PASSWORD \
    -e SONARQUBE_JDBC_URL \
    -e LDAP_BIND_DN \
    -e LDAP_BIND_PASS \
    sonarqube:7.6-community
