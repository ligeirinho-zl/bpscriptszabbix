variable "aws_account_id" {}
variable "aws_profile" {}
variable "aws_region" {}

variable "tags_json_input" {
    default = "{\"tag1Key\":\"bp:tecnico:ambiente\",\"tag2Key\":\"bp:negocio:nomeSquad\",\"tag3Key\":\"bp:tecnico:identificacaoDoServico\",\"tag4Key\":\"bp:tecnico:descricaoDoServico\",\"tag5Key\":\"bp:tecnico:ambiente\"}"
}

variable "resource_tags" {
    type = map(list)
    default = {
        "LB-no-Tags" = ["AWS::ElasticLoadBalancing::LoadBalancer", "AWS::ElasticLoadBalancingV2::LoadBalancer"]
        "RDS-sem-tags" = ["AWS::RDS::DBInstance"]
        "beanstalk-no-tags" = ["AWS::ElasticBeanstalk::Application", "AWS::ElasticBeanstalk::ApplicationVersion", "AWS::ElasticBeanstalk::Environment"]
        "ec2-sem-tags" = ["AWS::EC2::Instance"]
        "s3-sem-tag" = ["AWS::S3::Bucket"]
        "sg-no-tags" = ["AWS::EC2::SecurityGroup"]
        "snapshot-rds-no-tags" = ["AWS::RDS::DBSnapshot"]
        "vpc-no-tags" = ["AWS::EC2::VPCEndpoint","AWS::EC2::VPCEndpointService","AWS::EC2::VPCPeeringConnection","AWS::EC2::VPC"]
    }
}

variable "tags" {
  type = map(string)
  default = {
    "bp:negocio:nomeJornada" = "O2B"
    "bp:negocio:nomeSquad" = "O2B"
    "bp:tecnico:identificacaoDoServico" = "O2B"
    "bp:tecnico:descricaoDoServico" = "O2B"
    "bp:tecnico:ambiente" = "O2B"
  }
}