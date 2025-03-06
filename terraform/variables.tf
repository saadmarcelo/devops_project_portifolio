variable "ami" {
  description = "AMI aws value"
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instace_type" {
  description = "Tipo de instancia na criada"
  default     = "t2.micro"
}

variable "environment" {
  description = "Ambiente criado"
  default     = "stg"

}
