# Change Log

## [v0.2.0](https://github.com/helios-technologies/kite/tree/v0.2.0) (2017-11-07)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.1.0...v0.2.0)

**Merged pull requests:**

- Add OAuth \(UAA\) manifest for AWS and GCP [\#94](https://github.com/helios-technologies/kite/pull/94) ([vshatravenko](https://github.com/vshatravenko))
- Change the ingress configuration to have a SSL proxy for concourse [\#93](https://github.com/helios-technologies/kite/pull/93) ([calj](https://github.com/calj))
- Fix concourse for kite [\#92](https://github.com/helios-technologies/kite/pull/92) ([ashanaakh](https://github.com/ashanaakh))
- Add github link to slack notification on pull-request [\#91](https://github.com/helios-technologies/kite/pull/91) ([ashanaakh](https://github.com/ashanaakh))
- Add concourse kite resource [\#89](https://github.com/helios-technologies/kite/pull/89) ([dkkoval](https://github.com/dkkoval))
- bugfix review pipeline [\#88](https://github.com/helios-technologies/kite/pull/88) ([calj](https://github.com/calj))
- Added Slack notifications after tests [\#85](https://github.com/helios-technologies/kite/pull/85) ([vshatravenko](https://github.com/vshatravenko))
- Added Helm-deploy job template [\#84](https://github.com/helios-technologies/kite/pull/84) ([vshatravenko](https://github.com/vshatravenko))
- Implement the git-ref tag workflow in default concourse pipeline [\#83](https://github.com/helios-technologies/kite/pull/83) ([calj](https://github.com/calj))
- Added slack as parameter to kite generate service [\#82](https://github.com/helios-technologies/kite/pull/82) ([ashanaakh](https://github.com/ashanaakh))
- Fixes [\#81](https://github.com/helios-technologies/kite/pull/81) ([ashanaakh](https://github.com/ashanaakh))
- Added pipeline for kite; refined pipeline template [\#80](https://github.com/helios-technologies/kite/pull/80) ([vshatravenko](https://github.com/vshatravenko))
- Added Slack alerts and image tagging to pipeline; fixed tests [\#79](https://github.com/helios-technologies/kite/pull/79) ([vshatravenko](https://github.com/vshatravenko))
- describe pipeline [\#78](https://github.com/helios-technologies/kite/pull/78) ([ashanaakh](https://github.com/ashanaakh))
- Improve concourse review pipeline and documentation [\#77](https://github.com/helios-technologies/kite/pull/77) ([calj](https://github.com/calj))
- Generate service fix pipeline template [\#76](https://github.com/helios-technologies/kite/pull/76) ([ashanaakh](https://github.com/ashanaakh))
- Added pr hook and unit tests to pipeline template [\#75](https://github.com/helios-technologies/kite/pull/75) ([vshatravenko](https://github.com/vshatravenko))
- Hotfixes [\#73](https://github.com/helios-technologies/kite/pull/73) ([calj](https://github.com/calj))
- Improve generate service outputs [\#72](https://github.com/helios-technologies/kite/pull/72) ([calj](https://github.com/calj))
- Added ingress-update script [\#70](https://github.com/helios-technologies/kite/pull/70) ([vshatravenko](https://github.com/vshatravenko))
- Add docker registry and git repository required parameters [\#69](https://github.com/helios-technologies/kite/pull/69) ([calj](https://github.com/calj))
- Added Prometheus with k8s metrics support to GCP [\#67](https://github.com/helios-technologies/kite/pull/67) ([vshatravenko](https://github.com/vshatravenko))
- Added Prometheus manifest with Kubernetes monitor support [\#66](https://github.com/helios-technologies/kite/pull/66) ([vshatravenko](https://github.com/vshatravenko))
- Added pipeline to generator Makefile [\#65](https://github.com/helios-technologies/kite/pull/65) ([vshatravenko](https://github.com/vshatravenko))
-  Allocate VIP with terraform for GCP platform [\#64](https://github.com/helios-technologies/kite/pull/64) ([calj](https://github.com/calj))
- Add service generator [\#63](https://github.com/helios-technologies/kite/pull/63) ([dkkoval](https://github.com/dkkoval))
- Add a HTTPS proxy for concourse on GCP [\#62](https://github.com/helios-technologies/kite/pull/62) ([calj](https://github.com/calj))
- Added kops deploy and delete scripts + S3 bucket IaC [\#61](https://github.com/helios-technologies/kite/pull/61) ([vshatravenko](https://github.com/vshatravenko))
- Added BOSH password generation for Concourse [\#60](https://github.com/helios-technologies/kite/pull/60) ([vshatravenko](https://github.com/vshatravenko))

## [v0.1.0](https://github.com/helios-technologies/kite/tree/v0.1.0) (2017-10-09)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.9...v0.1.0)

**Closed issues:**

- Use read-only Vault token for Concourse [\#49](https://github.com/helios-technologies/kite/issues/49)
- Remove credentials from manifest [\#48](https://github.com/helios-technologies/kite/issues/48)

**Merged pull requests:**

- Replaced rendering db and auth passwords with BOSH interpolation [\#59](https://github.com/helios-technologies/kite/pull/59) ([vshatravenko](https://github.com/vshatravenko))
- Updated kops instructions [\#58](https://github.com/helios-technologies/kite/pull/58) ([vshatravenko](https://github.com/vshatravenko))
- Added no-ip + platform-internal tag for GCP instances [\#56](https://github.com/helios-technologies/kite/pull/56) ([vshatravenko](https://github.com/vshatravenko))
- Added instructions for kops cluster creation [\#55](https://github.com/helios-technologies/kite/pull/55) ([vshatravenko](https://github.com/vshatravenko))
- Added manifest credentials interpolation; updated docs [\#54](https://github.com/helios-technologies/kite/pull/54) ([vshatravenko](https://github.com/vshatravenko))
- Added functional tests [\#53](https://github.com/helios-technologies/kite/pull/53) ([vshatravenko](https://github.com/vshatravenko))
- Fixed docs and setup-tunnel mode [\#51](https://github.com/helios-technologies/kite/pull/51) ([vshatravenko](https://github.com/vshatravenko))

## [v0.0.9](https://github.com/helios-technologies/kite/tree/v0.0.9) (2017-09-29)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.8...v0.0.9)

**Closed issues:**

- Move bosh\_vars into config/ [\#31](https://github.com/helios-technologies/kite/issues/31)

**Merged pull requests:**

- Improved documentation and kite render flow [\#47](https://github.com/helios-technologies/kite/pull/47) ([vshatravenko](https://github.com/vshatravenko))
- Added Vault manifest for AWS [\#46](https://github.com/helios-technologies/kite/pull/46) ([vshatravenko](https://github.com/vshatravenko))
- Added nginx manifest for GCP [\#45](https://github.com/helios-technologies/kite/pull/45) ([vshatravenko](https://github.com/vshatravenko))
- Removed public IPs from GCP BOSH deployments [\#44](https://github.com/helios-technologies/kite/pull/44) ([vshatravenko](https://github.com/vshatravenko))
- Add codecov report [\#42](https://github.com/helios-technologies/kite/pull/42) ([calj](https://github.com/calj))
- Add coverage report [\#41](https://github.com/helios-technologies/kite/pull/41) ([calj](https://github.com/calj))
- Fixes for GCP provider [\#40](https://github.com/helios-technologies/kite/pull/40) ([vshatravenko](https://github.com/vshatravenko))
- Conditional terraform network resources [\#39](https://github.com/helios-technologies/kite/pull/39) ([vshatravenko](https://github.com/vshatravenko))
- Fixed moving scripts to tpl/bin [\#38](https://github.com/helios-technologies/kite/pull/38) ([vshatravenko](https://github.com/vshatravenko))
- Add task generate command [\#37](https://github.com/helios-technologies/kite/pull/37) ([nmuzychuk](https://github.com/nmuzychuk))
- Added bootstrap and cleanup scripts [\#34](https://github.com/helios-technologies/kite/pull/34) ([vshatravenko](https://github.com/vshatravenko))
- Fixed AWS terraform.tfvars rendering [\#33](https://github.com/helios-technologies/kite/pull/33) ([vshatravenko](https://github.com/vshatravenko))
- Moved things in proper places [\#32](https://github.com/helios-technologies/kite/pull/32) ([vshatravenko](https://github.com/vshatravenko))
- Connected Vault to Concourse [\#23](https://github.com/helios-technologies/kite/pull/23) ([vshatravenko](https://github.com/vshatravenko))

## [v0.0.8](https://github.com/helios-technologies/kite/tree/v0.0.8) (2017-09-22)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.7...v0.0.8)

**Closed issues:**

- GCP Reserved ip problem [\#27](https://github.com/helios-technologies/kite/issues/27)

**Merged pull requests:**

- Added GCS backend for remote .tfstate storage [\#30](https://github.com/helios-technologies/kite/pull/30) ([vshatravenko](https://github.com/vshatravenko))
- Fixed reserved ip problem for GCP [\#29](https://github.com/helios-technologies/kite/pull/29) ([vshatravenko](https://github.com/vshatravenko))
- Fixed reserved ip range rendering for AWS [\#26](https://github.com/helios-technologies/kite/pull/26) ([vshatravenko](https://github.com/vshatravenko))
- Added subnet\_name render in terraform.tfvars [\#25](https://github.com/helios-technologies/kite/pull/25) ([vshatravenko](https://github.com/vshatravenko))
- Added Vault manifest [\#24](https://github.com/helios-technologies/kite/pull/24) ([vshatravenko](https://github.com/vshatravenko))
- Fix in shell skript template for concourse deployment [\#22](https://github.com/helios-technologies/kite/pull/22) ([n-trace](https://github.com/n-trace))

## [v0.0.7](https://github.com/helios-technologies/kite/tree/v0.0.7) (2017-09-15)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.6...v0.0.7)

**Merged pull requests:**

- Updated Concourse manifest for AWS [\#21](https://github.com/helios-technologies/kite/pull/21) ([vshatravenko](https://github.com/vshatravenko))
- Fix setup-tunnel.sh on GCP platform [\#20](https://github.com/helios-technologies/kite/pull/20) ([calj](https://github.com/calj))
- Added Dockerfile for kitebox [\#19](https://github.com/helios-technologies/kite/pull/19) ([vshatravenko](https://github.com/vshatravenko))
- NAT Gateway for AWS [\#18](https://github.com/helios-technologies/kite/pull/18) ([mod](https://github.com/mod))
- Updated docs for RDoc [\#17](https://github.com/helios-technologies/kite/pull/17) ([vshatravenko](https://github.com/vshatravenko))
- Moved kite render to subcommand [\#16](https://github.com/helios-technologies/kite/pull/16) ([vshatravenko](https://github.com/vshatravenko))
- Bugfixes for v0.0.6 [\#14](https://github.com/helios-technologies/kite/pull/14) ([vshatravenko](https://github.com/vshatravenko))
- Add cloud config, concourse [\#12](https://github.com/helios-technologies/kite/pull/12) ([nmuzychuk](https://github.com/nmuzychuk))

## [v0.0.6](https://github.com/helios-technologies/kite/tree/v0.0.6) (2017-09-13)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.5...v0.0.6)

**Merged pull requests:**

- Lib improvements; simplified kite errors [\#11](https://github.com/helios-technologies/kite/pull/11) ([vshatravenko](https://github.com/vshatravenko))
- Added BOSH CLI v2 support for AWS [\#10](https://github.com/helios-technologies/kite/pull/10) ([vshatravenko](https://github.com/vshatravenko))
- Lib improvements [\#9](https://github.com/helios-technologies/kite/pull/9) ([vshatravenko](https://github.com/vshatravenko))
- Extract bosh vars into a config file [\#8](https://github.com/helios-technologies/kite/pull/8) ([nmuzychuk](https://github.com/nmuzychuk))
- Add GCP readme [\#7](https://github.com/helios-technologies/kite/pull/7) ([nmuzychuk](https://github.com/nmuzychuk))

## [v0.0.5](https://github.com/helios-technologies/kite/tree/v0.0.5) (2017-09-01)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.4...v0.0.5)

**Merged pull requests:**

- Refactor terraform config [\#5](https://github.com/helios-technologies/kite/pull/5) ([nmuzychuk](https://github.com/nmuzychuk))
- Add bosh jumpbox [\#4](https://github.com/helios-technologies/kite/pull/4) ([nmuzychuk](https://github.com/nmuzychuk))
- Update bootstrap.sh; Removed .env; Fixed .tfvars [\#3](https://github.com/helios-technologies/kite/pull/3) ([vshatravenko](https://github.com/vshatravenko))
- Reorganized templates [\#1](https://github.com/helios-technologies/kite/pull/1) ([vshatravenko](https://github.com/vshatravenko))

## [v0.0.4](https://github.com/helios-technologies/kite/tree/v0.0.4) (2017-08-25)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.3...v0.0.4)

## [v0.0.3](https://github.com/helios-technologies/kite/tree/v0.0.3) (2017-08-24)
[Full Changelog](https://github.com/helios-technologies/kite/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/helios-technologies/kite/tree/v0.0.2) (2017-08-24)
