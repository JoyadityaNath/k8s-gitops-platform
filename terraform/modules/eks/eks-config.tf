# ========================================================
#                     EKS CLUSTER
# ========================================================

resource "aws_iam_role" "eks_role" {
  name = "eks-role-joynath"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_eks_cluster" "eks" {
  name = "k8s-gitops-platform-cluster-joynath"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = var.subnets_eks
    endpoint_public_access = true
    public_access_cidrs = [ "0.0.0.0/0" ]
  }
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}




# ========================================================
#                     NODE GROUPS
# ========================================================


resource "aws_iam_role" "node_group_role" {
  name = "eks-node-group-role-joynath"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_1" {
  role = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_policy_2" {
  role = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_policy_3" {
  role = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}



resource "aws_eks_node_group" "eks_node_group" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "k8s-gitops-platform-nodegrp-joynath"
  node_role_arn = aws_iam_role.node_group_role.arn

  subnet_ids = var.subnets_eks
  

  scaling_config {
    max_size = 6
    min_size = 1
    desired_size = 3
  }
  instance_types = ["t3.small"]

  depends_on = [ aws_iam_role_policy_attachment.ec2_policy_1, aws_iam_role_policy_attachment.ec2_policy_2, aws_iam_role_policy_attachment.ec2_policy_3 ]
}