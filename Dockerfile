FROM golang:1.16 as builder
ARG COMMIT_SHA BUILD_ID
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
# binary will be $(go env GOPATH)/bin/golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
  | sh -s -- -b $(go env GOPATH)/bin v1.45.2
COPY . .
RUN go test ./... -coverprofile=coverage.out
RUN golangci-lint run --out-format checkstyle >golangci-lint.out
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s -X main.CommitSHA=$COMMIT_SHA -X main.BuildID=$BUILD_ID" ./cmd/...

# https://bitbucket.org/sonarsource/sonarcloud-scan
FROM sonarsource/sonarcloud-scan:latest as scanner
ARG SONAR_TOKEN COMMIT_SHA BRANCH_NAME
WORKDIR /build
RUN sonar-scanner \
  -Dsonar.projectVersion="${COMMIT_SHA}" \
  -Dsonar.branch.name="${BRANCH_NAME}"

FROM gcr.io/distroless/static:nonroot as image
COPY --from=builder /build/server /app
ENTRYPOINT [ "/app" ]
