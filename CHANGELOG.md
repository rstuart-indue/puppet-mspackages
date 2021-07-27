# Changelog

### 1.0.0: 2021-07-27
* On Ubuntu `>= 21.04` the `20.10` repository is forcibly used until more packages are available
* Added RHEL 8 support
* Upgraded PDK version from `1.18.0` to `2.1.1`
* Renamed `master` branch to `main`

### 0.1.1: 2020-06-03
* Added support for Debian and Ubuntu
  * **NOTE:** On Ubuntu `>= 20.04` the `19.10` repository is forcibly used until more packages are available ([potentially July/August 2020](https://github.com/microsoft/msphpsql/issues/1110))
* Upgraded PDK version from `1.10.0` to `1.18.0`
* Updated `metadata.json` requirements and included project/issue URLs
* GitLab CI now builds releases using the official `puppet-dev-tools` image

### 0.1.0: 2019-05-03
* Initial release
* Only compatible with RHEL (RedHat/CentOS) 6/7
