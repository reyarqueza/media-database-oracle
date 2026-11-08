# Optional manual image build (not used by Reopen in Container — see install-clients.sh).
# Cursor/Anysphere dev containers avoid custom compose builds that require
# docker buildx bake --allow=fs.read on Dockerfile-with-features.
#
# docker build -t media-database-oracle-dev -f Dockerfile .

FROM eclipse-temurin:21-jre AS java21

FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG TARGETARCH
ARG IC_VERSION=23.26.4.0.0
ARG IC_OTN_ID=2326400

USER root

COPY --from=java21 /opt/java/openjdk /usr/lib/jvm/temurin-21-jre
COPY install-clients.sh /tmp/install-clients.sh
RUN chmod +x /tmp/install-clients.sh \
    && IC_VERSION=${IC_VERSION} IC_OTN_ID=${IC_OTN_ID} bash /tmp/install-clients.sh \
    && rm /tmp/install-clients.sh

ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jre
ENV SQLCL_HOME=/opt/sqlcl
ENV ORACLE_HOME=/opt/oracle/instantclient_23_26
ENV LD_LIBRARY_PATH=${ORACLE_HOME}
ENV PATH="${ORACLE_HOME}:${JAVA_HOME}/bin:/opt/sqlcl/bin:${PATH}"

USER vscode
