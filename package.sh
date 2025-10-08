#!/bin/bash

set -e

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CERTBOT_VERSION=$( awk -F= '$1 == "certbot"{ print $NF; }' "${SCRIPT_DIR}/requirements.txt" )
VENV="certbot/venv"
readonly PYTHON="python"
readonly CERTBOT_ZIP_FILE="certbot-lambda.zip"
CERTBOT_SITE_PACKAGES=${VENV}/lib/site-packages

readonly CI=$CI

cd "${SCRIPT_DIR}"

if [ "${CI}" = true ]; then
    echo "Running in CI mode"
    ${PYTHON} -m venv $VENV
    VENV=$GITHUB_WORKSPACE/$VENV
    source $VENV/bin/activate
    CERTBOT_SITE_PACKAGES=${VENV}/lib/python3.11/site-packages
else
    echo "Running in local mode"
    ${PYTHON} -m venv "${VENV}"
    source "${VENV}/Scripts/activate"
fi

pip install -r requirements.txt

pushd ${CERTBOT_SITE_PACKAGES}
    7z a -tzip ${SCRIPT_DIR}/certbot/${CERTBOT_ZIP_FILE} . -xr!__pycache__
popd

7z a -tzip "certbot/${CERTBOT_ZIP_FILE}" main.py
