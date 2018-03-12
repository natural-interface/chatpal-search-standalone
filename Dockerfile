ARG SOLR_VERSION=7.2-alpine
FROM solr:$SOLR_VERSION

LABEL maintainer=jakob.frank@redlink.co

ADD --chown=solr:solr \
    solr-conf \
    /opt/solr/server/solr/configsets

ADD --chown=solr:solr \
    https://oss.sonatype.org/content/repositories/snapshots/io/redlink/solr/compound-word-filter/1.0.0-SNAPSHOT/compound-word-filter-1.0.0-20180304.180502-3.jar \
    https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-analyzers-stempel/7.2.1/lucene-analyzers-stempel-7.2.1.jar \
    https://repo.redlink.io/mvn/content/groups/public/io/chatpal/chatpal-api/solr-ext/0.0.1-SNAPSHOT/solr-ext-0.0.1-20180312.124051-1.jar \
    /opt/solr/server/solr/configsets/chatpal/lib/

RUN mkdir -p /opt/solr/server/solr/chatpal/data && \
    echo -e "name=chatpal\nconfigSet=chatpal\n" >/opt/solr/server/solr/chatpal/core.properties;

# Expose Solr-Data dir
VOLUME ['/opt/solr/server/solr/chatpal']