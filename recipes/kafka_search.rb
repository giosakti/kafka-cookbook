#
# Cookbook:: kafka
# Recipe:: kafka_search 
#
# Copyright:: 2018, BaritoLog.
require 'json'
require_relative '../libraries/yggdrasil'

# Don't continue if these variables are empty
return if node[cookbook_name]['zookeeper']['hosts'].empty?

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['zookeeper'] ||= {}

# Fetch hosts from yggdrasil, if enabled
if node[cookbook_name]['yggdrasil']['enabled']
  yggdrasil_host = node[cookbook_name]['yggdrasil']['host']
  yggdrasil_port = node[cookbook_name]['yggdrasil']['port']
  yggdrasil_api_version = node[cookbook_name]['yggdrasil']['api_version']
  yggdrasil_token = node[cookbook_name]['yggdrasil']['token']
  yggdrasil_namespace = node[cookbook_name]['yggdrasil']['namespace']
  yggdrasil_overrides = node[cookbook_name]['yggdrasil']['overrides']

  yggdrasil = Yggdrasil.new(yggdrasil_host, yggdrasil_port, yggdrasil_api_version, yggdrasil_token)
  yggdrasil_config = yggdrasil.fetch_configs(yggdrasil_namespace, yggdrasil_overrides)

  config = JSON.parse(yggdrasil_config["zookeeper_hosts"])
  node.run_state[cookbook_name]['zookeeper']['hosts'] ||= {}
  node.run_state[cookbook_name]['zookeeper']['hosts'] = config
elsif !node[cookbook_name]['zookeeper']['hosts'].empty?
  node.run_state[cookbook_name]['zookeeper']['hosts'] = node[cookbook_name]['zookeeper']['hosts']
else
  # Don't continue if no hosts are supplied
  return
end
