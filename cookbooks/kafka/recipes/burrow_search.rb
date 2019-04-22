# Cookbook:: kafka
# Recipe:: burrow_search
#
# Copyright:: 2018, BaritoLog.
#
#

require 'json'
require_relative '../libraries/yggdrasil'

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['burrow'] ||= {}
node.run_state[cookbook_name]['burrow']['zookeeper_clusters'] = node[cookbook_name]['burrow']['zookeeper_clusters'] || []

# Override zookeeper hosts from yggdrasil, if enabled
if node[cookbook_name]['yggdrasil']['enabled']
  yggdrasil_namespace = node[cookbook_name]['yggdrasil']['namespace']
  yggdrasil_overrides = node[cookbook_name]['yggdrasil']['overrides']

  yggdrasil = Yggdrasil.new(node[cookbook_name]['yggdrasil'])
  yggdrasil_config = yggdrasil.fetch_configs(yggdrasil_namespace, yggdrasil_overrides)

  config = JSON.parse(yggdrasil_config['zookeeper_hosts'])
  node.run_state[cookbook_name]['burrow']['zookeeper_clusters'] = config
end
