require 'lookfile/version'
require 'fileutils'

# main module of lookfile gem
module Lookfile
  module_function

  BASE_DIR = '~/'.freeze
  LOOKFILE_DIR = '.lookfile'.freeze

  def initialize(base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    return nil if File.directory?(lookfile_dir)
    Dir.mkdir(lookfile_dir)
    git_init(base_dir)
    lookfile_dir
  end

  def add_files(files_path, base_dir = BASE_DIR)
    files_path = [files_path] unless files_path.is_a?(Array)
    files_path = files_path.map { |file_path| File.expand_path(file_path) }
    added_files = []
    error_files = []
    files_path.each do |file_path|
      list = add_one_file(file_path, base_dir) ? added_files : error_files
      list << file_path
    end
    [added_files, error_files]
  end

  def set_repository(repository_ssh_name, base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    git_set_remote(repository_ssh_name, base_dir)
    git_rebase(base_dir)
  end

  def update(base_dir = BASE_DIR)
    update_files(base_dir)
    message = git_commit(base_dir)
    return 'Nothing to update' if message.nil?
    git_push(base_dir) if git_remote?(base_dir)
    message
  end

  def add_one_file(file_path, base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    folder_path = lookfile_dir + file_path.scan(%r{(.+)\/}).flatten.first
    FileUtils.mkpath(folder_path)
    begin
      FileUtils.cp(file_path, folder_path)
      true
    rescue
      false
    end
  end

  def show_files(header_message, files_path)
    message = "#{header_message}" unless files_path.empty?
    files_path.each do |file_path|
      message += "\n  #{file_path}"
    end
    message ||= ""
    message
  end

  def load_lookfile_dir(base_dir = BASE_DIR)
    base_dir = File.expand_path(base_dir)
    base_dir += '/' if base_dir[-1] != '/'
    base_dir + LOOKFILE_DIR
  end

  def load_git_dir(base_dir = BASE_DIR)
    directory = load_lookfile_dir(base_dir)
    "git -C '#{directory}'"
  end

  def update_files(base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    files_regex = /^#{lookfile_dir}(?!\/.git)(.+)$/
    files_path = `find #{lookfile_dir} -type f`.scan(files_regex).flatten
    add_files(files_path, base_dir)
  end

  def git_init(base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    `#{git_dir} init`
  end

  def git_remote?(base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    git_remote = `#{git_dir} remote`
    git_remote.include?('origin')
  end

  def git_set_remote(repository_ssh_name, base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    `#{git_dir} remote remove origin` if git_remote?(base_dir)
    `#{git_dir} remote add origin #{repository_ssh_name}`
  end

  def git_rebase(base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    git_branchs = `#{git_dir} branch -a`
    return nil unless git_branchs.include?('remotes/origin/master')
    `#{git_dir} fetch origin -p`
    `#{git_dir} pull origin master`
  end

  def git_commit(base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    untracked_files = `#{git_dir} ls-files --others --exclude-standard`.split
    modified_files = `#{git_dir} ls-files --modified`.split
    deleted_files = `#{git_dir} ls-files --deleted`.split
    modified_files = modified_files - deleted_files
    `#{git_dir} add --all`
    message = show_files("\nAdded files:", untracked_files)
    message += show_files("\nModified files:", modified_files)
    message += show_files("\nDeleted files:", deleted_files)
    return nil unless git_make_commit?(message, base_dir)
    message
  end

  def git_push(base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    `#{git_dir} push origin master`
  end

  def git_make_commit?(message, base_dir = BASE_DIR)
    git_dir = load_git_dir(base_dir)
    commit = `#{git_dir} commit -m "#{message}"`
    return false if commit.include?('nothing to commit')
    true
  end
end
