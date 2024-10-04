# Enterprise Terraform 
## AWS Core Storage Elastic Container Registry
### Overview

This the **MDThink Platform** core module for Elastic Container Registry. This module will provision an ECR along with a resource-based policy allowing access to any provided prinicipals. If no additional principals are provided, the resource policy defaults to allow all IAM principals in the target accoutn access to the contents of the ECR.

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
	source          		        = "ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-aws-core-storage-ecr.git"
	
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
                pca                             = "<pca-code>"
	}

	ecr				        = {
                suffix                          = "<suffix>"
                tags                            = {
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

The `ecr` object represents the configuration for a new deployment. Only one fields is absolutely required: `tags`. See previous section for example usage. The following bulleted list shows the hierarchy of allowed values for the `ecr` object fields and their purpose,

- `tags`: (*Required*)
    - `builder`: (*Required*) Person or process responsible for provisioning.
	- `primary_contact`: (*Required*) Contact information for the owner of the instance.
	- `owner`: (*Required*) Name of the owner.
	- `purpose`: (*Required*) Description of the server. 
- `additional_policies`: (*Optional*) A list of stringified policy JSONs. These policies will be attached to the ECR in addition to the default access policy.
- `policy_principals`: (*Optional*) A list of IAM principal ARNs. This list of IAM principals will be granted use of the KMS key. If no principals are provided, access is provided to all IAM principals in the target account.
- `kms_key`: (*Optional*) KMS key object used to encrypt block devices. If no KMS key is provided, a new KMS key will be provisioned and access will be provided to the instance profile IAM role.
	- `id`: Physical ID of the KMS key.
	- `arn`: AWS ARN of the KMS key.
        - `alias_arn`: AWS ARN of the KMS key alias.
- `suffix`: (*Optional*) Suffix that will be appended to the end of the platform prefix. Defaults to `REPO`.

## Contributing

The below instructions are to be performed within Unix-style terminal. 

It is recommended to use Git Bash if using a Windows machine. Installation and setup of Git Bash can be found [here](https://git-scm.com/downloads/win)

### Step 1: Clone Repo

Clone the repository. Details on the cloning process can be found [here](https://support.atlassian.com/bitbucket-cloud/docs/clone-a-git-repository/)

If the repository is already cloned, ensure it is up to date with the following commands,

```bash
git checkout master
git pull
```

### Step 2: Create Branch

Create a branch from the `master` branch. The branch name should be formatted as follows:

	feature/<TICKET_NUMBER>

Where the value of `<TICKET_NUMBER>` is the ticket for which your work is associated. 

The basic command for creating a branch is as follows:

```bash
git checkout -b feature/<TICKET_NUMBER>
```

For more information, refer to the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#create-a-branch-and-make-changes)

### Step 3: Commit Changes

Update the code and commit the changes,

```bash
git commit -am "<TICKET_NUMBER> - description of changes"
```

More information on commits can be found in the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#commit-and-push-your-changes)

### Step 4: Merge With Master On Local


```bash
git checkout master
git pull
git checkout feature/<TICKET_NUMBER>
git merge master
```

For more information, see [git documentation](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)


### Step 5: Push Branch to Remote

After committing changes, push the branch to the remote repository,

```bash
git push origin feature/<TICKET_NUMBER>
```

### Step 6: Pull Request

Create a pull request. More information on this can be found [here](https://www.atlassian.com/git/tutorials/making-a-pull-request).

Once the pull request is opened, a pipeline will kick off and execute a series of quality gates for linting, security scanning and testing tasks.

### Step 7: Merge

After the pipeline successfully validates the code and the Pull Request has been approved, merge the Pull Request in `master`.

After the code changes are in master, the new version should be tagged. To apply a tag, the following commands can be executed,

```bash
git tag v1.0.1
git push tag v1.0.1
```

Update the `CHANGELOG.md` with information about changes.

### Pull Request Checklist

Ensure each item on the following checklist is complete before updating any tenant deployments with a new version of this module,

- [] Merge `master` into `feature/*` branch
- [] Open PR from `feature/*` branch into `master` branch
- [] Ensure tests are passing in Jenkins
- [] Get approval from lead
- [] Merge into `master`
- [] Increment `git tag` version
- [] Update Changelog
- [] Publish latest version on Confluence