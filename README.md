# Enterprise Terraform 
## AWS Core Storage Relational Database Service
### Overview

This is the baseline module for all **RDS** services, standalone or clustered. It has been setup with ease of deployment in mind, so that platform compliant storage space be easily provisioned with minimum configuration.

### Usage

The bare minimum deployment can be achieved with the following configuration,

```
module "database" {
	source          		= "ssh://git@source.mdthink.maryland.gov:22/et/mdt-eter-aws-core-storage-rds.git"
	
	platform				= {
		aws_region          = "<region-name>"
        account             = "<account-name>"
        acct_env            = "<account-environment>"
        agency              = "<agency>"
        program             = "<program>"
        app_env             = "<application-environment>"
        domain              = "<active-directory-domain>"
        pca                 = "<pca-code>"
        availability_zones  = [ "<availability-zones>" ]
	}

	rds						= {
        dbname              = "<dbname>"
        username            = "<username>"
        engine              = "<aurora-postgresql/aurora-mysql/mysql/postgresql/sqlserver>"
		tags 				= {
			application 	= "<Application Name>"
			builder 		= "<Builder Name>"
			primary_contact	= "<Contact Information>"
			owner 			= "<Owner Information>"
			purpose 		= "<Description of Purpose>"
		}
	}
}
```

`platform` is a parameter for *all* **MDThink Enterprise Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the [mdt-eter-platform documentation](https://source.mdthink.maryland.gov/projects/ET/repos/mdt-eter-platform/browse). The following section goes into more detail regarding the `ec2` variable.

### Parameters

The `rds` object represents the configuration for a new deployment. Only four fields are absolutely required: `dbname`, `username`, `engine` and `tags`. See previous section for example usage. The following bulleted list shows the hierarchy of allowed values for the `rds` object fields and their purpose,

- `dbname`: (*Required*) Name of the database created in the RDS when it initializes.
- `username`: (*Required*) Username of the admin in the RDS.
- `engine`: (*Required*) Underlying SQL engine for the RDS. Currently supported values are: `aurora-mysql`, `aurora-postgresql`, `mysql`, `postgres` and `sqlserver`
- `tags`: (*Required*) Tag configuration object.
    - `application`: (*Required*) Designates the application running on the server.
	- `builder`: (*Required*) Person or process responsible for provisioning.
	- `primary_contact`: (*Required*) Contact information for the owner of the instance.
	- `owner`: (*Required*) Name of the owner.
	- `purpose`: (*Required*) Description of the server. 
	- `rhel_repo`: (*Optional*) Defaults to *NA*
	- `schedule`: (*Optional*) Defaults to *never*.
	- `new_build`: (*Optional*). Boolean flagging instance as new. Defaults to `true`.
	- `auto_backup`: (*Optional*): Boolean flagging instance for automated backup. Defaults to `false`.
- `allocated_storage`: (*Optional*) TODO. Defaults to `200`.
- `max_allocated_storage`: (*Optional*) TODO. Defaults to `200`.
- `additional_security_group_ids`: (*Optional*) List of security group ids into which the RDS will be deployed. Defaults to an empty list.
- `cluster_count`: (*Optional*) The number of numbers to attach to an RDS cluster. This argument is only consumed if the engine is set to `aurora-mysql` or `aurora-postgresql`. Defaults to `3`.
- `kms_key_id`: (*Optional*) Physical ID of the KMS key used to encrypt the storage at rest and in transit. If no KMS key is passed in, one will be provisioned and access will be given to the RDS IAM role. 
- `instance_class`: (*Optional*) The instance class of the RDS. Defaults to `db.t3.micro`.
- `iops`: (*Optional*) I/O operation frequency. Defaults to `25`. 
- `storage_type`: (*Optional*) Type of storage requested. Defaults to `gp3`.

## Supported Engines

TODO

### Postgres

TODO

### MySQL

TODO

### SQLServer

TODO

### Aurora

The RDS module also supports clustering. 

TODO

**Postgres**

TODO

**MySQL**

TODO