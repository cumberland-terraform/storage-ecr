locals {
    ## ECR DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults               = {
        aws_managed_key_alias       = "alias/aws/ecr"
        scan_on_push                = true
        image_tag_mutability        = "IMMUTABLE"
    }

    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                      = {
        merge_policies              = var.ecr.additional_policies != null
        provision_key               = var.kms == null
        root_principal              = var.ecr.policy_principals == null
    }
    
    ## CALCULATED PROPERTIES
    #   Variables that change based on deployment configuration. 
    policy                          = local.conditions.merge_policies ? (
                                        data.aws_iam_policy_document.merged[0].json
                                    ) : data.aws_iam_policy_document.unmerged.json
                                    
    unmerged_policy_principals      = local.conditions.root_principal ? [
                                        "arn:aws:iam::${module.platform.aws.account_id}:root"
                                    ] : var.ecr.policy_principals

    kms_key                         = local.conditions.provision_key ? (
                                        module.kms[0].key
                                    ) : !var.kms.aws_managed ? (
                                        var.kms
                                    ) :  merge({
                                        # NOTE: the different objects on either side of the ? ternary operator
                                        #       have to match type, so hacking the types together.
                                        aws_managed = true
                                        alias_arn   = join("/", [
                                            module.platform.aws.arn.kms.key,
                                            local.platform_defaults.aws_managed_key_alias
                                        ])
                                    }, {
                                        id          = data.aws_kms_key.this[0].id
                                        arn         = data.aws_kms_key.this[0].arn
                                    })

    name                            = lower(join("-",[
                                        module.platform.prefix,
                                        var.ecr.suffix
                                    ]))

    tags                            = merge(var.ecr.tags, module.platform.tags)


}