require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))

Puppet::Type.type(:snmpcollector_server).provide(:ruby) do

  confine :feature => [:restclient, :json, :yaml]

  # Nice and dodgy to always ensure the resource 'exists'
  def exists?
    return true
  end

  def refresh
    Snmpcollector::Client.new.reload
  end

end