resource "null_resource" "remote" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./${var.keyname}.pem")
    host        = aws_instance.web.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",   //Chuyen qua tmp
      "sudo wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm",                 // tai java 17
      "sudo rpm -Uvh jdk-17_linux-x64_bin.rpm",          //cai dat goi
      "sudo mkdir /data",
      "sudo mv /home/ec2-user/jar /data",
      "sudo java -jar /data/apiserver-1.0.jar",                   //Chay jar
    ]
  }
}
