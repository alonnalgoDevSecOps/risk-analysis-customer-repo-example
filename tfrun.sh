#/usr/bin/bash

set -o xtrace

export AWS_ACCESS_KEY_ID=AKIAZGQIXN2MA77YTIF7
export AWS_SECRET_ACCESS_KEY=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

export GOOGLE_APPLICATION_CREDENTIALS='/home/vl/tmp/checkpullrequest-main/tf-test/cloudflow-qa-gcp1-90070c4eeb3d.json'

export ARM_CLIENT_ID="9724c704-5da9-4b97-8c13-fa7fa2319454"
export ARM_CLIENT_SECRET="ARl8Q~oEUV7eXC2L0i~jeunmuCGhgHoNBgDPma9D"
export ARM_SUBSCRIPTION_ID="edd4c50d-8e5f-4528-8e67-3a3b41fd7da0"
export ARM_TENANT_ID="3f5e448d-3631-4760-8ccc-88de48f56fb1"

#terraform init -upgrade

echo Essure env.vars
printenv | grep ^ARM*
printenv | grep ^AWS*
printenv | grep ^GOOGLE*
echo start Terraform
terraform plan -input=false -no-color -out=/tmp/tf.out > plan.out

if [ $? -eq 0 ]
then
  terraform show -json /tmp/tf.out > tf.json.out
  cp tf.json.out /mnt/c/tmp/
else
  echo "Problem in plan command" >&2
fi
