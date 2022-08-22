resource "null_resource" "remote" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./${var.keyname}.pem")
    host        = aws_instance.web.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install nginx1 -y",   //Cài đặt nginx
      "sudo yum install xfsprogs -y",                 // cai goi bo tro
      "sudo mkfs -t xfs /dev/xvdh",          //format disk
      "sudo mkdir /data",                   //Tao folder data
      "sudo mount /dev/xvdh /data",         //Mount disk to data   
      "sudo mv /home/ec2-user/tropiko-html /data", //Chuyển thư mục /home/ec2-user/tropiko-html vào /dev/sdh/usr/share/nginx/html
      "sudo sed -i s+/usr/share/nginx/html+/data/tropiko-html+g /etc/nginx/nginx.conf", //thay thế đường dẫn root trong nginx.conf
      "sudo service nginx start" //khởi động service nginx
    ]
  }
}
