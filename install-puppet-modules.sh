#!/bin/bash

TGTDIR=extmodules

cd "`dirname $0`"

puppet module install --force puppetlabs-stdlib --target-dir $TGTDIR
puppet module install --force puppetlabs-mysql --target-dir $TGTDIR
puppet module install --force example42/puppi --target-dir $TGTDIR
puppet module install --force example42/postfix --target-dir $TGTDIR

