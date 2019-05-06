module Snmpcollector
  class Mapping
    def self.snmpdevice
      {'name'=>'ID',
       'host'=>'Host',
       'port'=>'Port',
       'retries'=>'Retries',
       'timeout'=>'Timeout',
       'repeat'=>'Repeat',
       'active'=>'Active',
       'snmp_version'=>'SnmpVersion',
       'snmp_community'=>'Community',
       'snmpv3_sec_level'=>'V3SecLevel',
       'snmpv3_auth_user'=>'V3AuthUser',
       'snmpv3_auth_pass'=>'V3AuthPass',
       'snmpv3_auth_prot'=>'V3AuthProt',
       'snmpv3_priv_pass'=>'V3PrivPass',
       'snmpv3_priv_prot'=>'V3PrivProt',
       'disable_bulk'=>'DisableBulk',
       'max_repetitions'=>'MaxRepetitions',
       'frequency'=>'Freq',
       'update_frequency'=>'UpdateFltFreq',
       'concurrent_gather'=>'ConcurrentGather',
       'output_database'=>'OutDB',
       'log_level'=>'LogLevel',
       'log_file'=>'LogFile',
       'snmp_debug'=>'SnmpDebug',
       'device_tag_name'=>'DeviceTagName',
       'device_tag_value'=>'DeviceTagValue',
       'extra_tags'=>'ExtraTags',
       'description'=>'Description',
       'measurement_groups'=>'MeasurementGroups',
       'measurement_filters'=>'MeasFilters'}
    end

    def self.influxserver
  		{'name' => 'ID',
  		'host' => 'Host',
  		'port' => 'Port',
  		'database' => 'DB',
  		'username' => 'User',
  		'password' => 'Password',
  		'retention' => 'Retention',
  		'precision' => 'Precision',
  		'timeout' => 'Timeout',
  		'user_agent' => 'UserAgent',
  		'description' => 'Description',}
  	end

  	def self.oidcondition
  		{'name' => 'ID',
  		'is_multiple' => 'IsMultiple',
  		'condition' => 'OIDCond',
  		'condition_type' => 'CondType',
  		'condition_value' => 'CondValue',
  		'description' => 'Description',}
  	end

    def self.metric
      {'name' => 'ID',
      'field_name' => 'FieldName',
      'description' => 'Description',
      'base_oid' => 'BaseOID',
      'datasource_type' => 'DataSrcType',
      'get_rate' => 'GetRate',
      'scale' => 'Scale',
      'shift' => 'Shift',
      'is_tag' => 'IsTag',
      'extra_data' => 'ExtraData',
      'conversion' => 'Conversion',}
    end

    def self.measurement
      {'name' => 'ID',
        'get_mode' => 'GetMode',
        'index_oid' => 'IndexOID', 
        'tag_oid' => 'TagOID', 
        'index_tag' => 'IndexTag', 
        'index_tag_format' => 'IndexTagFormat',
        'index_as_value' => 'IndexAsValue',
        'fields' => 'Fields',
        'description' => 'Description',}
    end

    def self.measurement_fields
      {'name' => 'ID',
        'report' => 'Report',}
    end

    def self.measurement_group
      {'name' => 'ID',
        'measurements' => 'Measurements',
        'description' => 'Description',}
    end

    def self.measurement_filter
      {'name' => 'ID',
        'filter_name' => 'FilterName',
        'measurement' => 'IDMeasurementCfg',
        'filter_type' => 'FType',
        'enable_alias' => 'EnableAlias',
        'description' => 'Description',}
    end
  end
end

