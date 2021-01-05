#!/bin/bash

name=$(basename $PWD)

mkdir tests

# Python virtual environment setup

echo "Creating virtual environment '${name}'"
python3.8 -m venv --prompt $name __venv__
# source __venv__/bin/activate  # this won't work as each cmd is in it's own shell

# Dev and Prod requirements

mkdir requirements
cat > ./requirements/base.in <<EOF
loguru
EOF

cat > ./requirements/dev.in <<EOF
-r base.in
setuptools
wheel
pylint
black
pytest
python-dotenv
EOF

cat > ./.env <<EOF
EOF

# Basic python starting point

cat > ./main.py <<EOF
import argparse
import sys

from loguru import logger

# See: https://github.com/Delgan/loguru
logger.add(sys.stderr, format="{time} {level} {message}", filter="my_module", level="INFO")

def main(config):
    logger.debug("Lets get this party started {}!", config)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("config", help="Path to config file")
    args = parser.parse_args()

    main(**vars(args))

EOF

# Standard Makefile

cat > ./Makefile <<EOF
.PHONY: tests update requirements install

base:
    pip install pip-tools wheel setuptools


requirements:
	# Compile locked requirements files
	pip-compile --output-file=requirements.txt requirements/base.in
	pip-compile --output-file=requirements.dev.txt requirements/dev.in

install:
	pip install -r requirements.dev.txt

setup: base requirements install

update: requirements install

tests:
	python -m pytest
EOF

cat > Readme.md <<EOF
# $name

## Setup

Create a virtual environment in python3, then activate it and install dependencies

    python3.8 -m venv --prompt alex-is-my-daddy __venv__
    source __venv__/bin/activate
    make install
EOF

cat > .editorconfig <<EOF
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = true

[*.{yml,yaml,json}]
indent_style = space
indent_size = 2

[*.py]
charset = utf-8
indent_style = space
indent_size = 4

[Makefile]
indent_style = tab
EOF

# Git setup
curl https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore --output .gitignore
cat >> ./.gitignore <<EOF
__venv__/
.vscode/
EOF

git init
git add .
git commit -m "Initial commit of $1"

make setup

echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
echo -e "DON'T FORGET TO ACTIVATE THE VENV\n"
echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
echo -e "source __venv__/bin/activate"
