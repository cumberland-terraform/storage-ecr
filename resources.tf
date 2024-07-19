resource "aws_ecr_repository" "this" {
    name                    = local.name
    image_tag_mutability    = var.repository.mutability

    image_scanning_configuration {
        scan_on_push        = local.platform_defaults.scan_on_push
    }

    encryption_configuration {
        encryption_type     = "KMS"
        kms_key             = local.kms_key_arn
    }
}

resource "aws_ecr_repository_policy" "this" {
  repository                = aws_ecr_repository.this.name
  policy                    = local.policy
}