data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"
  
  cluster_name    = "secure-clusters"
  cluster_version = "1.29"

  vpc_id = module.vpc.vpc_id

  enable_cluster_creator_admin_permissions = true

  cluster_encryption_config = {
    provider_key_arn = var.cluster_encryption_config.provider_key_arn
    resources        = var.cluster_encryption_config.resources

  create_kms_key               = false
  create_kms_alias             = false
  create_kms_key_policy        = false  # ✅ Optional but strongly recommended

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = "arn:aws:kms:us-east-1:784434437104:key/28b828e9-c84a-4389-b04e-f805e163b10a"
  }}

  # create_kms_key               = false            # ✅ This goes here
  create_cloudwatch_log_group = false            # ✅ Optional: if log group already exists

  # ✅ Corrected to map format, not list/tuple
access_entries = {
  github_user = {
    principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/github-terraform-user"
    kubernetes_groups = ["eks-admins"]
    type              = "STANDARD"
  }
}

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 1
      subnet_ids     = module.vpc.private_subnets # ✅ This is how you pass subnet_ids now
    }
  }

  # ✅ Required to set control plane subnet IDs (even though public/private distinction is handled inside module)
  control_plane_subnet_ids = module.vpc.private_subnets
}
