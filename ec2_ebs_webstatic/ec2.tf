/*
Đổi tên file main.tf thành ec2.tf
*/
resource "aws_instance" "web" {
  ami             = "ami-0ff89c4ce7de192ea"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["ingress_rules"]
  tags = {
    Name = "Web01"
  }

  //Copy folder travel vào thư mục /home/ec2-user/
  provisioner "file" {
    source      = "./tropiko-html"
    destination = "/home/ec2-user/"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${var.keyname}.pem")
      host        = aws_instance.web.public_ip
    }
  }
}

resource "aws_ebs_volume" "ebsweb" {
  availability_zone = var.az
  size              = 1
  type              = "gp2"
  tags              = {name: "ebsweb volume", type: "gp2"}
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebsweb.id
  instance_id = aws_instance.web.id
}

output "storages" {
  value = aws_instance.web.ebs_block_device
}