#!/bin/bash

cd "`dirname $0`"

#mkdir -p /etc/puppet/modules;
puppet module install --force puppetlabs-stdlib --target-dir modules
puppet module install --force puppetlabs-mysql --target-dir modules
puppet module install --force example42/puppi --target-dir modules
puppet module install --force example42/postfix --target-dir modules

