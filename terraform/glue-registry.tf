resource "aws_glue_registry" "glue_schema_registry" {
  registry_name = "conduktor-schema-registry"
  description   = "A Glue schema registry to use with Conduktor."
}