#!/bin/bash

function usage {
      echo ""
      echo "Usage: $0: -l token -t team -i id"
      echo "       -l value, --token=value"
      echo "             Cave login token"
      echo "       -o value, --org=value"
      echo "             Cave organization"
      echo "       -t value, --team=value"
      echo "             Cave team"
      echo "       -i value, --id=value"
      echo "             Alert id"
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
      TOKEN=$2
      shift
      ;;
    --token=*)
      TOKEN="${i#*=}"
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
    *)
      echo Unknown argument "$1"; usage; exit 1
  esac
  shift
done

if [[ -z $TOKEN ]]; then echo Missing login token; usage; exit 1; fi
if [[ -z $CAVE_ORG ]]; then echo Missing org; usage; exit 1; fi
if [[ -z $CAVE_TEAM ]]; then echo Missing team; usage; exit 1; fi
if [[ -z $ALERT_ID ]]; then echo Missing alert id; usage; exit 1; fi

curl -s -X DELETE \
  -u $TOKEN: \
  https://api.cavellc.io/organizations/${CAVE_ORG}/teams/${CAVE_TEAM}/alerts/${ALERT_ID}

if [ $? -ne 0 ]; then echo ${ALERT_ID} failed; exit 1; else echo ${ALERT_ID} ok; fi
