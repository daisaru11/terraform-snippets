variable "prefix" {
  default = "dummy"
}

variable "vpc_id" {
  default = "dummy_vpc_id"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["dummy_subnet_1", "dummy_subnet_2"]
}

variable "acm_cert_arn" {
  default = "dummy_acm_cert_arn"
}

