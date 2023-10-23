data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
resource "random_id" "ldc_node_id" {
    byte_length = 2
    count = var.main_instance_count
}
resource "aws_instance" "ldc-main" {
    count = var.main_instance_count
    instance_type = var.main_instance_type // need to specify in terraform cloud hcl
    ami = data.aws_ami.server_ami.id // linking this to the previously created data source above
    // key_name = ""
    vpc_security_group_ids = [aws_security_group.ldc_sg.id] // this has to be compromised of a list, hence why its in brackets, but it is linked to a var
    subnet_id = aws_subnet.ldc_public_subnet[count.index].id 
    root_block_device {
      volume_size = var.main_vol_size // specified as a variable in terraform cloud

    }
    tags = {
        Name = "ldc-main-${random_id.ldc_node_id[count.index].dec}"
    }
}

resource "aws_key_pair" "ldc_auth" {
    key_name = var.key_name
    public_key = var.public_key

}