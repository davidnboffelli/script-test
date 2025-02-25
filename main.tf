provider "external" {}

# Obtenemos el secreto y lo almacenamos en un archivo
data "external" "get_secret" {
  program = ["bash", "script.sh"]
}

# Recurso que vuelve a generar el archivo al hacer destroy
resource "null_resource" "regenerate_secret_on_destroy" {
  triggers = {
    always_run = timestamp() # Forzar ejecución siempre que se ejecute Terraform
  }

  provisioner "local-exec" {
    command = "bash script.sh"
  }

  # Este provisioner se ejecutará *antes* de eliminar los recursos
  lifecycle {
#    precondition {
#      condition     = fileexists("archivo.txt")
#      error_message = "El archivo de secretos no existe antes de ejecutar el destroy."
#    }
  }
  
  # depends_on = [local_file.secret_file]
}
