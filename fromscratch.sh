#!/bin/bash

set -e

vagrant up addonbuilder

vagrant destroy -f addonbuilder

vagrant up alfresco
