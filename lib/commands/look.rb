require 'command'
require 'commands/init'
require 'commands/add'

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
    [Init, Add]
  end
end
