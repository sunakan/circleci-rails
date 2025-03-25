# Railsのコンテナに入る

```shell
docker compose up -d db
make bash
```

# CircleCI

### validationを使う

circleciコマンドが必要

```shell
CIRCLECI_CLI_TELEMETRY_OPTOUT=true && circleci --skip-update-check config validate config.yml
```


### workflowは必須

- jobまでだと動かない & 怒られる
- 無いと以下のように怒られる

```shell
Error: config compilation contains errors: config compilation contains errors:
        - There are no workflows or build jobs in the config.
```

### machineのresource_classの下限はmedium

- サポートされていない `small` で指定すると、以下のように怒られる

```
Resource class machine for small, image ubuntu-2204:2024.11.1 is not available for your project, or is not a valid resource class. This message will often appear if the pricing plan for this project does not support machine use.
```

- https://circleci.com/pricing/price-list/
- メモリ観点で1番コスパが良いのは、MachineのArm
- Machineを選択する方が「Spin up environment」が短い
  - dockerだとpullするのに時間を食ったりする
    - Machineだと `0s`
    - Docker(cimg/base:キャッシュ有り)だと `2s`
  - dockerを利用する場合も、cimgはキャッシュヒット率が高いらしい

- Smallは12秒で1credit
- Mediumは6秒で1credit
- Largeは3秒で1credit

**Small**

| type    | Archi | Class | vCPUs | RAM | Cost          | RAM/Cost | 秒/credit |
|:--------|:------|:------|:------|:----|:--------------|:---------|:---------|
| docker  | x86   | small | 1     | 2GB | 5 credits/min | 500MB    | 12       |
| docker  | Arm   | 無い  | - | -   | -             | -        | -        |
| machine | x86   | 無い  | - | -   | -             | -        | -        |
| machine | Arm   | 無い  | - | -   | -             | -        | -        |

**Medium**

| type    | Archi | Class      | vCPUs | RAM | Cost           | RAM/Cost | 秒/credit |
|:--------|:------|:-----------|:------|:----|:---------------|:---------|:---------|
| docker  | x86   | medium     | 2     | 4GB | 10 credits/min | 400MB    | 6        |
| docker  | Arm   | arm.medium | 2 | 8   | 13             | 615      | 4.6      |
| machine | x86   | medium     | 2 | 7.5 | 10             | 750      | 6        |
| machine | Arm   | arm.medium | 2 | 8   | 10             | 800      | 6        |

**Medium+**

| type    | Archi | Class   | vCPUs | RAM | Cost           | RAM/Cost | 秒/credit |
|:--------|:------|:--------|:------|:----|:---------------|:---------|:---------|
| docker  | x86   | medium+ | 3     | 6GB | 15 credits/min | 400MB    | 4        |
| docker  | Arm   | 無い      | - | -   | -              |          | -        |
| machine | x86   | 無い      | - | -   | -              |          | -        |
| machine | Arm   | 無い      | - | -   | -              |          | -        |

**Large+**

| type    | Archi | Class     | vCPUs | RAM | Cost           | RAM/Cost | 秒/credit |
|:--------|:------|:----------|:------|:----|:---------------|:---------|:---------|
| docker  | x86   | large     | 4     | 8GB | 20 credits/min | 400MB    | 3        |
| docker  | Arm   | arm.large | 4 | 16  | 26             | 615      | 2.3      |
| machine | x86   | large     | 4 | 15  | 20             | 750      | 3        |
| machine | Arm   | arm.large | 4 | 16  | 20             | 800      | 3        |

### Machine(Ubuntu)に最初から入っているソフトウェアは多い

簡単な処理をしたい時はMachine(Ubuntu)を使った方が速度向上につながる

- https://discuss.circleci.com/t/ubuntu-20-04-22-04-24-04-q4-edge-release/52429

Machine(ubuntu-2404:current)で以下を確認

```
make: GNU Make 4.3
node: v22.11.0
ruby: ruby 3.3.4 (2024-07-09 revision be1089c8ec) [aarch64-linux]
aws: aws-cli/2.22.3 Python/3.12.6 Linux/6.8.0-1018-aws exe/aarch64.ubuntu.24
jq: jq-1.7
yq: yq (https://github.com/mikefarah/yq/) version v4.44.5
circleci: Build Agent version: 1.0.271228-661bc540
```

※ この中にあるcircleciコマンドはconfig.ymlを生成するためのものではない

### circleciコマンドはOrb,Docker両方ある

**Orb**
- https://circleci.com/developer/orbs/orb/circleci/circleci-cli
  - circleci/circleci-cli@0.1.9

```yaml
orbs:
  orb-cli: circleci/circleci-cli@0.1.9
jobs:
  setup:
    machine:
      image: ubuntu-2404:current
    environment:
      CIRCLECI_CLI_TELEMETRY_OPTOUT: 'true'
    resource_class: arm.medium
    steps:
      - checkout
      - orb-cli/install
      - run:
          name: config生成
          command: cd .circleci && bin/generate-config.sh
      - run:
          name: バリデーション
          command: cd .circleci && bin/validate-config.sh
```

**Docker**
- https://github.com/CircleCI-Public/circleci-cli?tab=readme-ov-file#docker
- https://hub.docker.com/r/circleci/circleci-cli/tags

```shell
# ARM用が用意されたら、platformオプションを削除
# alpine(20~25MB)
docker run --rm -it --platform linux/amd64 -e CIRCLECI_CLI_TELEMETRY_OPTOUT=true circleci/circleci-cli:alpine version
# latestはUbuntu(500~550MB)
docker run --rm -it --platform linux/amd64 -e CIRCLECI_CLI_TELEMETRY_OPTOUT=true --entrypoint '' circleci/circleci-cli:latest bash -c 'cat /etc/os-release | head -n1'
PRETTY_NAME="Ubuntu 22.04.2 LTS"
```

### DynamicConfigurationを利用する場合は、公式のOrbを利用

- https://circleci.com/developer/ja/orbs/orb/circleci/continuation

```yaml
orbs:
  orb-cli: circleci/circleci-cli@0.1.9
  orb-continuation: circleci/continuation@1
jobs:
  setup:
    machine:
      image: ubuntu-2404:current
    environment:
      CIRCLECI_CLI_TELEMETRY_OPTOUT: 'true'
    resource_class: arm.medium
    steps:
      - checkout
      - orb-cli/install
      - run:
          name: config生成
          command: cd .circleci && bin/generate-config.sh
      - orb-continuation/continue:
          configuration_path: .circleci/generated-config.yml
```

### DynamicConfigurationで生成されたjobもbranch filterの影響は受ける

ignoreしてたら、ちゃんと走らない

```yaml
# .circleci/src/workflows/ci.yml
# mainブランチで生成された場合、ciワークフローは走らない
jobs:
  - start-branch-filter:
      filters:
        branches:
          ignore:
            - main
            - /deploy.*/
  - hello:
      requires:
        - start-branch-filter
```
