# Setup Outgoing SMTP Server:

- https://ap-southeast-1.console.aws.amazon.com/ses/home?region=ap-southeast-1#smtp-settings:

- then to the SMTP user

```json
"Statement": [{"Effect":"Allow","Action":"ses:SendRawEmail","Resource":"*"}]

```

- UserID: AKIARJS42R6LCO3NXLV4