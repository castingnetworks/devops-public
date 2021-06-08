locals {
 
  environment_variables = {
   for_each = var.environment == null ? [] : [var.environment]
     content = {
       variables = environment.variables.value.variables
     }
 }
}
