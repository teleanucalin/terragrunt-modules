module "network" {
  source          = "../modules/network"
  env_name        = "test"
  env_size        = "small"
  env_type        = "main"
  network_address = "172.16"
  region          = "us-east-1"
}

module "mysql_primary" {
  source          = "../modules/rds-mysql/"
  region          = "us-east-1"
  vpc_id          = module.network.vpc_id
  env_name        = "test"
  env_size        = "medium"
  //multi_az      = true
  password        = "test123456"
  //db_snapshot_identifier = "dev02-core-mysql"
  //db_snapshot_arn = var.db_snapshot_arn
}