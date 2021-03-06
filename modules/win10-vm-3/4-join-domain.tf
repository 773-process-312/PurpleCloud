resource "azurerm_virtual_machine_extension" "join-domain" {
  name                 = "join-domain"
  virtual_machine_id   = element(azurerm_virtual_machine.win10-3.*.id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  count                = var.vmcount

  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.active_directory_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.active_directory_password}"
    }
SETTINGS

  depends_on = [null_resource.wait-for-domain-to-provision]
}
