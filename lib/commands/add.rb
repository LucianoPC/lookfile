require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile add' implementation
class Add < Command
  def self.options_messages
    %(  add \t\t $ lookfile add [file 0] [file 1] ... [file n]
  \t\t - Add files to lookfile
    )
  end

  def self.command_name
    'add'
  end

  def self.parent
    Look
  end

  def self.run(argv)
    added_files, error_files = Lookfile.add_files(argv)
    puts Lookfile.show_files('Added files:', added_files)
    puts Lookfile.show_files('Error to add files, check if exists:',
                             error_files)
  end
end
