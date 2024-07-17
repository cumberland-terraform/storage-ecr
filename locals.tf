locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                      = {
        merge_policies              = var.ecr.additional_policies != null
        provision_key               = var.ecr.kms_key == null
        root_principal              = var.ecr.policy_principals == null
    }

    policy                          = local.conditions.merge_policies ? (
                                        data.aws_iam_policy_document.merged[0]
                                    ) : data.aws_iam_policy_document.unmerged
                                    
    unmerged_policy_principals      = local.conditions.root_principal ? [
                                        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                                    ] : var.ecr.policy_principals

    kms_key_arn                     = local.conditions.provision_kms_key ? (
                                        module.kms[0].key.arn
                                    ) : var.ec2.kms_key.arn

    name                            = upper("${module.platform.prefixes.storage.ecr.repository}-${var.ecr.suffix}")
    ## RDS DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
    }
    
    ## CALCULATED PROPERTIES
    # Variables that store local calculations
    tags                                = merge({

    }, module.platform.tags)


}