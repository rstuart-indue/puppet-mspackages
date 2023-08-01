# @summary Installs a given package name.
#
# Installs a given package name with the 'ACCEPT_EULA=Y' environment variable
# set, as required for Microsoft packages.
#
# @example
#   mspackages { 'msodbcsql17':
#       ensure =>  present,
#   }
define mspackages (
    Variant[Stdlib::String, String[1]] $ensure = present,
) {
    validate_legacy(String, 'validate_string', $name)
    validate_legacy(String, 'validate_re', $ensure, '^(present|installed|absent)$')

    $package_hash = {
        $name => {
            name   => $name,
            ensure => $ensure,
        }
    }

    validate_legacy(Hash, 'validate_hash', $package_hash)

    create_resources('mspackages::package', $package_hash)
}
