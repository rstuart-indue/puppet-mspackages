# @summary Includes the Microsoft Packages for Linux repository.
#
# Includes the Microsoft Packages repository based on Linux distribution.
#
# @example
#   include mspackages::repository
class mspackages::repository {
    case $::osfamily {
        'RedHat': {
            # RHEL / CentOS version 6.x, 7.x, 8.x
            if $::operatingsystemmajrelease =~ /^(6|7|8).*?$/ {
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
                fail("${module_name} is not yet supported for ${::osfamily}-based OS ${::operatingsystem} version ${::operatingsystemmajrelease}")
            }
        }

        'Debian': {
            if ($::operatingsystem == 'Ubuntu') and (versioncmp($::operatingsystemrelease, '14.04') >= 0) {
                # Ubuntu version uses YY.MM release
                # FIXME: 21.04 packages may not yet exist, so drop to 20.10
                if (versioncmp($::operatingsystemrelease, '21.04') >= 0) {
                    $version_path = 'ubuntu/20.10'
                    $release      = 'groovy'
                } else {
                    $version_path = "ubuntu/${::operatingsystemrelease}"
                }
            } elsif ($::operatingsystem == 'Debian') and (versioncmp($::operatingsystemmajrelease, '8') >= 0) {
                # Debian version uses major release
                $version_path = "debian/${::operatingsystemmajrelease}"
            }

            if !defined('$release') {
                $release = $facts['lsbdistcodename']
            }

            if defined('$version_path') {
                apt::source { 'packages-microsoft-com-prod':
                    ensure        => present,
                    comment       => "Microsoft Packages for Linux - ${::operatingsystem} ${::operatingsystemrelease}",
                    location      => "https://packages.microsoft.com/${version_path}/prod",
                    release       => $release,
                    pin           => 900,
                    notify_update => true,
                    key           => {
                        id     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
                        source => 'https://packages.microsoft.com/keys/microsoft.asc',
                    },
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
