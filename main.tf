provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    hostname = "console.tfe.aws.bradandmarsha.com"
    organization = "brad-test"

    workspaces {
      name = "bw-tfe-testing"
    }
  }
}

data "aws_route53_zone" "parent_zone" {
  name         = "aws.bradandmarsha.com."
}

resource "aws_route53_zone" "zone" {
  name              = "foobar.aws.bradandmarsha.com"
}

resource "aws_route53_record" "delegation" {
  allow_overwrite = true
  name            = "foobar"
  ttl             = 300
  type            = "NS"
  zone_id         = data.aws_route53_zone.parent_zone.id
  records         = aws_route53_zone.zone.name_servers
}
