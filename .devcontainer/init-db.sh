#!/usr/bin/env bash
set -euo pipefail

CONNECT="${ORACLE_CONNECT:-media/media@//127.0.0.1:1521/FREEPDB1}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SEED_FILES=(
  ddl.sql
  dml-media-types.sql
  dml-medias.sql
  dml-users.sql
  dml-users-medias.sql
)

wait_for_database() {
  local attempt
  for attempt in $(seq 1 120); do
    if printf 'SELECT 1 FROM dual;\nexit\n' | sqlplus -S "$CONNECT" >/dev/null 2>&1; then
      return 0
    fi
    sleep 5
  done
  echo "Oracle did not accept connections in time." >&2
  return 1
}

schema_present() {
  local count
  count="$(
    printf '%s\n' \
      'SET HEADING OFF' \
      'SET FEEDBACK OFF' \
      'SET PAGESIZE 0' \
      "SELECT COUNT(*) FROM user_tables WHERE table_name = 'USERS';" \
      'exit' \
    | sqlplus -S "$CONNECT" \
    | tr -d '[:space:]'
  )"
  [[ "${count:-0}" != "0" ]]
}

echo "Waiting for Oracle to accept connections..."
wait_for_database

if schema_present; then
  echo "Schema already present; skipping ddl/dml (drop volume to reset)."
  exit 0
fi

cd "$ROOT"
for file in "${SEED_FILES[@]}"; do
  echo "Running ${file}..."
  sqlplus -S "$CONNECT" @"${file}"
done

echo "Database is ready (schema + seed data)."
