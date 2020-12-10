#!/bin/sh

set_config_from_env() {
# Search through environment variables for NextCloud config items.  Variable
# names should be in the form of $NEXTCLOUD_CFG_SYSTEM_var_name_here where
# 'var_name_here' the variable name as required by `occ config:system:set`, (See
# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/occ_command.html#config-commands)
# in the correct (upper/lower) case, with underscores ('_') represented by
# double-underscores ('__'), and spaces (' ') represented by single underscores
# ('_'). E.g. NEXTCLOUD_CFG_SYSTEM_foo_Bar__BAZ translates to 'foo Bar_BAZ'

# Find env vars that specify NextCloud config items
env | grep ^NEXTCLOUD_CFG_SYSTEM_ | while read -r envvar
do
  echo "${envvar%=*}" | grep -q '_FILE$' && echo "Look! A File! $envvar"

  # Store value of parameter, and convert its key into a format suitable for
  # `./occ config:system:set`.
  value=${envvar#*=}
  param=${envvar%=*}
  param=${param#NEXTCLOUD_CFG_SYSTEM_}
  param=$(echo "$param" | sed 's/__/|/g;s/_/ /g;s/|/_/g')

  # Detect parameter type automatically based on its value
  if echo "$value" | grep -q '^[[:digit:]]*$'
  then
    ptype=integer
  elif echo "$value" | grep -q '^[[:digit:].]*$'
  then
    ptype=float
  elif echo "$value" | grep -q -e '^true$' -e '^false$'
  then
    ptype=boolean
  else
    ptype=string
  fi

  run_as "php /var/www/html/occ config:system:set $param --type $ptype --value \"$value\""
done
}

file_env NEXTCLOUD_CFG_SYSTEM_objectstore_arguments_key
file_env NEXTCLOUD_CFG_SYSTEM_objectstore_arguments_secret

set_config_from_env
