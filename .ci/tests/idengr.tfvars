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
kms                                     = {
    alias_suffix                        = "DEVOPS"
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