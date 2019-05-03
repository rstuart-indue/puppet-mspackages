
# mspackages

A Puppet Module that makes it easy to include Microsoft packages for Linux operating systems.

#### Table of Contents

1. [Description](#description)
2. [Usage](#usage)
3. [Limitations](#limitations)
4. [Development](#development)

## Description

This module sets up the required Microsoft repository based on distribution, and then installs the given package(s) with the environment variable `ACCEPT_EULA=Y` set.

This module was developed specifically to install the Microsoft ODBC Driver for SQL Server on Linux as Puppet's native `package` type does not support setting environment variables.

See https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017 for more information.

## Usage

You can include packages either by defining resources within a manifest, or, within a hiera configuration file.

1. `manifest.pp` example:
```
  # Add the required Microsoft Packages Repo and
  # Install the Linux Microsoft ODBC Driver for MS SQL Server.
  mspackages { 'msodbcsql17':
    ensure => present,
  }
```
or to remove packages:
```
  mspackages { 'msodbcsql17':
    ensure => absent,
  }
```

2. `hieradata.yaml` example:
For node-specific configurations, ensure your `manifest.pp` includes `hiera_include('classes')`. You can then update your node configuration as follows:
```
classes:
  - 'mspackages::install'

mspackages::install::packages:
  - 'msodbcsql17'
  - 'mssql-tools'
```
or to remove packages:
```
mspackages::remove::packages:
  - 'mssql-tools'
```

## Limitations

RedHat/CentOS 6/7 are supported, with future implementation possible for Debian/Ubuntu compatibility.

## Development

Additional distribution compatibility can be added as stubs are available in both `repository.pp` and `package.pp`.
