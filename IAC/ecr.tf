## START ECR ###

resource "aws_ecr_repository" "quest" {
    name ="quest"
    image_scanning_configuration {
      scan_on_push = true
    }

}
#Create policy for ECR repostiry for quest image. 
resource "aws_ecr_repository_policy" "quest-policy" {
  repository = aws_ecr_repository.quest.name
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy",
                "ecr:GetAuthorizationToken"
            ]
        }
    ]
}
EOF
}

## END ECR ##
