require 'command'
require 'commands/init'
require 'commands/add'
require 'commands/set_repository'
require 'commands/push'
require 'commands/show'
require 'commands/status'
require 'commands/restore'

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
    [Init, Add, Push, Status, Show, Restore, SetRepository]
  end
end
