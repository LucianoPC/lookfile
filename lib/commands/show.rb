require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile show' implementation
class Show < Command
  def self.options_messages
    %(  show \t\t $ lookfile show
  \t\t - Show all files that are on lookfile
    )
  end

  def self.command_name
    'show'
  end

  def self.parent
    Look
  end

  def self.run(*)
    puts Lookfile.show
  end
end
