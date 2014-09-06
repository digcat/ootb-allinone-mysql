#!/bin/bash

cd "`dirname $0`"
set -ex


rm -rf addons-built
vagrant destroy -f addonbuilder

vagrant up addonbuilder

vagrant destroy -f addonbuilder

vagrant destroy -f alfresco

./install-puppet-modules.sh

vagrant up alfresco


