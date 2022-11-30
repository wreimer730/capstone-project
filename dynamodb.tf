resource "aws_dynamodb_table" "basic-dynamodb-table" {
    name           = "CapstoneDB"
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

    global_secondary_index {
        name               = "Index"
        hash_key           = "id"
        range_key          = "dist"
        write_capacity     = 10
        read_capacity      = 10
        projection_type    = "INCLUDE"
        non_key_attributes = ["Bla"]
    }
}