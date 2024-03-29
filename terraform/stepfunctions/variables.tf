variable "name" {
  description = "Name of the state machine"
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
  type        = string
  default     = null
  description = "(Deprecated) Use 'policy' variable instead"
}

variable "policy" {
  description = "An additional policy to attach to the State machine role"
  type        = object({
    json = string
  })
  default     = null
}

variable "type" {
  type        = string
  default     = "STANDARD"
  description = "(Optional) Determines whether a Standard or Express state machine is created. The default is 'STANDARD'. You cannot update the type of a state machine once it has been created. Valid values: 'STANDARD', 'EXPRESS'"
}

variable "log_level" {
  type        = string
  default     = "OFF"
  description = "(Optional) Defines which category of execution history events are logged. Valid values: ALL, ERROR, FATAL, OFF"
}

variable "include_execution_data" {
  type        = bool
  default     = false
  description = "(Optional) Determines whether execution data is included in your log. When set to false, data is excluded."
}
