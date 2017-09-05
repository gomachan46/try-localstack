# try localstack

## requirements

* awscli

## set up configure

```
make configure 

AWS Access Key ID [None]: dummy
AWS Secret Access Key [None]: dummy
Default region name [None]: ap-northeast-1
Default output format [None]: text
```

## lambda

### create function

```
make lambda/create
```

### run function

```
make lambda/run
```

## show more

```
make help
```
