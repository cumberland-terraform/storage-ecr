locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                          = {
        provision_key                   = var.rds.kms_key_arn == null
        provision_aurora                = strcontains(var.rds.engine, "aurora")
        is_windows                      = strcontains(var.rds.engine, "sqlserver")
    }

    ## RDS DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
        subnet_type                     = "Private"
    }
    
    ## CALCULATED PROPERTIES
    # Variables that store local calculations
    tags                                = merge({
        Application                     = var.rds.tags.application
        AutoBackup                      = var.rds.tags.auto_backup
        Builder                         = var.rds.tags.builder
        Schedule                        = var.rds.tags.schedule
        PrimaryContact                  = var.rds.tags.primary_contact
        Purpose                         = var.rds.tags.purpose
        NewBuild                        = var.rds.tags.new_build
        RhelRepo                        = var.rds.tags.rhel_repo
        Owner                           = var.rds.tags.owner
        "DB Engine"                     = local.platform_defaults.engine[var.rds.engine].tag
    }, module.platform.tags)


}