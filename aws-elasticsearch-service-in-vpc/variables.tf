variable "prefix" {
  default = "dummy"
}

variable "elasticsearch_version" {
  default = "6.7"
}

variable "elasticsearch_instance_type" {
  default = "t2.small.elasticsearch"
}

variable "elasticsearch_instance_count" {
  default = 3
}

variable "elasticsearch_availability_zone_count" {
  default = 3
}

variable "vpc_id" {
  default = "dummy_vpc_id"
}

variable "subnet_ids" {
  type = list(string)

  default = [
    "dummy_subnet_id1",
    "dummy_subnet_id2",
    "dummy_subnet_id3",
  ]
}

variable "ingress_cidr_blocks" {
  type = list(string)

  default = [
    "10.0.0.0/16",
  ]
}

