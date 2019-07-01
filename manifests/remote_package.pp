define snmpcollector::remote_package($packagename=$title,$url,$creates){        
  if $osfamily == 'Debian' {
    # Download and install
    exec{"download-$packagename":
      command=>"/usr/bin/curl -o /tmp/$packagename $url",
      creates=>"/tmp/$packagename",
      require=>Package['curl']
    }
    package{ 'snmpcollector' :
      ensure=> 'latest',
      require=>Exec["download-$packagename"],
      source=>"/tmp/$packagename",
      provider=>"dpkg"
    }
  }
  elsif $osfamily == 'RedHat' {
    # Install directly from the web
    package{ 'snmpcollector' :
      ensure => 'installed',
      source=>"$url",
      provider=>"rpm"
    }
  }
}
