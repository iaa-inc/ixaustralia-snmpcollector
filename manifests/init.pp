# Class: snmpcollector
# ===========================
#
# Full description of class snmpcollector here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
    # class {'snmpcollector' :
    #     	instance_name => 'instance01',
    # 		web_port => 8090,
    # 		admin_username => 'admin',
    # 		admin_password => 'strongpassword',
    # 		service_enabled => true,
    # }
#
# Authors
# -------
#
# Author Name: Tim Raphael <tim@ix.asn.au>
#
#
class snmpcollector (
  String $version = 'latest',
  String $instance_name,
  Integer $web_port,
  String $admin_username,
  String $admin_password,
  Boolean $service_enabled,
)
{

  class {'snmpcollector::install': 
    version => $version
  } -> 
  class {'snmpcollector::configure' :
    instance_name => $instance_name,
    web_port => $web_port,
    admin_username => $admin_username,
    admin_password => $admin_password,
    service_enabled => $service_enabled
  } ~> 
  class {'snmpcollector::service' :
    enable => $service_enabled
  }
}
