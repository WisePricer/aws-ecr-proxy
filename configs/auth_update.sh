#!/bin/sh

nx_conf=/etc/nginx/nginx.conf

if [ -n "$AWS_ACCOUNT" ]; then
  # Error is > 1 value
  # Only 1 account is currently handled
  ecr_logins="--registry-ids ${AWS_ACCOUNT}"
fi

# update the auth token
auth=$(grep  X-Forwarded-User ${nx_conf} | awk '{print $4}'| uniq|tr -d "\n\r")
token=$(aws ecr get-login --no-include-email ${ecr_logins}| awk '{print $6}')
auth_n=$(echo AWS:${token}  | base64 |tr -d "[:space:]")

sed -i "s|${auth%??}|${auth_n}|g" ${nx_conf}
