

module "tfplan-functions" {
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "aws-functions" {
    source = "./aws-functions/aws-functions.sentinel"

}

policy "check-ec2-application-tags" {
    source = "./check-ec2-application-tags.sentinel"
    enforcement_level = "soft-mandatory"
}    

policy "check-ec2-environment-tag" {
    source = "./check-ec2-environment-tag.sentinel"
    enforcement_level = "soft-mandatory"
}    

policy "restrict-ami-type-ssm-support" {
    source = "./restrict-ami-type-ssm-support.sentinel"
    enforcement_level = "soft-mandatory"
}    

policy "restrict-ec2-type-application-instance" {
    source = "./restrict-ec2-type-application-instance.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-type-cache-instance" {
    source = "./restrict-ec2-type-cache-instance.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-type-data-instance" {
    source = "./restrict-ec2-type-data-instance.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-type-web-instance" {
    source = "./restrict-ec2-type-web-instance.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-type-billing-instance" {
    source = "./restrict-ec2-type-billing-instance.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-type-rabbitmq-instance" {
    source = "./restrict-ec2-type-rabbitmq-instance.sentinel"
    enforcement_level = "soft-mandatory"
}


policy "restrict-az" {
    source = "./restrict-az.sentinel"
    enforcement_level = "soft-mandatory"
}