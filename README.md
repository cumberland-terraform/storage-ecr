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
The below instructions are to be performed within Git Bash. Installation and setup of Git Bash can be found [here](https://git-scm.com/downloads/win)

### Step 1 Clone or Update the Repo on your Machine
Clone the repository to your local machine. Details on this process can be found [here](https://support.atlassian.com/bitbucket-cloud/docs/clone-a-git-repository/)

If you already have the repository cloned locally, execute the following commands to update your local repo:
```bash
git checkout master
git pull
```

### Step 2 Create a Branch
Create a branch from the `master` branch to store your work. The branch name needs be formatted as follows:
```bash
feature/TICKET_NUMBER
```
Where the value of TICKET_NUMBER is the ticket for which your work is associated. 
The basic command for creating a branch is as follows:
```bash
git checkout -b feature/TICKET_NUMBER
```
For questions please refer to the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#create-a-branch-and-make-changes)

### Step 3 Make your Changes
Make your changes and addition to the module on any IDE of your choice. Most of the team uses VSCode and the offical Terraform plugin for this work.

### Step 4 Commit your Changes
After you've made your code changes and saved the changes. You need to commit the changes to your branch. This can be done as many times as you deem necessary.
The basic command to commit code appears as follows. Note each commit must begin with the ticket number associated with the completed work.
```bash
git commit -am "TICKET_NUMBER - description of changes"
```
More information on commits can be found in the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#commit-and-push-your-changes)

### Step 5 Push your Branch to the BitBucket (Remote) Repo
After commiting your changes, to protect your work from any issues while resolving merge conflicts and the like, push your branch to the remote repository by executing the following:
```bash
git push origin BRANCH_NAME
```
Note, BRANCH_NAME here is the name you set for your branch in step 2. For more information on pushing yopur changes refer to the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#commit-and-push-your-changes)

### Step 6 Merge Latest Master into your Branch Within your Local Machine
To have your branch approved and avoid merge conflicts your branch must be up to date with the latest commits to the `master` branch. To accomnplish this, execute the following within git bash:
```bash
git checkout master
git pull
git checkout YOUR_BRANCH
git merge master
```

Note: The above steps do the following. 
`git checkout master` Switches from your branch to the master branch, 
`git pull` updates your local master branch with the remote master branch, 
`git checkout YOUR_BRANCH` switches back to your branch, 
`git merge master` merges the updated master branch into your branch
Once the above are completed you must resolve any merge conflicts before proceeding. Documentation on all of the above can be found [here](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

### Step 7 Push your Branch to the BitBucket (Remote) Repo (again)
After updating your branch with latest master (and resolving any merge conflicts) push your branch from local to remote as defined in step 5

### Step 8 Open a Pull Request
To open a pull request within bitbucket between your branch and the master branch complete the following:

    From the open repository, select the Create button and select Pull request in the This repository section of the dropdown menu.

    Fill out the rest of the pull request form. 

    Click Create pull request.
Assign a team member to review your code, some may already be assigned by default. More information on this can be found [here](https://www.atlassian.com/git/tutorials/making-a-pull-request)

Once the pull request is opened a set of linting, security scanning and testing tasks will execute against your code, as soon as the job is complete a status will appear on your pull request.

### Step 9 Complete Code Review and Resolve Any Issues
Before any pull request can be merged it must
1. Have approval from a team member
2. Have a passing sec/lint/test job

You may need to rework some of your code to satisfy the above two requirements. This will require you to repeat steps 3-7.


### Done!

Once the above checks are completed the code can be merged and a tag will be applied to signify the latest version of the module. To apply a tag, after your code has been approved/merged complete the following

```bash
git tag v1.0.1
git push tag v1.0.1
```

The tag number needs to be the next iteration from the modules current version. For example the next version from the above example would be v1.0.2 etc.


### Pull Request Checklist

Ensure each item on the following checklist is complete before updating any tenant deployments with a new version of this module,

- [] Merge `master` into feature branch
- [] Open PR from feature branch into `master` branch
- [] Ensure tests are passing in Jenkins
- [] Get approval from lead
- [] Merge into `master`
- [] Increment `git tag` version
- [] Update Changelog
- [] Publish latest version on Confluence
