# Enterprise Terraform 
## Cumberland Cloud Platform
## AWS Core - ECR

This the storage module for Elastic Container Registry. This module will provision an ECR along with a resource-based policy allowing access to any provided prinicipals. If no additional principals are provided, the resource policy defaults to allow all IAM principals in the target accoutn access to the contents of the ECR.

### Usage

The bare minimum deployment can be achieved with the following configuration,

**providers.tf**

```hcl
provider "aws" {
	alias 					= "tenant"
	region					= "<region>"

	assume_role {
		role_arn 			= "arn:aws:iam::<tenant-account>:role/<role-name>"
	}
}
```

**modules.tf**

```hcl
module "ecr" {
	source          		        = "github.com/cumberland-terraform/storage-ecr.git"
	
        providers                               = {
                aws                             = aws.tenant
        }

	platform				= {
                client                          = "<client>"
                environment                     = "<environment>"
	}

	ecr				        = {
                suffix                          = "<suffix>"
        }
        
        kms 					= {
		aws_managed 		= true
	}
}
```

`platform` is a parameter for *all* **Cumberland Cloud** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the ``platform`` module documentation. 

## KMS Key Deployment Options

### 1: Module Provisioned Key

If the `var.kms` is set to `null` (default value), the module will attempt to provision its own KMS key. This means the role assumed by Terraform in the `provider` 

### 2: User Provided Key

If the user of the module prefers to use a pre-existing customer managed key, the `id`, `arn` and `alias_arn` of the `var.kms` variable must be passed in. This will override the provisioning of the KMS key inside of the module.

### 3: AWS Managed Key

If the user of the module prefers to use an AWS managed KMS key, the `var.kms.aws_managed` property must be set to `true`.
