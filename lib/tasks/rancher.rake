task :rancher do
  require 'rancher'

  api = Rancher.new
  stack = api.stack('1st73')

  compose = YAML.load(stack.dockerCompose)
  
end
