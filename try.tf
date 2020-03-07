# Try example
data "http" "primary-server" {
  url = "https://ip-ranges.amazonaws.com/ip-ranges.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}


locals {
# This returns the sync token from the endpoint, the return value is of the type string.
  syncToken = try(jsondecode(data.http.primary-server.body).syncToken,
              "NO TOKEN AVAILABLE"
              )

# This variable holds the all the unique regions returned by the endpoint. The return value is of the type list OR a string error value.
  regions = try(distinct([

    for items in jsondecode(data.http.primary-server.body).prefixes:
    items.region
  ]), "NO LIST PROVIDED IN LOCALS REGION VARIABLE")

# This variable holds the all the unique services returned by the endpoint. The return value is of the type list OR a string error value.
  services = try(distinct([

    for items in jsondecode(data.http.primary-server.body).prefixes:
    items.service
  ]), "NO LIST PROVIDED IN LOCALS SERVICES VARIABLE")

}

output "response-json-regions" {
  value = local.regions
}

output "response-json-services" {
  value = local.services
}
