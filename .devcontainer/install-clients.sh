#!/usr/bin/env bash
# Installs SQL*Plus (Instant Client), Temurin 21 JRE, and SQLcl into /opt.
# Idempotent — safe on container recreate when /opt is on a persistent volume.
set -euo pipefail

IC_VERSION="${IC_VERSION:-23.26.4.0.0}"
IC_OTN_ID="${IC_OTN_ID:-2326400}"
IC_BASE="https://download.oracle.com/otn_software/linux/instantclient/${IC_OTN_ID}"
JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/temurin-21-jre}"
SQLPLUS_BIN="/opt/oracle/instantclient_23_26/sqlplus"
SQLCL_BIN="/opt/sqlcl/bin/sql"

write_env_profile() {
  cat >/etc/profile.d/oracle-dev.sh <<EOF
export JAVA_HOME=${JAVA_HOME}
export SQLCL_HOME=/opt/sqlcl
export ORACLE_HOME=/opt/oracle/instantclient_23_26
export LD_LIBRARY_PATH=\${ORACLE_HOME}
export PATH=\${ORACLE_HOME}:\${JAVA_HOME}/bin:/opt/sqlcl/bin:\${PATH}
EOF
}

finalize_install() {
  chmod -R a+rX /opt/sqlcl /opt/oracle 2>/dev/null || true
  ln -sf /opt/sqlcl/bin/sql /usr/local/bin/sqlcl
  ln -sf /opt/sqlcl/bin/sql /usr/local/bin/sql
  write_env_profile
}

ensure_os_packages() {
  # Instant Client needs libaio on the container filesystem (not on /opt volumes).
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends curl unzip libaio1
}

if [[ -x "${SQLPLUS_BIN}" ]] && [[ -x "${JAVA_HOME}/bin/java" ]] && [[ -x "${SQLCL_BIN}" ]]; then
  echo "Oracle clients already installed; skipping download."
  ensure_os_packages
  finalize_install
  exit 0
fi

ensure_os_packages

ARCH="$(uname -m)"
case "${ARCH}" in
  aarch64|arm64) IC_ARCH=arm64 ;;
  x86_64|amd64) IC_ARCH=x64 ;;
  *)
    echo "unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

if [[ ! -x "${SQLPLUS_BIN}" ]]; then
  echo "Installing Instant Client + SQL*Plus ${IC_VERSION}..."
  mkdir -p /opt/oracle
  curl -fsSL -o /tmp/ic-basic.zip \
    "${IC_BASE}/instantclient-basic-linux.${IC_ARCH}-${IC_VERSION}.zip"
  curl -fsSL -o /tmp/ic-sqlplus.zip \
    "${IC_BASE}/instantclient-sqlplus-linux.${IC_ARCH}-${IC_VERSION}.zip"
  unzip -q -o /tmp/ic-basic.zip -d /opt/oracle
  unzip -q -o /tmp/ic-sqlplus.zip -d /opt/oracle
  rm -f /tmp/ic-basic.zip /tmp/ic-sqlplus.zip
fi

if [[ ! -x "${JAVA_HOME}/bin/java" ]]; then
  echo "Installing Temurin 21 JRE..."
  case "${IC_ARCH}" in
    arm64) ADOPT_ARCH=aarch64 ;;
    x64) ADOPT_ARCH=x64 ;;
  esac
  mkdir -p "${JAVA_HOME}"
  curl -fsSL -o /tmp/jre.tgz \
    "https://api.adoptium.net/v3/binary/latest/21/ga/linux/${ADOPT_ARCH}/jre/hotspot/normal/eclipse?project=jdk"
  tar -xzf /tmp/jre.tgz -C "${JAVA_HOME}" --strip-components=1
  rm -f /tmp/jre.tgz
fi

if [[ ! -x "${SQLCL_BIN}" ]]; then
  echo "Installing SQLcl..."
  curl -fsSL -o /tmp/sqlcl.zip \
    https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
  unzip -q -o /tmp/sqlcl.zip -d /opt
  rm -f /tmp/sqlcl.zip
fi

finalize_install

echo "Oracle clients installed."
