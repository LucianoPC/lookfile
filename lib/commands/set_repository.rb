require 'command'
require 'commands/look'

require 'lookfile'

# Command 'lookfile init' implementation
class SetRepository < Command
  def self.options_messages
    %(  setrepo \t $ lookfile setrepo [repository_ssh]
  \t\t - Set lookfile repository to save files
  \t\t - repository_ssh: link ssh to  repository
    )
  end

  def self.command_name
    'setrepo'
  end

  def self.parent
    Look
  end

  def self.run(argv)
    repository_ssh_name = argv.first
    if !repository_ssh_name.nil? && !repository_ssh_name.strip.empty?
      Lookfile.set_repository(repository_ssh_name)
      puts "Setted repository to: #{repository_ssh_name}"
    else
      puts "  Usage:\n\n#{options_messages}"
    end
  end
end
