variable "public_subnet_config" {
  description = "Availabilty zone and cidr block specifications"
  type = map(object({
    availability_zone = string
    cidr_block=string
  }))
}
  
variable "private_subnet_config" {
  description = "Availabilty zone and cidr block specifications"
  type = map(object({
    availability_zone = string
    cidr_block=string
  }))
}