module "network" {
  source = "./modules/network"
  public_subnet_config = var.public_subnet_config
  private_subnet_config = var.private_subnet_config
}


module "eks"{
  source= "./modules/eks"
  subnets_eks = module.network.subnet_eks
}