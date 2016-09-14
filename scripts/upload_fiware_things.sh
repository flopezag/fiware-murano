#!/bin/bash -ex
# Copyright 2016 Telefónica Investigación y Desarrollo, S.A.U
#
# This file is part of FIWARE project.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at:
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#
# For those usages not covered by the Apache version 2.0 License please
# contact with opensource@tid.es
#


# Installing murano-client

virtualenv ENV
. ENV/bin/activate

pip install -e git+https://github.com/openstack/python-muranoclient#egg=Package

rm -rf meta
git clone https://github.com/openstack/murano meta
cd meta
git filter-branch --prune-empty --subdirectory-filter meta HEAD
cd ..
cp -rf ./../docker/meta/* meta
echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> meta/io.murano/manifest.yaml
cd  ./meta/io.murano
zip -r ./../../io.murano.zip *
cd ./../../
murano package-import --is-public --exists-action u io.murano.zip
