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
        provision_key               = var.ecr.kms_key == null
        root_principal              = var.ecr.policy_principals == null
    }
    
    ## CALCULATED PROPERTIES
    #   Variables that change based on deployment configuration. 
    policy                          = local.conditions.merge_policies ? (
                                        data.aws_iam_policy_document.merged[0].json
                                    ) : data.aws_iam_policy_document.unmerged.json
                                    
    unmerged_policy_principals      = local.conditions.root_principal ? [
                                        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                                    ] : var.ecr.policy_principals

    kms_key                         = local.conditions.provision_key ? (
                                        module.kms[0].key
                                    ) : !var.ecr.kms_key.aws_managed ? (
                                        var.ecr.kms_key
                                    ) :  merge({
                                        # NOTE: the different objects on either side of the ? ternary operator
                                        #       have to match type, so hacking the types together.
                                        aws_managed = true
                                        alias_arn   = join("/", [
                                            module.platform.aws.arn.kms.key,
                                            local.rds_defaults.aws_managed_key_alias
                                        ])
                                    }, {
                                        id          = data.aws_kms_key.this[0].id
                                        arn         = data.aws_kms_key.this[0].arn
                                    })

    name                            = lower(join("-",[
                                        module.platform.prefixes.storage.ecr.repository,
                                        var.ecr.suffix
                                    ]))

    tags                            = merge({
        Name                        = local.name
        Builder                     = var.ecr.tags.builder
        Owner                       = var.ecr.tags.owner
        Purpose                     = var.ecr.tags.purpose
        PrimaryContact              = var.ecr.tags.primary_contact
    }, module.platform.tags)


}