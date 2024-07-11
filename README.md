# Enterprise Terraform 
## AWS Core Storage Elastic Container Registry
### Overview

TODO

### Usage

The bare minimum deployment can be achieved with the following configuration,

```
module "ecr" {
	source          		        = "ssh://git@source.mdthink.maryland.gov:22/et/mdt-eter-aws-core-storage-ecr.git"
	
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

	redshift				= {
        # TODO
	}
}
```

`platform` is a parameter for *all* **MDThink Enterprise Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the [mdt-eter-platform documentation](https://source.mdthink.maryland.gov/projects/ET/repos/mdt-eter-platform/browse). The following section goes into more detail regarding the `ecr` variable.

### Parameters

TODO
