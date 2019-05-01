# snmpcollector

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with snmpcollector](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with snmpcollector](#beginning-with-snmpcollector)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module controls all aspects of the Snmpcollector project by Toni Moreno (https://github.com/toni-moreno/snmpcollector).
It can install and configure the required packages and authentication as well as add devices and snmp config via the Restful API.

## Setup

### Setup Requirements **OPTIONAL**

This module has only been tested on Ubuntu Xenial (16.04) LTS, Bionic (18.04) and CentOS 7.

### Beginning with snmpcollector

No setup is required other than adding a reference to this module to your Puppetfile.

```
mod 'ixaustralia/snmpcollector',
    :git => 'https://github.com/ixaustralia/ixaustralia-snmpcollector.git'
```

## Usage

### Install

```
class { 'snmpcollector' :
	instance_name => "name_for_collector_instance", # no spaces or special characters.
	web_port => 8090, # defaults to 8090
	admin_username => "admin",
	admin_password => "admin",
	service_enabled => true, # start at boot
}
```

### Configuration
See Examples -> init.pp for example configuration for the following included types and parametres.
Below is the absolute minimum required for each type, see manifest -> *.pp for all possible options.

* `snmpcollector::metric`

	Configure SNMP Metrics in the form of OIDs.
	Required parametres: field_name, base_oid, datasource_type.

* `snmpcollector::measurement`

 	Configure SNMP metrics into InfluxDB measurements 
 	Required Parametres: get_mode ('indexed' or 'value'), fields, optionally index_tag and index_oid if the get_mode is 'indexed'.

* `snmpcollector:oidcondition`

	Configure SNMP OID Conditions that can be later applied to filters.
	Required Parametres: condition, condition_type, condition_value

* `snmpcollector::measurement_filter`
    
    Configure SNMP filters based on OID conditions to filter out metrics based on logical expressions.
    Required Parametres: filter_type, measurement

* `snmpcollector::measurement_group`
	
    Configure SNMP Measurement groups to make nice "profiles" for collecting metrics from devices.
    Required Parametres: measurements (array)

* `snmpcollector::influxserver`
   
   Configure InfluxDB Instances.
   Require Parametres: host, username, password, database

* `snmpcollector::device`

   Configure SNMP Devices such as routers and switch.
   Required parametres: host, database (name of an influxserver instance)
