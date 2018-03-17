define snmpcollector::remote_package($packagename=$title,$url,$creates){
	exec{"download-$packagename":
 		command=>"/usr/bin/curl -o /tmp/$packagename.deb $url",
 		creates=>"/tmp/$packagename.deb",
 		require=>Package['curl']
 	}

	package{ 'snmpcollector' :
		ensure=> 'latest',
 		require=>Exec["download-$packagename"],
 		source=>"/tmp/$packagename.deb",
 		provider=>"dpkg"
	}
}
