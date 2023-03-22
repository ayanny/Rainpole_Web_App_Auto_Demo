

module "tfplan-functions" {
    source = "../common-functions/tfplan-functions.sentinel"
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
    enforcment_level = "soft-mandatory"
}    