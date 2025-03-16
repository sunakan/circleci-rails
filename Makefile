IMAGE_REPO = ghcr.io/sunakan/circleci-rails-dev

.PHONY: build-and-push-docker-dev
build-and-push-docker-dev: ## build docker image and push
	$(eval DATE := $(shell date +%Y-%m-%d))
	$(eval COMMIT_ID := $(shell git rev-list -1 HEAD -- Dockerfile | cut -c 1-12))
	$(eval IMAGE_TAG := ${DATE}_${COMMIT_ID})
	@docker build . -f Dockerfile.dev --tag "${IMAGE_REPO}:latest"
	@docker tag "${IMAGE_REPO}:latest" "${IMAGE_REPO}:${IMAGE_TAG}"
	@docker push "${IMAGE_REPO}:latest"
	@docker push "${IMAGE_REPO}:${IMAGE_TAG}"

.PHONY: gen-ci
gen-ci: ## CircleCI用 configをgenerate
	@cd .circleci/ && make gen-ci

.PHONY: test-viewtest-tag-only
test-viewtest-tag-only: ## with_viewtestタグがついているRspecを実行
	bundle exec rspec --tag viewtest

.PHONY: test-without-viewtest
test-without-viewtest: ## viewtestタグがついていないRspecを実行
	bundle exec rspec --tag ~viewtest

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
