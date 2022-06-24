package main

import (
	"flag"
	"fmt"
	"net"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/kelseyhightower/envconfig"
	"go.uber.org/zap"
)

const (
	APP = "go_skeleton"
)

var (
	CommitSHA = "development" // nolint: gochecknoglobals
	BuildID   = "development" // nolint: gochecknoglobals
)

type Config struct {
	Username string `required:"true"`
	Password string `required:"true"`
	Port     uint16 `default:"8080"`
	Address  string `default:"127.0.0.1"`
	mux      *chi.Mux
	log      *zap.Logger
}

func (c *Config) ListenAddress() string {
	const base10 = 10

	return net.JoinHostPort(c.Address, strconv.FormatUint(uint64(c.Port), base10))
}

func NewConfig() (*Config, error) {
	logger, err := zap.NewDevelopment()
	if err != nil {
		return nil, fmt.Errorf("could not create a zap development logger: %w", err)
	}

	config := new(Config)
	config.mux = chi.NewMux()
	config.log = logger

	flag.Usage = func() {
		if err := envconfig.Usage(APP, config); err != nil {
			return
		}
	}
	flag.Parse()

	err = envconfig.Process(APP, config)
	if err != nil {
		if err := envconfig.Usage(APP, config); err != nil {
			return nil, fmt.Errorf("could not produce usage: %w", err)
		}

		return nil, fmt.Errorf("environment configuration error: %w", err)
	}

	return config, nil
}

func (c *Config) Sync() error {
	if err := c.log.Sync(); err != nil {
		return fmt.Errorf("could not sync log: %w", err)
	}

	return nil
}

func (c *Config) Router() *chi.Mux {
	return c.mux
}

func main() {
	config, err := NewConfig()
	if err != nil {
		panic(err)
	}
	defer config.Sync() // nolint: errcheck

	log := config.log.Sugar()
	log.Infow("version", "commit", CommitSHA, "build", BuildID)
	log.Infow("starting server", "listen", config.ListenAddress())
	log.Error(http.ListenAndServe(config.ListenAddress(), config.Router()))
}
