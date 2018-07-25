# Makefile 总结
make命令执行时，需要一个 Makefile 文件，以告诉make命令需要怎么样的去编译和链接程序。

# 案例
```
help:
	@echo "lint             run lint"

.PHONY: lint
lint:
	gofmt -s -w .
	golint .
	go vet
```
