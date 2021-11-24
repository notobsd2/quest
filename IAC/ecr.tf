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

resource "null_resource" "quest-image-initalizer" {
  triggers = {
    ecr_url = data.aws_ecr_repository.quest-repo.repository_url
  }
 provisioner "local-exec" {
   command = "docker build -t ${aws_ecr_repository.quest.repository_url}:${local.image_version} ../ && docker push ${aws_ecr_repository.quest.repository_url}:${local.image_version}" 
 } 

}

data "aws_ecr_image" "quest" {
  repository_name = aws_ecr_repository.quest.name 
  image_tag       = "latest"
  depends_on = [
    aws_ecr_repository.quest,
    null_resource.quest-image-initalizer
  ]
}

data "aws_ecr_repository" "quest-repo" {
  name = aws_ecr_repository.quest.name 
  depends_on = [
    aws_ecr_repository.quest
  ]
}
## END ECR ##
