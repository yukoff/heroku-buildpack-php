#!/bin/bash

YAML_VERSION=2.0.0
DEP_URL=https://pecl.php.net/get/yaml-${YAML_VERSION}.tgz
YAML_DIR=yaml-${YAML_VERSION}
CWD=$(pwd)

echo "-----> Building YAML PHP extension..."

mkdir -p $build_dir/.heroku/php-ext-yaml
ln -s $build_dir/.heroku/php-ext-yaml /app/.heroku/php-ext-yaml

curl_retry_on_18 --fail --silent --location -o $build_dir/.heroku/yaml-${YAML_VERSION}.tgz "${DEP_URL}" || error "Failed to download YAML PHP extension sources"
tar -xzf $build_dir/.heroku/yaml-${YAML_VERSION}.tgz -C $build_dir/.heroku/php-ext-yaml
rm $build_dir/.heroku/yaml-${YAML_VERSION}.tgz
if [ ! -d "$build_dir/.heroku/php-ext-yaml/${YAML_DIR}" ]; then
  echo "       Failed to find YAML extension directory '$build_dir/.heroku/php-ext-yaml/${YAML_DIR}'."
  exit 1
fi

cd "$build_dir/.heroku/php-ext-yaml/${YAML_DIR}"
phpize
export CFLAGS="-O2 -g"
export PATH=${build_dir}/.heroku/php/bin:$PATH
./configure --with-yaml
make
make install

cd ${CWD}
