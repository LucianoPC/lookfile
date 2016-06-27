require 'spec_helper'
require 'fileutils'
require 'commands/init'
require 'commands/add'
require 'commands/push'
require 'commands/status'
require 'commands/show'
require 'commands/restore'
require 'commands/set_repository'

describe Command do
  before do
    $stdin = STDIN
    $stdout = STDOUT
    stub_const('Lookfile::BASE_DIR', BASE_DIR)
    stub_const('Git::SHOW_PUSH_MESSAGE', false)
    Dir.mkdir(BASE_DIR)
    Dir.mkdir(GIT_DIR)
    `git -C '#{GIT_DIR}' init --bare`
    FileUtils.touch(TEST_FILE)
  end

  after do
    FileUtils.rm_rf(BASE_DIR)
    FileUtils.rm_rf(GIT_DIR)
    FileUtils.rm_rf(TEST_FILE)
  end

  describe '$ lookfile init' do
    it 'init Lookfile' do
      $stdout = StringIO.new
      Init.run
      $stdout.rewind

      expect_message = "Initialize lookfile on: #{Lookfile.load_lookfile_dir}"
      expect_message += "\n"
      expect($stdout.gets).to eq(expect_message)
    end

    it 'dont init Lookfile if its already initialized' do
      $stdout = StringIO.new
      Init.run
      Init.run
      $stdout.rewind
      $stdout.gets

      expect_message = "lookfile was already initialized\n"
      expect($stdout.gets).to eq(expect_message)
    end
  end

  describe '$ lookfile add' do
    it 'add new file into Lookfile' do
      $stdout = StringIO.new
      Add.run([TEST_FILE])
      $stdout.rewind

      expect($stdout.gets).to eq("Added files:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE}\n")
    end
  end

  describe '$ lookfile status' do
    it 'status of added file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)
      Lookfile.add_files(TEST_FILE)

      $stdout = StringIO.new
      Status.run
      $stdout.rewind

      expect($stdout.gets).to eq("Added files:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE[1..-1]}\n")
    end

    it 'status of modified file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)
      Lookfile.add_files(TEST_FILE)
      Lookfile.push
      open(TEST_FILE, 'a') { |file| file.puts('modified') }

      $stdout = StringIO.new
      Status.run
      $stdout.rewind

      expect($stdout.gets).to eq("Modified files:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE[1..-1]}\n")
    end

    it 'status of deleted file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)
      Lookfile.add_files(TEST_FILE)
      Lookfile.push
      lookfile_dir = Lookfile.load_lookfile_dir
      FileUtils.rm_rf(lookfile_dir + TEST_FILE)

      $stdout = StringIO.new
      Status.run
      $stdout.rewind

      expect($stdout.gets).to eq("Deleted files:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE[1..-1]}\n")
    end

    it 'dont show status if not have files on Lookfile' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)

      $stdout = StringIO.new
      Status.run
      $stdout.rewind

      expect($stdout.gets).to eq("\n")
    end
  end

  describe '$ lookfile push' do
    it 'push a file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)
      Lookfile.add_files(TEST_FILE)

      $stdout = StringIO.new
      Push.run
      $stdout.rewind

      expect($stdout.gets).to eq("Added files:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE[1..-1]}\n")
    end

    it 'dont push if not have files to push' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)

      $stdout = StringIO.new
      Push.run
      $stdout.rewind

      expect($stdout.gets).to eq("Nothing to update\n")
    end
  end

  describe '$ lookfile show' do
    it 'show files on lookfile' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)
      Lookfile.add_files(TEST_FILE)

      $stdout = StringIO.new
      Show.run
      $stdout.rewind

      expect($stdout.gets).to eq("Files on lookfile:\n")
      expect($stdout.gets).to eq("  #{TEST_FILE}\n")
    end

    it 'dont show files on lookfile if not have files' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)

      $stdout = StringIO.new
      Show.run
      $stdout.rewind

      expect($stdout.gets).to eq("\n")
    end
  end

  describe '$ lookfile restore' do
    it 'restore a file from lookfile' do
      begin
        repository_ssh_name = "file://#{GIT_DIR}"
        Lookfile.initialize
        Lookfile.set_repository(repository_ssh_name)
        Lookfile.add_files(TEST_FILE)

        $stdin, write = IO.pipe
        write.puts 'y'
        $stdout = StringIO.new
        Restore.run
        $stdout.rewind

        expect_message = "Restore file #{TEST_FILE} (Y/n): Restore Files:\n"
        expect($stdout.gets).to eq(expect_message)
        expect($stdout.gets).to eq(" #{TEST_FILE}\n")
      ensure
        write.close
      end
    end

    it 'not restore a file from lookfile if not have files' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize
      Lookfile.set_repository(repository_ssh_name)

      $stdout = StringIO.new
      Restore.run
      $stdout.rewind

      expect($stdout.gets).to eq("Restore Files:\n")
    end
  end

  describe '$ lookfile set_repository' do
    it 'set repository to lookfile' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize

      $stdout = StringIO.new
      SetRepository.run([repository_ssh_name])
      $stdout.rewind

      expect_message = "Setted repository to: #{repository_ssh_name}\n"
      expect($stdout.gets).to eq(expect_message)
    end

    it 'dont set repository to lookfile if not have repository name' do
      Lookfile.initialize

      $stdout = StringIO.new
      SetRepository.run([])
      $stdout.rewind

      expect($stdout.gets).to eq("  Usage:\n")
    end
  end
end
