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
    Variant[Stdlib::String, String[1]] $ensure = present,
) {
    validate_legacy(String, 'validate_string', $name)
    validate_legacy(String, 'validate_re', $ensure, '^(present|installed|absent)$')

    require mspackages::repository

    case $::osfamily {
        'RedHat': {
            if $::operatingsystemmajrelease =~ /^(6|7|8).*?$/ {
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
                fail("${module_name} is not yet supported for ${::osfamily}-based OS ${::operatingsystem} version ${::operatingsystemmajrelease}")
            }
        }

        'Debian': {
            if (
                (($::operatingsystem == 'Ubuntu') and (versioncmp($::operatingsystemrelease, '14.04') >= 0)) or
                (($::operatingsystem == 'Debian') and (versioncmp($::operatingsystemmajrelease, '8') >= 0))
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
                fail("${module_name} is not yet supported for ${::osfamily}-based OS ${::operatingsystem} version ${::operatingsystemrelease}")
            }
        }

        default: {
            fail("${module_name} is not supported for ${::osfamily}-based OS ${::operatingsystem} version ${::operatingsystemmajrelease}")
        }
    }
}
