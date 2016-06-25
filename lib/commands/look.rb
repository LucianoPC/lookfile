require 'command'
require 'commands/init'
require 'commands/add'
require 'commands/set_repository'
require 'commands/push'
require 'commands/show'
require 'commands/status'
require 'commands/restore'

# Command 'lookfile' implementation
class Look < Command
  def self.options_messages
    'asdsad'
  end

  def self.usage_bottom
    user_name = File.expand_path('~').scan(%r{/home/(.+)+}).flatten.first
    %(  Attention: \t To push files every five minutes copy add the following
  \t\t line on /etc/crontab:
  \t\t */5 *  * * *  #{user_name} lookfile push
    )
  end

  def self.command_name
    'lookfile'
  end

  def self.parent
    nil
  end

  def self.childrens
    [Init, Add, Push, Status, Show, Restore, SetRepository]
  end
end
