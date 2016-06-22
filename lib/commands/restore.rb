require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile restore' implementation
class Restore < Command
  def self.options_messages
    %(  restore \t $ lookfile restore
  \t\t - Restore files from lookfile to user pc
    )
  end

  def self.command_name
    'restore'
  end

  def self.parent
    Look
  end

  def self.run(*)
    puts Lookfile.restore
  end
end
