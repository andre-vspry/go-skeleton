module github.com/andre-vspry/go-template

go 1.16

require (
	cloud.google.com/go/firestore v1.6.1
	cloud.google.com/go/storage v1.22.0
	firebase.google.com/go/v4 v4.8.0
	github.com/99designs/gqlgen v0.17.4
	github.com/coreos/go-oidc/v3 v3.1.0
	github.com/go-chi/chi v1.5.4
	github.com/go-chi/chi/v5 v5.0.7
	github.com/go-chi/httplog v0.2.4
	github.com/golang-jwt/jwt/v4 v4.4.1
	github.com/google/uuid v1.3.0
	github.com/gorilla/sessions v1.2.1
	github.com/kelseyhightower/envconfig v1.4.0
	github.com/microcosm-cc/bluemonday v1.0.18
	github.com/nyaruka/phonenumbers v1.0.74
	github.com/stretchr/testify v1.7.1
	github.com/vektah/gqlparser/v2 v2.4.2
	go.uber.org/zap v1.21.0
	golang.org/x/oauth2 v0.0.0-20220411215720-9780585627b5
	google.golang.org/api v0.76.0
	google.golang.org/grpc v1.46.0
	gopkg.in/square/go-jose.v2 v2.6.0 // indirect
)

// replace (
// 	golang.org/x/crypto => golang.org/x/crypto v0.0.0-20220315160706-3147a52a75dd
// 	golang.org/x/net => golang.org/x/net v0.0.0-20220225172249-27dd8689420f
// 	golang.org/x/text => golang.org/x/text v0.3.7
// 	gopkg.in/yaml.v2 => gopkg.in/yaml.v2 v2.4.0
// )
