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

**Small**

| type                          | Archi | Class | vCPUs | RAM | Cost          | RAM/Cost |
|:------------------------------|:------|:------|:------|:----|:--------------|:---------|
| docker                        | x86   | small | 1     | 2GB | 5 credits/min | 500MB    |
| docker                        | Arm   | 無い  | - | -   | -             | -        |
| machine                       | x86   | 無い  | - | -   | -             | -        |
| machine                       | Arm   | 無い  | - | -   | -             | -        |

**Medium**

| type    | Archi | Class      | vCPUs | RAM | Cost           | RAM/Cost |
|:--------|:------|:-----------|:------|:----|:---------------|:---------|
| docker  | x86   | medium     | 2     | 4GB | 10 credits/min | 400MB    |
| docker  | Arm   | arm.medium | 2 | 8   | 13             | 615      |
| machine | x86   | medium     | 2 | 7.5 | 10             | 750      |
| machine | Arm   | arm.medium | 2 | 8   | 10             | 800      |

**Medium+**

| type    | Archi | Class   | vCPUs | RAM | Cost           | RAM/Cost |
|:--------|:------|:--------|:------|:----|:---------------|:---------|
| docker  | x86   | medium+ | 3     | 6GB | 15 credits/min | 400MB    |
| docker  | Arm   | 無い      | - | -   | -              |          |
| machine | x86   | 無い      | - | -   | -              |          |
| machine | Arm   | 無い      | - | -   | -              |          |

**Large+**

| type    | Archi | Class     | vCPUs | RAM | Cost           | RAM/Cost |
|:--------|:------|:----------|:------|:----|:---------------|:---------|
| docker  | x86   | large     | 4     | 8GB | 20 credits/min | 400MB    |
| docker  | Arm   | arm.large | 4 | 16  | 26             | 615      |
| machine | x86   | large     | 4 | 15  | 20             | 750      |
| machine | Arm   | arm.large | 4 | 16  | 20             | 800      |

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
