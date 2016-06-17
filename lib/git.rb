require 'fileutils'
require 'lookfile'

# module for help with git
module Git
  module_function

  BASE_DIR = '~/'.freeze
  LOOKFILE_DIR = '.lookfile'.freeze

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

  def commit(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    untracked_files = `#{git} ls-files --others --exclude-standard`.split
    modified_files = `#{git} ls-files --modified`.split
    deleted_files = `#{git} ls-files --deleted`.split
    modified_files = modified_files - deleted_files
    `#{git} add --all`
    message = Lookfile.show_files("\nAdded files:", untracked_files)
    message += Lookfile.show_files("\nModified files:", modified_files)
    message += Lookfile.show_files("\nDeleted files:", deleted_files)
    return nil unless make_commit?(message, base_dir)
    message
  end

  def push(base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    `#{git} push origin master`
  end

  def make_commit?(message, base_dir = BASE_DIR)
    git = load_git_command(base_dir)
    commit = `#{git} commit -m "#{message}"`
    return false if commit.include?('nothing to commit')
    true
  end
end

