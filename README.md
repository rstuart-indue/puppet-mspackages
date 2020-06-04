
# mspackages

A Puppet Module that makes it easy to include Microsoft packages for Linux operating systems.

Available on [PuppetForge](https://forge.puppet.com/aitalian/mspackages).

#### Table of Contents

1. [Description](#description)
2. [Requirements](#requirements)
3. [Usage](#usage)
4. [Development](#development)

## Description

This module adds the [Linux Software Repository for Microsoft Products](https://docs.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software) based on distribution, and then installs the given package(s) with the environment variable `ACCEPT_EULA=Y` set.

Installing Microsoft packages introduces an interactive EULA acceptance prompt; since Puppet runs are non-interactive, an environment variable can be set to implicitly accept the EULA and bypass the prompt. This is possible by using a new resource type introduced with this module: `mspackages`. Traditional usage of Puppet's `package` resource type does not support passing environment variables (for reference, see [PUP-1526](https://tickets.puppetlabs.com/browse/PUP-1526) where this request is outstanding).

This module was developed specifically to install the [Microsoft ODBC Driver for SQL Server on Linux](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017), which prompts to [accept the EULA](https://aka.ms/odbc17eula), however, any package available for the target distribution is supported.

*Disclaimer:* You are responsible for reviewing the EULA applicable to the software you are agreeing to install.

## Requirements

* Puppet `>= 4.1.0` or Puppet Enterprise `>= 2016.4.x`
* `puppetlabs/stdlib` (`>= 4.13.0`)
* `puppetlabs/apt` `>= 2.3.0` for Debian-based distributions
* `puppetlabs/yumrepo_core` `>= 1.0.0` for RedHat-based distributions
* Linux OS: RedHat, CentOS, Debian, Ubuntu

For complete up-to-date requirements, see [metadata.json](metadata.json).

## Usage

To begin, you first need to include the module in your `Puppetfile` and run *Bolt*, *r10k* or *Code Manager*, or, install it manually using the Puppet module tool.

Once installed, you can include packages either by defining resources within a manifest or hiera configuration file, and then apply it.

1. `manifest.pp` example:
```Puppet
# Add the required Microsoft Packages Repo and
# Install the Linux Microsoft ODBC Driver for MS SQL Server.
mspackages { 'msodbcsql17':
  ensure => present,
}
```
or to remove packages:
```Puppet
mspackages { 'msodbcsql17':
  ensure => absent,
}
```

On a standalone Debian-based system, you can apply this using a local manifest and [Puppet Bolt](https://puppet.com/open-source/bolt/):
```Shell
$ cat > Puppetfile << EOF
mod 'puppetlabs/stdlib'
mod 'puppetlabs/apt'
mod 'aitalian/mspackages'
EOF

$ cat > manifest.pp << EOF
mspackages { 'msodbcsql17':
  ensure => present,
}
EOF

$ bolt puppetfile install --puppetfile ./Puppetfile

$ puppet apply --modulepath=~/.puppetlabs/bolt/modules manifest.pp
```

2. `hieradata.yaml` example:
For node-specific configurations, ensure your `manifest.pp` includes `hiera_include('classes')`. You can then update your node configuration as follows:
```YAML
classes:
  - 'mspackages::install'

mspackages::install::packages:
  - 'msodbcsql17'
  - 'mssql-tools'
```
or to remove packages:
```YAML
mspackages::remove::packages:
  - 'mssql-tools'
```

## Development

Pull requests are welcome via [GitHub](https://github.com/aitalian/puppet-mspackages). Additional distribution compatibility can be added in both `repository.pp` and `package.pp`. This module was built using the [Puppet Development Kit (PDK)](https://puppet.com/docs/pdk/1.x/pdk.html).