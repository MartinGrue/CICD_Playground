#!/bin/sh
/usr/bin/terraform plan -var-file=main.tfvars -out=infra.out