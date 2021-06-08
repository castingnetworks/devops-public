locals {
 
  environment_variables = {
   for_each = var.environment.variables == null ? [] : [var.environment.variables]
     content = {
       variables = environment.value.variables
     }
 }
}
