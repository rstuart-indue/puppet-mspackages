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
    Variant[Stdlib::Compat::String, String[1]] $ensure = present,
) {
    validate_legacy(String, 'validate_string', $name)
    validate_legacy(String, 'validate_re', $ensure, '^(present|installed|absent)$')

    require mspackages::repository

    case $::osfamily {
        'RedHat': {
            if $::operatingsystemmajrelease =~ /^(6|7).*?$/ {
                if $ensure in ['present', 'installed'] {
                    exec { "/usr/bin/yum install -y ${name}":
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
                fail("${module_name} is not yet supported for OS ${::osfamily}} version ${::operatingsystemmajrelease}")
            }
        }

        'Debian': {
            fail("${module_name} is not yet supported for OS ${::osfamily}} version ${::operatingsystemmajrelease}")
        }

        default: {
            fail("${module_name} is not supported for OS ${::osfamily}} version ${::operatingsystemmajrelease}")
        }
    }
}
