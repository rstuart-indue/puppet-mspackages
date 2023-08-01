# @summary Installs a given package name.
#
# Installs a given package name with the 'ACCEPT_EULA=Y' environment variable
# set, as required for Microsoft packages.
#
# Used by the `mspackages` resource type.
#
# @example
#   mspackages { 'msodbcsql17':
#       ensure =>  present,
#   }
define mspackages::package (
  Enum['absent','present','installed'] $ensure = present,
) {
    validate_legacy(String, 'validate_string', $name)

    require mspackages::repository

    case $facts['os']['family'] {
        'RedHat': {
            if $facts['os']['release']['major'] =~ /^(6|7|8|9).*?$/ {
                if $ensure in ['present', 'installed'] {
                    exec { "/usr/bin/yum install --enablerepo=packages-microsoft-com-prod -y ${name}":
                        environment => 'ACCEPT_EULA=Y',
                        unless      => "/bin/rpm -q ${name}",
                        require     => Class['Mspackages::Repository'],
                    }
                } elsif $ensure == 'absent' {
                    exec { "/usr/bin/yum remove -y ${name}":
                        onlyif      => "/bin/rpm -q ${name}",
                    }
                }
            } else {
                fail("${module_name} is not yet supported for ${facts['os']['family']}-based OS ${facts['os']['name']} version ${facts['os']['release']['major']}")
            }
        }

        'Debian': {
            if (
                (($facts['os']['name'] == 'Ubuntu') and (versioncmp($facts['os']['release']['full'], '14.04') >= 0)) or
                (($facts['os']['name'] == 'Debian') and (versioncmp($facts['os']['release']['major'], '8') >= 0))
            ) {
                if $ensure in ['present', 'installed'] {
                    exec { "/usr/bin/apt install -y ${name}":
                        environment => 'ACCEPT_EULA=Y',
                        unless      => "/usr/bin/apt-mark showinstall | grep -q '${name}' && true || false",
                        require     => Class['Mspackages::Repository'],
                    }
                } elsif $ensure == 'absent' {
                    exec { "/usr/bin/apt remove -y ${name}":
                        onlyif      => "/usr/bin/apt-mark showinstall | grep -q '${name}' && true || false",
                    }
                }
            } else {
                fail("${module_name} is not yet supported for ${facts['os']['family']}-based OS ${facts['os']['name']} version ${facts['os']['release']['full']}")
            }
        }

        default: {
            fail("${module_name} is not supported for ${facts['os']['family']}-based OS ${facts['os']['name']} version ${facts['os']['release']['major']}")
        }
    }
}
