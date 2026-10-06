#!/bin/bash

# Usage: createnv.sh <env_name>
ENV_NAME=$1
ENV_DIR="$HOME/.venvs/$ENV_NAME"

if [ -z "$ENV_NAME" ]; then
    echo "Usage: createnv.sh <env_name>"
    exit 1
fi

if [ -d "$ENV_DIR" ]; then
    echo "Virtual environment '$ENV_NAME' already exists."
    exit 1
fi

python3 -m venv "$ENV_DIR"
echo "Virtual environment '$ENV_NAME' created at $ENV_DIR."
echo "$ENV_NAME" > "$(pwd)/envname.txt"
