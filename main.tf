provider "aws" {
  region = "us-east-1"
}


#Creacion VPC
resource "aws_vpc" "vpc_3" {
  cidr_block = "10.10.0.0/20"
  tags= {
    Name = "VPC_Act3"
  }
}

#Creacion de la subnet
resource "aws_subnet" "subnet_publica_3" {
  vpc_id                  = aws_vpc.vpc_3.id
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetAct3"
  }
}

#Creacion del gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_3.id

  tags = {
    Name = "GW_3"
  }
}

#Tabla de Rutas
resource "aws_route_table" "rutas_3" {
  vpc_id = aws_vpc.vpc_3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags ={
    Name = "Rutas_publicas"
  }
}

#Asociacion de las tablas
resource "aws_route_table_association" "asociacion_3" {
  subnet_id      = aws_subnet.subnet_publica_3.id
  route_table_id = aws_route_table.rutas_3.id
}


#GRUPOS DE SEGURIDAD
resource "aws_security_group" "web_sg" {
  name        = "Grupo de seguridad para la web"
  description = "Permite HTTP y SSH"
  vpc_id      = aws_vpc.vpc_3.id

  #Trafico SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Trafico HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jump_sg" {
  name        = "jump-sg"
  description = "Permitir SSH desde internet"
  vpc_id      = aws_vpc.vpc_3.id

  #Trafico SSH
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Instancias

#Instancias Web

#Instancia1
resource "aws_instance" "Instancia_1" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_publica_3.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Instancia Web Linux 1"
  }
}

#Instancia2
resource "aws_instance" "Instancia_2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_publica_3.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Instancia Web Linux 2"
  }
}

#Instancia3
resource "aws_instance" "Instancia_3" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_publica_3.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Instancia Web Linux 3"
  }
}

#Instancia4
resource "aws_instance" "Instancia_4" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_publica_3.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Instancia Web Linux 4"
  }
}


#Instancia del Jump Server
resource "aws_instance" "Instancia_jumpserver" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_publica_3.id

  vpc_security_group_ids = [aws_security_group.jump_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Instancia Jump Server"
  }
}


#Outputs
output "Ip_publica1" {
  description = "ip publica de linux"
  value = aws_instance.Instancia_1.public_ip
}

output "Ip_publica2" {
  description = "ip publica de linux"
  value = aws_instance.Instancia_2.public_ip
}

output "Ip_publica3" {
  description = "ip publica de linux"
  value = aws_instance.Instancia_3.public_ip
}

output "Ip_publica4" {
  description = "ip publica de linux"
  value = aws_instance.Instancia_4.public_ip
}

output "Ip_publicaJS" {
  description = "ip publica de linux"
  value = aws_instance.Instancia_jumpserver.public_ip
}

