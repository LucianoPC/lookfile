require 'fileutils'
require 'lookfile'

# module for help with git
module Git
  module_function

  BASE_DIR = '~/'.freeze
  LOOKFILE_DIR = '.lookfile'.freeze
  SHOW_PUSH_MESSAGE = true

  def load_git_command(base_dir = BASE_DIR)
    directory = Lookfile.load_lookfile_dir(base_dir)
    "git -C '#{directory}'"
  end

  def init(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    `#{git} init`
  end

  def remote?(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    remote = `#{git} remote`
    remote.include?('origin')
  end

  def set_remote(repository_ssh_name, base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    `#{git} remote remove origin` if remote?(base_dir)
    `#{git} remote add origin #{repository_ssh_name}`
  end

  def rebase(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    branchs = `#{git} branch -a`
    return nil unless branchs.include?('remotes/origin/master')
    `#{git} fetch origin -p`
    `#{git} pull origin master`
  end

  def status(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    untracked_files = `#{git} ls-files --others --exclude-standard`.split
    deleted_files = `#{git} ls-files --deleted`.split
    modified_files = `#{git} ls-files --modified`.split - deleted_files
    message = Lookfile.show_files("\nAdded files:", untracked_files)
    message += Lookfile.show_files("\nModified files:", modified_files)
    message += Lookfile.show_files("\nDeleted files:", deleted_files)
    message.strip
  end

  def commit(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    message = status(base_dir)
    `#{git} add --all`
    return nil if !make_commit?(message, base_dir) || message.empty?
    message
  end

  def push(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    command = "#{git} push origin master"
    command += ' 2>/dev/null' unless SHOW_PUSH_MESSAGE

    `#{command}`
  end

  def make_commit?(message, base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    commit = `#{git} commit -m "#{message}"`
    return false if commit.include?('nothing to commit')
    true
  end
end
