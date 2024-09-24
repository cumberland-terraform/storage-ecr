variable "platform" {
  description                   = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
  type                          = object({
    aws_region                  = string 
    account                     = string
    acct_env                    = string
    agency                      = string
    program                     = string
    app                         = string
    app_env                     = string
    pca                         = string
  })
}

variable "ecr" {
  description                   = "ECR configuration object. See [README](https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-core-storage-ecr/browse) for detailed information about the permitted values for each field."
  type                          = object({
    suffix                      = string
    tags                        = object({
      builder                   = string
      primary_contact           = string
      owner                     = string
      purpose                   = string
    })
    policy_principals           = optional(list(string), null)
    additional_policies         = optional(list(string), [])
    policy_principals           = optional(list(string), null)
    kms_key                     = optional(object({
      id                        = string
      arn                       = string
      alias_arn                 = string
    }), null)
  })
}