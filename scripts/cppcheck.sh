#!/usr/bin/env bash

# Qt-aware Cppcheck runner for this repository.
# - Scans src/ and tests/
# - Works without having Qt installed by neutralizing Qt macros
# - Writes human-readable and XML reports into reports/
# - Exits non-zero on findings

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
REPORT_DIR="${ROOT_DIR}/reports"
mkdir -p "${REPORT_DIR}"

CPPCHECK_BIN=${CPPCHECK_BIN:-cppcheck}
JOBS=${JOBS:-$(command -v nproc >/dev/null 2>&1 && nproc || echo 2)}

# Common excludes (build trees, VCS, reports)
EXCLUDES=(
  -i "${ROOT_DIR}/.git"
  -i "${ROOT_DIR}/build"
  -i "${ROOT_DIR}/build-*"
  -i "${ROOT_DIR}/reports"
  # Exclude Qt autogen and generated sources
  -i "${ROOT_DIR}/**/_autogen/**"
  -i "${ROOT_DIR}/**/mocs_compilation.cpp"
  -i "${ROOT_DIR}/**/moc_*.cpp"
  -i "${ROOT_DIR}/**/qrc_*.cpp"
)

# User-provided Qt macro neutralizations and useful options
DEFINES=(
  "-Dslots="
  "-Dsignals=public"
  "-DQ_OBJECT="
  "-DQ_SIGNALS=public"
  "-DQ_SLOTS="
  "-DQ_EMIT="
  "-DQ_PROPERTY(x)="
  "-DQ_NULLPTR=nullptr"
  "-DQQML_EXPORT="
  "-DQ_MOC_INCLUDE"
  "-DMAKE_GETTER_NAME(name)=get##name"
  "-DQML_WRITABLE_AUTO_PROPERTY(type,name)="
  "-DQML_READONLY_AUTO_PROPERTY(type,name)="
  "-DQML_CONSTANT_AUTO_PROPERTY(type,name)="
)

SUPPRESS=(
  --suppress=unusedFunction
  --suppress=missingIncludeSystem
)

# Build the command
CMD=(
  "${CPPCHECK_BIN}"
  --enable=all
  --error-exitcode=1
  --inline-suppr
  --library=qt
  --std=c++17
  --language=c++
  --template=gcc
  -j "${JOBS}"
  --quiet
  --force
  --output-file="${REPORT_DIR}/cppcheck.txt"
  --xml
)

# Append arrays
CMD+=("${DEFINES[@]}")
CMD+=("${SUPPRESS[@]}")
CMD+=("${EXCLUDES[@]}")

# Include roots to help cppcheck find headers within the project
CMD+=(
  -I "${ROOT_DIR}/src"
  -I "${ROOT_DIR}/src/QtSuperMacros"
)

# Targets to analyze (allow override via args)
TARGETS=("${ROOT_DIR}/src" "${ROOT_DIR}/tests")
if [[ $# -gt 0 ]]; then
  TARGETS=("$@")
fi

CMD+=("${TARGETS[@]}")

echo "Running: ${CMD[*]} (XML to ${REPORT_DIR}/cppcheck.xml)" >&2
"${CMD[@]}" 2>"${REPORT_DIR}/cppcheck.xml"

echo "Cppcheck completed. Reports written to: ${REPORT_DIR}/cppcheck.txt and cppcheck.xml" >&2
