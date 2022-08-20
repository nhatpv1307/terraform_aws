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
      "mkdir /dev/sdh/usr/share/nginx/html",      // Add folder 
      "sudo mv /home/ec2-user/tropiko-html /dev/sdh/usr/share/nginx/html", //Chuyển thư mục /home/ec2-user/tropiko-html vào /dev/sdh/usr/share/nginx/html
      "sudo sed -i s+/dev/sdh/usr/share/nginx/html+/dev/sdh/usr/share/nginx/html/tropiko-html+g /etc/nginx/nginx.conf", //thay thế đường dẫn root trong nginx.conf
      "sudo service nginx start" //khởi động service nginx
    ]
  }
}
