variable "pub_key" {
  type = string
}

variable "region" {
  type = string
}

variable "clickhouse_az" {
  description = "AZ in which clickhouse replicas will be deployed. Defines number of replicas"
  type = list(string)
}

variable "zookeeper_az" {
  type = list(string)
}

 variable "clickhouse_shards" {
   type = number
 }

variable "zk_instance_type" {
  type = string
  default = "t3.small"
}

variable "ch_instance_type" {
  type = string
  default = "t3.small"
}
