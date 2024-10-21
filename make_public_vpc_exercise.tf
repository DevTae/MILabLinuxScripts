# Terraform provider 설정 (AWS)
provider "aws" {
  region = "us-east-1"  # 사용할 AWS 리전
}

# VPC 리소스 생성
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # VPC의 CIDR 블록
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # 퍼블릭 서브넷의 CIDR 블록
  availability_zone       = "us-east-1a"  # 서브넷을 배치할 가용 영역
  map_public_ip_on_launch = true  # 퍼블릭 IP를 자동으로 할당
  tags = {
    Name = "public-subnet"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

# 퍼블릭 서브넷의 라우팅 테이블 설정
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  # 모든 트래픽을 인터넷으로 라우팅
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# 라우팅 테이블과 서브넷을 연결
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 보안 그룹 생성 (기본적으로 모든 인바운드 트래픽 허용)
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 인바운드 트래픽 허용
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 아웃바운드 트래픽 허용
  }

  tags = {
    Name = "allow-all-sg"
  }
}
