variable "name" {
  description = "Name of the stream"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "definition" {
    type  = string
}

variable "name" {
    type  = string
}