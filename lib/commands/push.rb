require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile update' implementation
class Push < Command
  def self.options_messages
    %(  push \t\t $ lookfile push
  \t\t - Push files on lookfile to repository
    )
  end

  def self.command_name
    'push'
  end

  def self.parent
    Look
  end

  def self.run(*)
    message = Lookfile.push
    puts message
  end
end
