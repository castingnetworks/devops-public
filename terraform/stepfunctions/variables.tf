variable "name" {
  description = "Name of the stream"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "definition" {
  type = string
}

variable "policy_json" {
  type    = string
  default = null
}
