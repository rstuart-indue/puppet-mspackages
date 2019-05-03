# @summary Includes the Microsoft Packages for Linux repository.
#
# Includes the Microsoft Packages repository based on Linux distribution.
#
# @example
#   include mspackages::repository
class mspackages::repository {
    case $::osfamily {
        'RedHat': {
            # RHEL / CentOS version 6.x and 7.x
            if $::operatingsystemmajrelease =~ /^(6|7).*?$/ {
                yumrepo { 'packages-microsoft-com-prod':
                    ensure   => present,
                    name     => 'packages-microsoft-com-prod',
                    descr    => "Microsoft Packages for Linux - RHEL ${::operatingsystemmajrelease}",
                    baseurl  => "https://packages.microsoft.com/rhel/${::operatingsystemmajrelease}/prod/",
                    gpgkey   => 'https://packages.microsoft.com/keys/microsoft.asc',
                    gpgcheck => 1,
                    enabled  => 1,
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
