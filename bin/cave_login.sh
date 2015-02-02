#!/bin/bash

function usage {
      echo ""
      echo "Usage: $0: -e email -p password"
      echo "       -e value, --email=value"
      echo "             Cave user email address"
      echo "       -p value, --password=value"
      echo "             Cave user password"
      echo ""
}

while [[ $# > 0 ]]
do
  case $1 in
    -h|--help|-\?)
      usage
      exit 0
      ;;
    -e)
      CAVE_EMAIL=$2
      shift
      ;;
    --email=*)
      CAVE_EMAIL="${i#*=}"
      ;;
    -p)
      CAVE_PASSWORD=$2
      shift
      ;;
    --password=*)
      CAVE_PASSWORD="${i#*=}"
      ;;
  esac
  shift
done

if [[ -z $CAVE_EMAIL ]]; then echo Missing email; usage; exit 1; fi
if [[ -z $CAVE_PASSWORD ]]; then echo Missing password; usage; exit 1; fi
export CAVE_CAVE_TOKEN=`curl -k -s -X POST -H "Content-Type: application/json" -d "{ \"email\": \"${CAVE_EMAIL}\", \"password\": \"${CAVE_PASSWORD}\" }" https://api.cavellc.io/users/login | jq -r ".token" 2>/dev/null`
if [ $? -ne 0 ]; then echo Invalid login; usage; exit 1; fi
echo $CAVE_CAVE_TOKEN
