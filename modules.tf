module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-platform.git"

  platform              = merge({
    subnet_type         = local.platform_defaults.subnet_type
  }, var.platform)
}
