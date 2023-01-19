This application is a python flask web app that interacts with a postgres DB. This only deploy the flask app, not the DB.
Once the flask app is up, can use Vault approle to give it credentials.

Create some static creds:
vault kv get flaskweb1/flaskweb1

In Vault, enable auth approle
vault auth enable approle

Create policy on vault server:
path "flaskweb1/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
vault policy read flaskapp

Create new role:
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40
vault write auth/approle/role/my-role policies="flaskapp"

Get role ID:
vault read auth/approle/role/my-role/role-id

Get secret ID:
vault write -f auth/approle/role/my-role/secret-id

Get token, curl:
curl \
    --request POST \
    --data '{"role_id":"81876c04-4539-6164-6a9c-13a53195021d","secret_id":"5168804b-26fb-babb-e857-726f21a9184b"}' \
    http://52.89.205.142:8200/v1/auth/approle/login

Get token, cli:
vault write auth/approle/login \
    role_id=46c7da65-0984-f2eb-8c84-565073709cf2 \
    secret_id=edb91dea-dca7-8899-d4a7-36d9c811c9d4

Get data from kv, curl:
curl \
    --header "X-Vault-Token:s.VDpARZGxeG2AHBJkkxdI0mUR" \
    http://52.89.205.142:8200/v1/flaskweb1/data/flaskweb1

Get data from kv, cli:
vault kv get flaskweb1/flaskweb1

DB_KEYS=$(curl     --header "X-Vault-Token:s.AZAu6NHUo9AlL5gCro3vScUU"     http://52.89.205.142:8200/v1/flaskweb1/data/flaskweb1)
USERNAME=$(echo $DB_KEYS | jq -r '.data.data.username')
PASSWORD=$(echo $DB_KEYS | jq -r '.data.data.password')