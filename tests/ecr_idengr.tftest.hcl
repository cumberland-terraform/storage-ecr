provider "aws" {
    region                  = "us-east-1"
    assume_role {
        role_arn            = "arn:aws:iam::798223307841:role/IMR-MDT-TERA-EC2"
    }
}

mock_provider "aws" {
  alias = "fake"
}

variables {
    platform                                = {
        aws_region                          = "US EAST 1"
        account                             = "ID ENGINEERING"
        acct_env                            = "NON-PRODUCTION 1"
        agency                              = "MARYLAND TOTAL HUMAN-SERVICES INTEGRATED NETWORK"
        app                                 = "TERRAFORM ENTERPRISE"
        program                             = "MDTHINK SHARED PLATFORM"
        app_env                             = "NON PRODUCTION"
        pca                                 = "FE110"
    }
    ecr                                     = {
        suffix                              = "ETER"
        tags                                = {
            purpose                         = "Mock Purpose"
            builder                         = "Mock Builder"
            primary_contact                 = "Mock Primary Contact"
            owner                           = "Mock Owner"
        }
    }
}


run "validate_ecr_name"{
    providers = {
        aws = aws
    }
    command = plan
    assert {
        condition = aws_ecr_repository.this.name == "ECR-ETER"
        error_message = "Expected security group name did not generate from provided perameters. Expected: ECR-ETER vs Actual: ${aws_ecr_repository.this.name}"
    }

}