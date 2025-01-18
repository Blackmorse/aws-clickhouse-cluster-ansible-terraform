variable "pub_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "clickhouse_az" {
  type = list(string)
}

variable "zookeeper_az" {
  type = list(string)
}
