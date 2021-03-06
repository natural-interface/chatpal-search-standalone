ARG SOLR_VERSION=7.2-alpine
FROM solr:$SOLR_VERSION

LABEL maintainer=jakob.frank@redlink.co
LABEL vendor="Redlink GmbH"
LABEL description="Rocketchat + Chatpal = Easy and efficient digital business communication."

# Fix upstream-scripts
RUN sed -i '/-Djetty.host/ d' \
      /opt/docker-solr/scripts/start-local-solr ;\
    sed -i '/stop-local-solr/i mkdir -p "$CORE_DIR"' \
      /opt/docker-solr/scripts/solr-create


# Deploy the chatpal configset
#ADD --chown=solr:solr \
ADD \
    solr-conf \
    /opt/solr/server/solr/configsets

# Fetch additional solr-dependencies
#ADD --chown=solr:solr \
ADD \
    https://oss.sonatype.org/content/repositories/snapshots/io/redlink/solr/compound-word-filter/1.0.0-SNAPSHOT/compound-word-filter-1.0.0-20180304.180502-3.jar \
    https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-analyzers-stempel/7.2.1/lucene-analyzers-stempel-7.2.1.jar \
    https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-analyzers-morfologik/7.2.1/lucene-analyzers-morfologik-7.2.1.jar \
    https://repo.maven.apache.org/maven2/org/carrot2/morfologik-stemming/2.1.1/morfologik-stemming-2.1.1.jar \
    https://repo.maven.apache.org/maven2/org/carrot2/morfologik-fsa/2.1.1/morfologik-fsa-2.1.1.jar \
    https://repo.maven.apache.org/maven2/ua/net/nlp/morfologik-ukrainian-search/3.9.0/morfologik-ukrainian-search-3.9.0.jar \
    https://repo1.maven.org/maven2/io/chatpal/solr/solr-ext/0.0.2/solr-ext-0.0.2.jar \
    /opt/solr/server/solr/lib/

USER root
# docker-hub does not yet support the --chown-flag
RUN chown -R solr:solr \
    /opt/solr/server/solr/lib/ \
    /opt/solr/server/solr/configsets/chatpal
# create data-dir
RUN mkdir -p /data/solr && chown -R solr:solr /data/solr
USER solr

# Expose Solr-Data dir
VOLUME ["/data/solr"]

ENV SOLR_DATA_HOME /data/solr/

# Command
CMD ["solr-create", "-c", "chatpal", "-n", "chatpal", "-d", "/opt/solr/server/solr/configsets/chatpal"]
