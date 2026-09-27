data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "jenkins" {
  key_name   = "${var.project_name}-jenkins-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public[0].id

  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  associate_public_ip_address = true

  key_name             = aws_key_pair.jenkins.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-jenkins"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOF
[jenkins]
${aws_instance.jenkins.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${var.private_key_path}
EOF
}