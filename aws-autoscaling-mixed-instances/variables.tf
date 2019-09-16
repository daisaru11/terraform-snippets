variable "prefix" {
  default = "dummy"
}

variable "vpc_id" {
  default = "dummy_vpc_id"
}

variable "subnet_ids" {
  type = list(string)

  default = [
    "dummy_subnet_id1",
    "dummy_subnet_id2",
  ]
}

variable "ami_id" {
  default = "dummy_ami_id"
}

variable "autoscale_max_size" {
  default = 5
}

variable "autoscale_min_size" {
  default = 0
}

variable "autoscale_on_demand_base_capacity" {
  default = 0
}

variable "autoscale_on_demand_percentage_above_base_capacity" {
  default = 0
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium", "t3.large"]
}

