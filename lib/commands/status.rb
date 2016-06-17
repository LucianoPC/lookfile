require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile status' implementation
class Status < Command
  def self.options_messages
    %(  status \t $ lookfile status
  \t\t - Show status of files on lookfile
    )
  end

  def self.command_name
    'status'
  end

  def self.parent
    Look
  end

  def self.run(*)
    puts Lookfile.status
  end
end
