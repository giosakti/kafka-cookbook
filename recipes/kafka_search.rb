#
# Cookbook:: kafka
# Recipe:: kafka_search 
#
# Copyright:: 2018, BaritoLog.
require 'json'
require_relative '../libraries/yggdrasil'

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['zookeeper'] ||= {}
node.run_state[cookbook_name]['zookeeper']['hosts'] = node[cookbook_name]['zookeeper']['hosts'] || []

# Override zookeeper hosts from yggdrasil, if enabled
if node[cookbook_name]['yggdrasil']['enabled']
  yggdrasil_namespace = node[cookbook_name]['yggdrasil']['namespace']
  yggdrasil_overrides = node[cookbook_name]['yggdrasil']['overrides']

  yggdrasil = Yggdrasil.new(node[cookbook_name]['yggdrasil'])
  yggdrasil_config = yggdrasil.fetch_configs(yggdrasil_namespace, yggdrasil_overrides)

  config = JSON.parse(yggdrasil_config["zookeeper_hosts"])
  node.run_state[cookbook_name]['zookeeper']['hosts'] ||= {}
  node.run_state[cookbook_name]['zookeeper']['hosts'] = config
end
