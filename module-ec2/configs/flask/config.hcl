pid_file = "./pidfile"

vault {
  address = "http://52.89.205.142:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/home/ec2-user/role-id"
      secret_id_file_path = "/home/ec2-user/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink "file" {
    config = {
      path = "/home/ec2-user/sinkfile"
      mode = 0644
    }
  }
}

template {
  source = "/home/ec2-user/test.tpl"
  destination = "/home/ec2-user/db.yaml"
}