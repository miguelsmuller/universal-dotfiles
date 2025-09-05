
# Exemplo tela de login

http://localhost:8080/realms/master/protocol/openid-connect/auth?client_id=test_client&response_type=code&redirect_uri=http://localhost:8080&scope=openid

Redirect tem que bater com oque esta configurado no realm


# Request a token

REALM=realms/master
ISSUER="http://localhost:8080/$REALM/"
CLIENT=test_client

curl -s -X POST "$ISSUER/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=$CLIENT" \
  -d "username=admin" \
  -d "password=admin" 


# Decoded Header

{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "QngNx-lLJUbdLDdgXz_qsybnHf23bjkAVm0zAnkMp2s"
}

# Decoded Payload

{
  "exp": 1757090126,
  "iat": 1757090066,
  "jti": "3d19c39f-7262-4f05-851b-19fcacd4efdf",
  "iss": "http://localhost:8080/realms/master",
  "aud": [
    "master-realm",
    "account"
  ],
  "sub": "ba0e3494-94dc-4c33-a1c1-740e5a4eea73",
  "typ": "Bearer",
  "azp": "test_client",
  "session_state": "81f9ab8b-dc67-4e9e-98a3-c6aa366c9522",
  "acr": "1",
  "allowed-origins": [
    "*"
  ],
  "realm_access": {
    "roles": [
      "create-realm",
      "default-roles-master",
      "offline_access",
      "admin",
      "uma_authorization"
    ]
  },
  "resource_access": {
    "master-realm": {
      "roles": [
        "view-realm",
        "view-identity-providers",
        "manage-identity-providers",
        "impersonation",
        "create-client",
        "manage-users",
        "query-realms",
        "view-authorization",
        "query-clients",
        "query-users",
        "manage-events",
        "manage-realm",
        "view-events",
        "view-users",
        "view-clients",
        "manage-authorization",
        "manage-clients",
        "query-groups"
      ]
    },
    "account": {
      "roles": [
        "manage-account",
        "manage-account-links",
        "view-profile"
      ]
    }
  },
  "scope": "profile email",
  "sid": "81f9ab8b-dc67-4e9e-98a3-c6aa366c9522",
  "email_verified": false,
  "preferred_username": "admin"
}
