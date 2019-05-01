class snmpcollector::install (
    String $version = 'latest'
)
{
  # We can't reassign variables, so set it inside the right OS fact.
  # Check for 16.04, otherwise assume 18.04
  if $osfamily == 'Debian' {    
    if $osrelease == '16.04' {
      $packages = [
        'build-essential',
        'bison',
        'openssl',
        'libreadline6',
        'libreadline6-dev',
        'curl',
        'git-core',
        'zlib1g', 
        'zlib1g-dev', 
        'libssl-dev', 
        'libyaml-dev',
        'libxml2-dev',
        'autoconf',
        'libc6-dev',
        'ncurses-dev',
        'automake',
        'libtool'
      ]
    }
    else {
      $packages = [
        'build-essential',
        'bison',
        'openssl',
        'libreadline7',
        'libreadline6-dev',
        'curl',
        'git-core',
        'zlib1g', 
        'zlib1g-dev', 
        'libssl-dev', 
        'libyaml-dev',
        'libxml2-dev',
        'autoconf',
        'libc6-dev',
        'ncurses-dev',
        'automake',
        'libtool'
      ]
    }
  }
  # CentOS / RHEL
  elsif $osfamily == 'RedHat' {
    $packages = [
      'gcc',
      'gcc-c++',
      'make',
      'bison',
      'openssl',
      'openssl-devel',
      'readline',
      'readline-devel',
      'curl',
      'git',
      'zlib',
      'zlib-devel',
      'libyaml-devel',
      'libxml2-devel',
      'autoconf',
      'glibc-devel',
      'ncurses-devel',
      'automake',
      'libtool'
    ]
  }
  	    
  $puppet_gems = [
    'rest-client',
    'json'
  ]
  
  # Same deal with the snmpcollector package - slight differences between Ubuntu & CentOS filenames.
  # Note that the Debian version uses underscores whereas the Redhat version uses hyphens..
  #
  # Debian
  # http://snmpcollector-rel.s3.amazonaws.com/builds/snmpcollector_latest_amd64.deb
  # Redhat
  # http://snmpcollector-rel.s3.amazonaws.com/builds/snmpcollector-latest-1.x86_64.rpm
  
  if $osfamily == 'Debian' {
    $package_path = "snmpcollector_${version}_amd64.deb"
  }  
  elsif $osfamily == 'RedHat' {
    $package_path = "snmpcollector-${version}-1.x86_64.rpm"
  }  
  
  # Dependency for Package install
  package{ $packages :
    ensure => latest,
  } ->  
  # Gem requirements
  package { $puppet_gems:
    ensure   => 'installed',
    provider => 'puppet_gem',
  } ->  
  # Pull down the required version and install.
  snmpcollector::remote_package { $package_path :
    url => "https://snmpcollector-rel.s3.amazonaws.com/builds/${package_path}",
    creates => "/usr/sbin/snmpcollector",
  }
}
