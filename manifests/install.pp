# @summary Installs given list of packages.
#
# Can be called from a hiera config YAML.
#
# @example
#   classes:
#       - 'mspackages::install'
#
#   mspackages::install::packages:
#       - 'msodbcsql17'
#       - 'mssql-tools'
class mspackages::install (
    Variant[Stdlib::Compat::Array, Array[String, 0]] $packages = [],
) {
    validate_legacy(Array, 'validate_array', $packages)

    $packages.each |String $package| {
        $package_hash = {
            $package => {
                name   => $package,
                ensure => present,
            }
        }

        validate_legacy(Hash, 'validate_hash', $package_hash)

        create_resources('mspackages::package', $package_hash)
    }
}
