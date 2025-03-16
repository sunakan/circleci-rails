.PHONY: gen-ci
gen-ci: ## CircleCI用 configをgenerate
	@docker run --rm -it --platform linux/amd64 --mount type=bind,source=${PWD},target=/home/circleci/project/ --entrypoint '' circleci/circleci-cli:latest bin/generate-config.sh

.PHONY: validate-ci-config
validate-ci-config: ## CircleCI用 configをvalidation
	@docker run --rm -it --platform linux/amd64 --mount type=bind,source=${PWD},target=/home/circleci/project/ --entrypoint '' circleci/circleci-cli:latest bin/validate-ci-config.sh

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
# 使い方例: $(call help,{included-makefile})
define help
  grep -E '^[\.a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
