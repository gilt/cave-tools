# cave-tools

A bunch of shell scripts to log into and manage alerts in Cave (http://www.cavellc.io) 

- Get a cave login token:
```
  cave_login.sh -e email -p password
       -e value, --email=value
             Cave user email address
       -p value, --password=value
             Cave user password
```
 If successful this scipt will set and the environment variable CAVE_TOKEN and print the token value

- Create a team alert:
```
  create_alert.sh -l token -o org -t team -c condition -d description -k apikey [-r period] [--disabled]
       -l value, --token=value
             Cave login token
       -o value, --org=value
             Cave organization
       -t value, --team=value
             Cave team
       -c value, --condition=value
             Alert condition
       -d value, --description=value
             Alert description
       -k value, --apikey=value
             Pagerduty API key
       -r value, --period=value
             Alert evaluation period in minutes. Default: 5 minutes
       --disabled
             Create the alert in disabled state
```

- Update (enable/disable) a team alert:
```
  update_alert.sh -l token -o org -t team -i id [--disable | --enable]
       -l value, --token=value
             Cave login token
       -o value, --org=value
             Cave organization
       -t value, --team=value
             Cave team
       -i value, --id=value
             Alert id
       --disable
             Disable the alert
       --enable
             Disable the alert
```

- Remove a team alert:
```
  delete_alert.sh -l token -o org -t team -i id
       -l value, --token=value
             Cave login token
       -o value, --org=value
             Cave organization
       -t value, --team=value
             Cave team
       -i value, --id=value
             Alert id
```
