output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
    value = aws_subnet.public-subnets[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private-subnets[*].id
}

output "db_subnet_ids" {
    value = aws_subnet.db-subnets[*].id
}