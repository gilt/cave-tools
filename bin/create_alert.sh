#!/bin/bash

function usage {
      echo ""
      echo "Usage: $0: -l token -o org -t team -c condition -d description -k apikey [-r period] [--disabled]"
      echo "       -l value, --token=value"
      echo "             Cave login token"
      echo "       -o value, --org=value"
      echo "             Cave organization"
      echo "       -t value, --team=value"
      echo "             Cave team"
      echo "       -c value, --condition=value"
      echo "             Alert condition"
      echo "       -d value, --description=value"
      echo "             Alert description"
      echo "       -k value, --apikey=value"
      echo "             Pagerduty API key"
      echo "       -r value, --period=value"
      echo "             Alert evaluation period in minutes. Default: 5 minutes"
      echo "       --disabled"
      echo "             Create the alert in disabled state"
      echo ""
}

ALERT_PERIOD=5m
ALERT_ENABLED=true

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
    -c)
      ALERT_CONDITION=$2
      shift
      ;;
    --condition=*)
      ALERT_CONDITION="${i#*=}"
      ;;
    -d)
      ALERT_DESCRIPTION=$2
      shift
      ;;
    --description=*)
      ALERT_DESCRIPTION="${i#*=}"
      ;;
    -k)
      PAGERDUTY_KEY=$2
      shift
      ;;
    --apikey=*)
      PAGERDUTY_KEY="${i#*=}"
      ;;
    -r)
      ALERT_PERIOD=$2
      shift
      ;;
    --period=*)
      ALERT_PERIOD="${i#*=}"
      ;;
    --disabled)
      ALERT_ENABLED=false
      ;;
    *)
      echo Unknown argument "$1"; usage; exit 1
  esac
  shift
done

if [[ -z $CAVE_TOKEN ]]; then echo Missing login token; usage; exit 1; fi
if [[ -z $CAVE_ORG ]]; then echo Missing org; usage; exit 1; fi
if [[ -z $CAVE_TEAM ]]; then echo Missing team; usage; exit 1; fi
if [[ -z $ALERT_CONDITION ]]; then echo Missing condition; usage; exit 1; fi
if [[ -z $ALERT_DESCRIPTION ]]; then echo Missing description; usage; exit 1; fi
if [[ -z $PAGERDUTY_KEY ]]; then echo Missing pagerduty api key; usage; exit 1; fi


curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -u $CAVE_TOKEN: \
  -d "
  {
    \"description\": \"${ALERT_DESCRIPTION}\",
    \"enabled\": ${ALERT_ENABLED},
    \"period\": \"${ALERT_PERIOD}\",
    \"condition\": \"${ALERT_CONDITION}\",
    \"routing\": {
      \"pagerduty_service_api_key\": \"${PAGERDUTY_KEY}\"
    }
  }" \
  https://api.cavellc.io/organizations/${CAVE_ORG}/teams/${CAVE_TEAM}/alerts  | jq -r ".id" | xargs echo
