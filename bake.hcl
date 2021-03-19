variable "push" {
  default = "false"
}

variable "ci_tag" {
  default = "zencargo/ocean"
}

variable "production_tag" {
  default = "zencargo/ocean"
}

variable "application_version" {}
variable "node_version" {}
variable "ruby_version" {}
variable "bundler_version" {}

group "default" {
  targets = [
    "apollo-service-push",
    "cypress",
    "e2e-test-server",
    "production",
    "test",
    "upload-assets",
    "upload-elastic-beanstalk-application-version",
  ]
}

target "base" {
  context    = "."
  dockerfile = "tmp/Dockerfile"

  pull = true

  args = {
    APPLICATION_VERSION = application_version
    NODE_VERSION        = node_version
    RUBY_VERSION        = ruby_version
    BUNDLER_VERSION     = bundler_version
  }

  secret = [
    "id=bundle_config,src=tmp/secrets/bundle_config",
    "id=npmrc,src=tmp/secrets/npmrc",
  ]

  output = ["type=${push == "true" ? "registry" : "docker"}"]
}

target "apollo-service-push" {
  inherits = ["base"]

  target = "apollo-service-push"
  tags   = ["${production_tag}-apollo-service-push"]
}

target "cypress" {
  inherits = ["base"]

  target = "cypress"
  tags   = ["${ci_tag}-cypress"]
}

target "e2e-test-server" {
  inherits = ["base"]

  target = "e2e-test-server"
  tags   = ["${ci_tag}-e2e-test-server"]
}

target "production" {
  inherits = ["base"]

  target = "production"
  tags   = [production_tag]
}

target "test" {
  inherits = ["base"]

  target = "test"
  tags   = ["${ci_tag}-test"]
}

target "upload-assets" {
  inherits = ["base"]

  target = "upload-assets"
  tags   = ["${ci_tag}-upload-assets"]
}

target "upload-elastic-beanstalk-application-version" {
  inherits = ["base"]

  target = "upload-elastic-beanstalk-application-version"
  tags   = ["${ci_tag}-upload-elastic-beanstalk-application-version"]
}
