variable "platform" {
  description                                   = "Platform metadata configuration object."
  type                                          = object({
    client                                      = string 
    environment                                 = string
  })
}


variable "ecr" {
  description                   = "ECR configuration object. See [README](https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-core-storage-ecr/browse) for detailed information about the permitted values for each field."
  type                          = object({
    suffix                      = string
    tags                        = map(string)
    additional_policies         = optional(list(string), [])
    policy_principals           = optional(list(string), null)
  })
}

variable "kms" {
  description                   = "KMS Key configuration object. If not provided, a key will be provisioned. An AWS managed key can be used by specifying `aws_managed = true`."
  type                          = object({
    aws_managed                 = optional(bool, false)
    id                          = optional(string, null)
    arn                         = optional(string, null)
    alias_arn                   = optional(string, null)
  })
  default                       = null
}