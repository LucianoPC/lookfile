require 'lookfile/version'
require 'fileutils'
require 'git'

# main module of lookfile gem
module Lookfile
  module_function

  BASE_DIR = '~/'.freeze
  LOOKFILE_DIR = '.lookfile'.freeze

  def initialize(base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    return nil if File.directory?(lookfile_dir)
    Dir.mkdir(lookfile_dir)
    Git.init(base_dir)
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
    Git.set_remote(repository_ssh_name, base_dir)
    Git.rebase(base_dir)
  end

  def update(base_dir = BASE_DIR)
    update_files(base_dir)
    message = Git.commit(base_dir)
    return 'Nothing to update' if message.nil?
    Git.push(base_dir) if Git.remote?(base_dir)
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

  def update_files(base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    files_regex = /^#{lookfile_dir}(?!\/.git)(.+)$/
    files_path = `find #{lookfile_dir} -type f`.scan(files_regex).flatten
    add_files(files_path, base_dir)
  end
end
