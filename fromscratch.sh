#!/bin/bash

set -e

cd "`dirname $0`"

vagrant up addonbuilder

vagrant destroy -f addonbuilder


./install-puppet-modules.sh
vagrant up alfresco
