#!/bin/bash

set -e

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CERTBOT_VERSION=$( awk -F= '$1 == "certbot"{ print $NF; }' "${SCRIPT_DIR}/requirements.txt" )
readonly VENV="certbot/venv"
readonly PYTHON="python"
readonly CERTBOT_ZIP_FILE="certbot.zip"
readonly CERTBOT_SITE_PACKAGES=${VENV}/Lib/site-packages

cd "${SCRIPT_DIR}"

${PYTHON} -m venv "${VENV}"
source "${VENV}/Scripts/activate"

pip install -r requirements.txt

pushd ${CERTBOT_SITE_PACKAGES}
    7z a -tzip ${SCRIPT_DIR}/certbot/${CERTBOT_ZIP_FILE} . -xr!__pycache__
popd

7z a -tzip "certbot/${CERTBOT_ZIP_FILE}" main.py
