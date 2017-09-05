AWS_REGION := ap-northeast-1
AWS_PROFILE := localstack
AWS_LAMBDA_ENDPOINT_URL := http://localhost:4574
AWS_LAMBDA_RUNTIME := python2.7
AWS_LAMBDA_RESULT := result.log

.PHONY: help configure lambda/*
.DEFAULT_GOAL: help

help: ## show this
	@awk -F '##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-12s\033[0m %s\n", $$1, $$NF }' ${MAKEFILE_LIST}

configure: ## set up aws configure (profile named `localstack`)
	aws configure --profile localstack

lambda/prepare: INPUT_FILES = sample.py
lambda/prepare: ZIP_FILE = sample.zip
lambda/prepare: ## zip lambda functions ZIP_FILE=sample.zip INPUT_FILES=sample.py
	zip ${ZIP_FILE} ${INPUT_FILES}

lambda/create: FUNCTION_NAME = f1
lambda/create: ROLE = r1
lambda/create: HANDLER = sample.lambda_handler
lambda/create: ZIP_FILE = fileb://sample.zip
lambda/create: ## create lambda function FUNCTION_NAME=f1 ROLE=r1 HANDLER=sample.lambda_handler ZIP_FILE=fileb://sample.zip
	aws --endpoint-url=${AWS_LAMBDA_ENDPOINT_URL} --region ${AWS_REGION} --profile ${AWS_PROFILE} lambda create-function --function-name=${FUNCTION_NAME} --runtime=${AWS_LAMBDA_RUNTIME} --role=${ROLE} --handler=${HANDLER} --zip-file ${ZIP_FILE}

lambda/run: FUNCTION_NAME = f1
lambda/run: PAYLOAD = '{"key1":"value1", "key2":"value2", "key3":"value3"}'
lambda/run: ## run lambda function FUNCTION_NAME=f1 PAYLOAD='{"key1":"value1", "key2":"value2", "key3":"value3"}'
	aws  --endpoint-url=${AWS_LAMBDA_ENDPOINT_URL} --region ${AWS_REGION} --profile ${AWS_PROFILE} lambda invoke --function-name ${FUNCTION_NAME} --payload ${PAYLOAD} ${AWS_LAMBDA_RESULT}

lambda/delete: FUNCTION_NAME = f1
lambda/delete: ## delete lambda function FUNCTION_NAME=f1
	aws --endpoint-url=${AWS_LAMBDA_ENDPOINT_URL} --region ${AWS_REGION} --profile ${AWS_PROFILE} lambda delete-function --function-name=${FUNCTION_NAME}

lambda/recreate: lambda/delete lambda/prepare lambda/create ## recreate lambda function

test: ## run test using localstack
	python lambda_test.py
	make lambda/recreate
	make lambda/run && grep "Hello from Lambda" ${AWS_LAMBDA_RESULT}
