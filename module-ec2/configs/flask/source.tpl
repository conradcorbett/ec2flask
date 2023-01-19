  {{ with secret "database/creds/my-role" }}
mysql_user: '{{ .Data.username }}'
mysql_password: '{{ .Data.password }}'
mysql_host: '34.221.253.137'
mysql_db: 'users'
  {{ end }}