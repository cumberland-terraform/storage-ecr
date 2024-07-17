variable "platform" {
  description                   = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/ET/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
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
  description                   = "ECR configuration object. See [README]() for detailed infromation about the permitted values for each field."
  type                          = object({
    suffix                      = string
    additional_policies         = optional(list(string), [])
    mutability                  = optional(string, "IMMUTABLE")
    kms_key                     = optional(object({
      id                        = string
      arn                       = string
    }))
  })
}