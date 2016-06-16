require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile init' implementation
class Init < Command
  def self.options_messages
    %(  init \t\t $ lookfile init
  \t\t - Initialize lookfile configurations
    )
  end

  def self.command_name
    'init'
  end

  def self.parent
    Look
  end

  def self.run(*)
    dir = Lookfile.initialize
    if dir
      puts "Initialize lookfile on: #{dir}"
    else
      puts 'lookfile was already initialized'
    end
  end
end
