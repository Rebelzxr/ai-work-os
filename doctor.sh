#!/usr/bin/env bash
# Thin wrapper: the real script is scripts/doctor.sh.
# Kept at the repo root too because the top-level ./setup.sh and ./install-skills.sh
# convention means people look for ./doctor.sh first.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/scripts/doctor.sh" "$@"
