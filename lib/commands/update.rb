require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile update' implementation
class Update < Command
  def self.options_messages
    %(  update \t $ lookfile update
  \t\t - Update files to lookfile and push to repository
    )
  end

  def self.command_name
    'update'
  end

  def self.parent
    Look
  end

  def self.run(*)
    message = Lookfile.update
    puts message
  end
end
