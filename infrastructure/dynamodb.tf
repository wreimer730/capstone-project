locals {
  postaljson = file("files/postalcode.json")
  postaldata = jsondecode(local.postaljson)
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
    name           = "capstoneDB"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    hash_key       = "id"
    range_key      = "dist"

    attribute {
            name = "id"
            type = "S"
    }
    attribute {
            name = "dist"
            type = "N"
    }

}

resource "aws_dynamodb_table" "postalcodelist" {
    name           = "pocpostalcodelist"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    hash_key       = "postalcode"
    range_key      = "city"

    attribute {
            name = "postalcode"
            type = "S"
    }
    attribute {
            name = "city"
            type = "S"
    }

}
resource "aws_dynamodb_table_item" "postalcodedata" {
  for_each = local.postaldata
  table_name = aws_dynamodb_table.postalcodelist.name
  hash_key   = aws_dynamodb_table.postalcodelist.hash_key
  range_key  = aws_dynamodb_table.postalcodelist.range_key
  item = jsonencode(each.value)
}
