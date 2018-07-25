#!/bin/env bash

pip install virtualenv
pip install virtualenvwrapper
grep -q virtualenvwrapper /etc/profile
[ ! $? -eq 0 ] && cat>>/etc/profile<<EOF

export VIRTUALENV_USE_DISTRIBUTE=1
export WORKON_HOME=\$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=\$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
EOF
source /etc/profile
#mkvirtualenv aardvark
