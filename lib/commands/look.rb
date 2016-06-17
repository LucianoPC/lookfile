require 'command'
require 'commands/init'
require 'commands/add'
require 'commands/set_repository'
require 'commands/update'
require 'commands/show'

# Command 'lookfile' implementation
class Look < Command
  def self.options_messages
    ''
  end

  def self.command_name
    'lookfile'
  end

  def self.parent
    nil
  end

  def self.childrens
    [Init, Add, Update, Show, SetRepository]
  end
end
