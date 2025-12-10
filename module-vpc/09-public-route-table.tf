# # get the default route table for the VPC
# data "aws_route_table" "default-route-table" {
#   vpc_id = aws_vpc.vpc-main.id
#   filter {
#     name   = "association.main"
#     values = ["true"]
#   }
# }
# # tag the default route table
# resource "aws_ec2_tag" "tag_default_route_table" {
#   resource_id = data.aws_route_table.default-route-table.id
#   key         = "Name"
#   value       = "${var.environment}-public-route-table"
# }
# # associate the default route table with the VPC
# resource "aws_main_route_table_association" "main" {
#   vpc_id         = aws_vpc.vpc-main.id
#   route_table_id = data.aws_route_table.default-route-table.id
# }
# # add a route to the default route table to allow internet access
# resource "aws_route" "default-route-table" {
#     route_table_id = data.aws_route_table.default-route-table.id
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
# }   

# Tag the default route table of the VPC
resource "aws_ec2_tag" "tag_default_route_table" {
  resource_id = aws_vpc.vpc-main.default_route_table_id
  key         = "Name"
  value       = "${var.environment}-public-route-table"

  depends_on = [aws_vpc.vpc-main]
}

# Set main route table explicitly (not required, but optional)
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc-main.id
  route_table_id = aws_vpc.vpc-main.default_route_table_id

  depends_on = [aws_vpc.vpc-main]
}

# Add route to the Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.vpc-main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  depends_on = [
    aws_internet_gateway.gw,
    aws_vpc.vpc-main
  ]
}
