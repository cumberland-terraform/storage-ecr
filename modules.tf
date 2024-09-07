module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-platform.git?ref=v1.0.13&depth=1"

  platform              = var.platform
  hydration             = {
    vpc_query           = false
    subnets_query       = false
    dmem_sg_query       = false
    rhel_sg_query       = false
    eks_ami_query       = false
  }
}

module "kms" {
  count                 = local.conditions.provision_kms_key ? 1 : 0
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-core-security-kms.git?ref=v1.0.2&depth=1"

  kms                   = {
      alias_suffix      = join("-", ["ECR", var.ecr.suffix ])
  }
  platform              = var.platform
}