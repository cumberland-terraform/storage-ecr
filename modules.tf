module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/et/mdt-eter-platform.git"

  platform              = var.platform
}

module "kms" {
  count                 = local.conditions.provision_kms_key ? 1 : 0
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/et/mdt-eter-core-security-kms.git"

  kms                   = {
      alias_suffix      = "ECR-${var.ecr.suffix}"
  }
  platform              = var.platform
}