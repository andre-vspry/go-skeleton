package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	_ "cloud.google.com/go/firestore"
	_ "cloud.google.com/go/storage"
	_ "firebase.google.com/go/v4"
	_ "github.com/99designs/gqlgen/graphql/playground"
	_ "github.com/coreos/go-oidc/v3/oidc"
	_ "github.com/go-chi/chi/middleware"
	_ "github.com/go-chi/httplog"
	_ "github.com/golang-jwt/jwt/v4"
	_ "github.com/google/uuid"
	_ "github.com/gorilla/sessions"
	_ "github.com/kelseyhightower/envconfig"
	_ "github.com/microcosm-cc/bluemonday"
	_ "github.com/nyaruka/phonenumbers"
	_ "github.com/stretchr/testify/assert"
	_ "github.com/vektah/gqlparser/v2"
	_ "golang.org/x/oauth2"
	_ "google.golang.org/api"
	_ "google.golang.org/grpc"
)

const ()

var (
	CommitSHA = "development" // nolint: gochecknoglobals
	BuildID   = "development" // nolint: gochecknoglobals
)

type config struct{}

func (c *config) ListenAddress() string {
	return ""
}

func (c *config) Router() *chi.Mux {
	return chi.NewMux()
}

func main() {
	conf := &config{}
	var err error
	logger := zap.S()
	if err != nil {
		logger.Fatalf("error configuring: %v", err)
	}
	defer logger.Sync() // nolint: errcheck

	logger.Infow("version", "commit", CommitSHA, "build", BuildID)

	logger.Infow("starting server", "listen", conf.ListenAddress())
	logger.Fatal(http.ListenAndServe(conf.ListenAddress(), conf.Router()))
}
