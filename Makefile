PREFIX ?= /usr/local

.PHONY: install uninstall

install:
	@echo "赋予 mkproj.sh 执行权限..."
	@chmod +x mkproj.sh
	@echo "安装 mkproj 到 $(PREFIX)/bin/mkproj ..."
	@sudo mkdir -p $(PREFIX)/bin
	@sudo ln -sf $(PWD)/mkproj.sh $(PREFIX)/bin/mkproj
	@echo "安装完成！你现在可以在任何地方使用 'mkproj' 命令了。"

uninstall:
	@echo "从 $(PREFIX)/bin/mkproj 卸载 ..."
	@sudo rm -f $(PREFIX)/bin/mkproj
	@echo "卸载完成！"
