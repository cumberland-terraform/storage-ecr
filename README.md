# Enterprise Terraform 
## AWS Core Storage Elastic Container Registry
### Overview

This is the core module for **MDTHINK Platform** ECR repositories. This module will provision an ECR and a resource based policy. By default, the policy will allow IAM principals in the target account access to read from the repository. To override the default access list, see **Parameters** below.

### Usage

The bare minimum deployment can be achieved with the following configuration,

**providers.tf**

```hcl
provider "aws" {
	alias 					= "tenant"
	region					= "<region>"

	assume_role {
		role_arn 			= "arn:aws:iam::<tenant-account>:role/IMR-MDT-TERA-EC2"
	}
}
```

**modules.tf**

```hcl
module "ecr" {
	source          		        = "ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-aws-core-storage-ecr.git?ref=v1.0.0"
	
        providers                               = {
                aws                             = aws.tenant
        }

	platform				= {
                aws_region                      = "<region-name>"
                account                         = "<account-name>"
                acct_env                        = "<account-environment>"
                agency                          = "<agency>"
                program                         = "<program>"
                app_env                         = "<application-environment>"
                domain                          = "<active-directory-domain>"
                pca                             = "<pca-code>"
                availability_zones              = [ "<availability-zones>" ]
	}

	ecr				        = {
                suffix                          = "<suffix>"
                tags                            ={
                        builder                 = "<builder>"
                        primary_contact         = "<primary-contact>"
                        owner                   = "<owner>"
                        purpose                 = "<purpose>"
                }
	}
}
```

`platform` is a parameter for *all* **MDThink Enterprise Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the [mdt-eter-platform documentation](https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse). The following section goes into more detail regarding the `ecr` variable.

### Parameters

The `ecr` object represents the configuration for a new deployment. Only two fields are absolutely required: `suffix` and `tags`. See previous section for example usage. The following bulleted list shows the hierarchy of allowed values for the `ecr` object fields and their purpose,

- `suffix`: (*Required*): String that is appended to the platform naming prefix.
- `tags`: (*Required*):
        - `builder`: (*Required*) Person or process responsible for provisioning.
	- `primary_contact`: (*Required*) Contact information for the owner of the repository.
	- `owner`: (*Required*) Name of the owner.
	- `purpose`: (*Required*) Description of the repository.
- `mutability`: (*Optional*) Property for configuring the mutability of the repository. Defaults to `IMMUTABLE`, meaning tags cannot be overriden on push, i.e. once a tag is defined, it is etched into the annals of eternity.
- `policy_principals`: (*Optional*) A list of IAM policy principals that will be given added to the access list of the resource policy. If no `policy_principals` are provided, access will be provided to *all* IAM principals in the target account.
- `additional_policies`: (*Optional*): A list of stringified IAM policy JSONs. These policies will be appended to the resource policy, in addition to the default policy that is provisioned.
- `kms_key`: (*Optional*) KMS key object used to encrypt block devices. If no KMS key is provided, a new KMS key will be provisioned and access will be provided to the instance profile IAM role.
	- `id`: Physical ID of the KMS key.
	- `arn`: AWS ARN of the KMS key.

## Contributing

Checkout master and pull the latest commits,

```bash
git checkout master
git pull
```

Append ``feature/`` to all new branches.

```bash
git checkout -b feature/newthing
```

After committing your changes, push them to your feature branch and then merge them into the `test` branch. 

```bash
git checkout test && git merge feature/newthing
```

Once the changes are in the `test` branch, the Jenkins job containing the unit tests, linting and security scans can be run. Once the tests are passing, tag the latest commit,

```bash
git tag v1.0.1
```

Once the commit has been tagged, a PR can be made from the `test` branch into the `master` branch.

### Pull Request Checklist

Ensure each item on the following checklist is complete before updating any tenant deployments with a new version of the ``mdt-eter-core-compute-eks`` module,

- [] Update Changelog
- [] Open PR into `test` branch
- [] Ensure tests are passing in Jenkins
- [] Increment `git tag` version
- [] Merge PR into `test`
- [] Open PR from `test` into `master` branch
- [] Get approval from lead
- [] Merge into `master`
- [] Publish latest version on Confluence
