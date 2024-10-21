provider "aws" {
  region = "us-east-1"
}

# VPC 생성
resource "aws_vpc" "private_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "private-vpc"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.private_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.private_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false  # 퍼블릭 IP를 할당하지 않음
  tags = {
    Name = "private-subnet"
  }
}

# 인터넷 게이트웨이 생성 (퍼블릭 서브넷에만 연결)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.private_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# 퍼블릭 서브넷의 라우팅 테이블
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.private_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# 퍼블릭 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 서브넷의 보안 그룹 설정
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.private_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # 내부 트래픽만 허용
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # 내부 네트워크만 허용
  }

  tags = {
    Name = "private-sg"
  }
}
