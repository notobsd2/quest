resource "aws_ecs_service" "quest-ecs-service" {
 name = "quest-task"
 launch_type = "FARGATE"
 cluster = aws_ecs_cluster.quest-cluster.arn
 enable_ecs_managed_tags = true
 propagate_tags = "TASK_DEFINITION" 
 wait_for_steady_state = true
 task_definition = aws_ecs_task_definition.quest-task-definition.arn
 desired_count = 1
network_configuration {
  subnets = [aws_subnet.quest2a.id , aws_subnet.quest2b.id ]
  security_groups = [ aws_security_group.quest-security-group.id ]
  assign_public_ip = true 
  }
tags = { Name = "quest" }
depends_on = [
  aws_lb_target_group.quest,
  aws_ecs_task_definition.quest-task-definition,
]
}
resource "aws_ecs_task_definition" "quest-task-definition" {
  family = "quest"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.quest-task-role.arn
  cpu       = 512
  memory    = 1024
  container_definitions = jsonencode([
    {
      name      = "quest-container" #TODO: move to variable name container 
      image     = "${aws_ecr_repository.quest.repository_url}:${local.image_version}" 
      requires_compatibilities = ["FARGATE"]
      cpu       = 512
      memory    = 1024
      logConfiguration = {
        logDriver = "awslogs"
        "options" = {
          awslogs-group = "/ecs/quest-test"
          awslogs-region = "us-east-2"
          awslogs-stream-prefix = "ecs"
          }
         }
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000 
        }
      ]
  }
  ])
  tags = { Name = "quest" }
  depends_on = [
    aws_iam_role.quest-task-role
  ]
}
resource "aws_ecs_cluster" "quest-cluster" {
  name = "quest-cluster"
}


