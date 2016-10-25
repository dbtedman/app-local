#
# NodeJS and MPM install.
#
# Required Modules:
#   https://forge.puppet.com/stahnma/epel
#
class app_local::components::node {

  $node_version_check = '6.9';
  $npm_version_check = '3.10';

  # https://nodejs.org
  package { 'nodejs':
    ensure  => 'installed',
    require => Class['epel'],
  }

  # https://www.npmjs.com
  package { 'npm':
    ensure  => 'installed',
    require => Package['nodejs'],
  }

  exec { 'npm-clear-cache':
    command     => 'npm cache clean -f',
    refreshonly => true,
    user        => "root",
    group       => "root",
  }

  exec { 'npm-install-n':
    command => 'npm install -g n',
    notify  => [
      Exec['npm-clear-cache'],
    ],
    unless  => 'which -s n',
    require => [
      Package['nodejs'],
      Package['npm'],
    ],
    user    => "root",
    group   => "root",
  }

  exec { 'node-update-latest-stable':
    command => 'n lts',
    unless  => "! node --version | grep -q v${node_version_check}",
    require => [
      Exec['npm-install-n'],
    ],
    user    => "root",
    group   => "root",
  }

  exec { 'npm-update-latest':
    command => 'npm install npm@latest -g',
    unless  => "npm --version | grep -q ${npm_version_check}",
    require => [
      Exec['node-update-latest-stable'],
    ],
    user    => "root",
    group   => "root",
  }
}
