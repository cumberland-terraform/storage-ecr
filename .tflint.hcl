tflint {
  required_version  = ">= 0.50"
}

config {
//    format          = "json" not functional due to defect within tflint. TODO uncomment once fixed
    force           = true
    varfile         = [ "tests/idengr.tfvars" ]
}

plugin "aws" {
    enabled         = true
    version         = "0.32.0"
    source          = "github.com/terraform-linters/tflint-ruleset-aws"
}