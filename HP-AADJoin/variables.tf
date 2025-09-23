variable "resource_group_name" {
  default = "TF-RG"
}

variable "location" {
  default = "East US"
}

variable "host_pool_name" {
  default = "HP-EntraJoin"
}

variable "session_host_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_B2s"
}

#variable "maximum_sessions_allowed" {
#  default = 2
#}
