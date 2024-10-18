data "aws_iam_policy_document" "merged" {
    count                           = local.conditions.merge_policies ? 1 : 0

    source_policy_documents         = concat(
                                        [ data.aws_iam_policy_document.unmerged.json ],
                                        var.ecr.additional_policies
                                    )
}

data "aws_iam_policy_document" "unmerged" {

    statement {
        sid                         = "EnableAccess"
        effect                      = "Allow"
        actions                     = [
                                        "ecr:BatchGetImage",
                                        "ecr:BatchCheckLayerAvailability",
                                        "ecr:CompleteLayerUpload",
                                        "ecr:Get*",
                                        "ecr:Describe*",
                                        "ecr:InitiateLayerUpload",
                                        "ecr:List*",
                                        "ecr:PutImage",
                                        "ecr:UploadLayerPart"
                                    ]
        
        principals {
            type                    = "AWS"
            identifiers             = local.unmerged_policy_principals
        }
    }
}

data "aws_kms_key" "this" {
    count                           = var.ecr.kms_key.aws_managed ? 1 : 0

    key_id                          = local.platform_defaults.aws_managed_key_alias
}