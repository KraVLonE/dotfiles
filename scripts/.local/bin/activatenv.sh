#!/bin/bash

# Usage: activatevenv.sh <env_name>
ENV_NAME=$1
ENV_DIR="$HOME/.venvs/$ENV_NAME"

if [ -z "$ENV_NAME" ]; then
    echo "Usage: activatevenv.sh <env_name>"
    exit 1
fi

if [ ! -d "$ENV_DIR" ]; then
    echo "Virtual environment '$ENV_NAME' does not exist."
    exit 1
fi

source $ENV_DIR/bin/activate
