AWS_REGION := ap-northeast-1
AWS_PROFILE := localstack
AWS_LAMBDA_ENDPOINT_URL := http://localhost:4574
AWS_LAMBDA_RUNTIME := python2.7

configure:
	aws configure --profile localstack

lambda/prepare: INPUT_FILES = lambda.py
lambda/prepare: ZIP_FILE = lambda.zip
lambda/prepare:
	zip ${ZIP_FILE} ${INPUT_FILES}

lambda/create: FUNCTION_NAME = f1
lambda/create: ROLE = r1
lambda/create: HANDLER = lambda.lambda_handler
lambda/create: ZIP_FILE = fileb://lambda.zip
lambda/create:
	aws --endpoint-url=${AWS_LAMBDA_ENDPOINT_URL} --region ${AWS_REGION} --profile ${AWS_PROFILE} lambda create-function --function-name=${FUNCTION_NAME} --runtime=${AWS_LAMBDA_RUNTIME} --role=${ROLE} --handler=${HANDLER} --zip-file ${ZIP_FILE}

lambda/run: FUNCTION_NAME = f1
lambda/run: PAYLOAD = '{"key1":"value1", "key2":"value2", "key3":"value3"}'
lambda/run: OUTPUT_FILE = result.log
lambda/run:
	aws  --endpoint-url=${AWS_LAMBDA_ENDPOINT_URL} --region ${AWS_REGION} --profile ${AWS_PROFILE} lambda invoke --function-name ${FUNCTION_NAME} --payload ${PAYLOAD} ${OUTPUT_FILE}
