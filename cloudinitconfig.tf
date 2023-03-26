# This config will apply startup scipts to configure applications on EC2 servers, The applications run in 
# Docker containers, and will use specific ports for communications.
# Cloudinitconfig will use Data blocks to apply this configuration to EC2 instances upon creation.

data "cloudinit_config" "web_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitweb.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "app_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitapp.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "cache_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitcache.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "data_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitdata.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "bill_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitbill.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "rbmq_srvr_template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitrbmq.yaml", {
      service_name = var.service
    })
  }
}
