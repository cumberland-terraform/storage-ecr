# Enterprise Terraform 
## AWS Core Storage Elastic Container Registry
### Overview

This the **MDThink Platform** core module for Elastic Container Registry. This module will provision an ECR along with a resource-based policy allowing access to any provided prinicipals. If no additional principals are provided, the resource policy defaults to allow all IAM principals in the target accoutn access to the contents of the ECR.

### Usage

The bare minimum deployment can be achieved with the following configuration,

```
module "ecr" {
	source          		        = "ssh://git@source.mdthink.maryland.gov:22/et/mdt-eter-aws-core-storage-ecr.git?ref=v1.0.0"
	
	platform				= {
        aws_region          = "<region-name>"
        account             = "<account-name>"
        acct_env            = "<account-environment>"
        agency              = "<agency>"
        program             = "<program>"
        app_env             = "<application-environment>"
        pca                 = "<pca-code>"
	}

	ecr				        = {
        tags                = {
            builder         = "<builder>"
            primary_contact = "<primary-contact>"
            owner           = "<owner>"
            purpose         = "<purpose>"
        }
	}
}
```

`platform` is a parameter for *all* **MDThink Enterprise Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the [mdt-eter-platform documentation](https://source.mdthink.maryland.gov/projects/ET/repos/mdt-eter-platform/browse). The following section goes into more detail regarding the `ecr` variable.

### Parameters

The `ecr` object represents the configuration for a new deployment. Only one fields is absolutely required: `tags`. See previous section for example usage. The following bulleted list shows the hierarchy of allowed values for the `ecr` object fields and their purpose,

- `tags`: (*Required*)
    - `builder`: (*Required*) Person or process responsible for provisioning.
	- `primary_contact`: (*Required*) Contact information for the owner of the instance.
	- `owner`: (*Required*) Name of the owner.
	- `purpose`: (*Required*) Description of the server. 
- `additional_policies`: (*Optional*) A list of stringified policy JSONs. These policies will be attached to the ECR in addition to the default access policy.
- `policy_principals`: (*Optional*) A list of IAM principal ARNs. This list of IAM principals will be granted use of the KMS key. If no principals are provided, access is provided to all IAM principals in the target account.
- `mutability` (*Optional*) Determines whether or not image tags can be overwritten. Defaults to `IMMUTABLE`.
- `kms_key`: (*Optional*) KMS key object used to encrypt block devices. If no KMS key is provided, a new KMS key will be provisioned and access will be provided to the instance profile IAM role.
	- `id`: Physical ID of the KMS key.
	- `arn`: AWS ARN of the KMS key.
- `suffix`: (*Optional*) Suffix that will be appended to the end of the platform prefix. Defaults to `REPO`.

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
