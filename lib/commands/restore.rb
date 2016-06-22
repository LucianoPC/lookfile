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
    files_path = []
    Lookfile.list_files.each do |file_path|
      print "Restore file #{file_path} (Y/n): "
      option = gets.chomp.upcase
      option = 'Y' if option.empty?
      files_path << file_path if option == 'Y'
    end
    puts Lookfile.restore(files_path)
  end
end
