#!/bin/bash

function usage {
      echo ""
      echo "Usage: $0: -l token -o org -t team -i id [--disable | --enable]"
      echo "       -l value, --token=value"
      echo "             Cave login token"
      echo "       -o value, --org=value"
      echo "             Cave organization"
      echo "       -t value, --team=value"
      echo "             Cave team"
      echo "       -i value, --id=value"
      echo "             Alert id"
      echo "       --disable"
      echo "             Disable the alert"
      echo "       --enable"
      echo "             Disable the alert"
      echo ""
}

while [[ $# > 0 ]]
do
  case $1 in
    -h|--help|-\?)
      usage
      exit 0
      ;;
    -l)
      CAVE_TOKEN=$2
      shift
      ;;
    --token=*)
      CAVE_TOKEN="${i#*=}"
      ;;
    -o)
      CAVE_ORG=$2
      shift
      ;;
    --org=*)
      CAVE_ORG="${i#*=}"
      ;;
    -t)
      CAVE_TEAM=$2
      shift
      ;;
    --team=*)
      CAVE_TEAM="${i#*=}"
      ;;
    -i)
      ALERT_ID=$2
      shift
      ;;
    --id=*)
      ALERT_ID="${i#*=}"
      ;;
    --disable)
      ALERT_ENABLED=false
      ;;
    --enable)
      ALERT_ENABLED=true
      ;;
    *)
      echo Unknown argument "$1"; usage; exit 1
  esac
  shift
done

if [[ -z $CAVE_TOKEN ]]; then echo Missing login token; usage; exit 1; fi
if [[ -z $CAVE_ORG ]]; then echo Missing org; usage; exit 1; fi
if [[ -z $CAVE_TEAM ]]; then echo Missing team; usage; exit 1; fi
if [[ -z $ALERT_ID ]]; then echo Missing alert id; usage; exit 1; fi
if [[ -z $ALERT_ENABLED ]]; then echo Missing enable or disable; usage; exit 1; fi


curl -s -X PATCH \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -u $CAVE_TOKEN: \
  -d "{ \"enabled\": ${ALERT_ENABLED} }" \
  https://api.cavellc.io/organizations/${CAVE_ORG}/teams/${CAVE_TEAM}/alerts/${ALERT_ID}
