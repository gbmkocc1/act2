resource "aws_iam_role" "bastion_role" {
  name = "bastion-access-role"

  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json

  tags = {
    Purpose = "Bastion Host Role"
  }
}

resource "aws_iam_role_policy" "bastion_s3_policy" {
  name   = "BastionS3Access"
  role   = aws_iam_role.bastion_role.name
  policy = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_role_policies_exclusive" "bastion_inline_exclusive" {
  role_name = aws_iam_role.bastion_role.name

  policy_names = [
    aws_iam_role_policy.bastion_s3_policy.name
  ]
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion_role.name
}
