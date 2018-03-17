define snmpcollector::measurement(
		$ensure		 				= 'present',
		String $get_mode		 	= 'indexed',
		String $index_oid			= '',
		String $tag_oid				= '',
		String $index_tag 			= '',
		String $index_tag_format	= '',
		Boolean $index_as_value		= false,
		Array $fields		 		= [],
		String $description			= 'MANAGED BY PUPPET'
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_measurement { $title :
		ensure => $ensure,
		get_mode => $get_mode,
		index_oid => $index_oid,
		tag_oid => $tag_oid,
		index_tag => $index_tag,
		index_tag_format => $index_tag_format,
		index_as_value => $index_as_value,
		fields => $fields,
		description => $description
	} ~> Class['snmpcollector::reload']
}