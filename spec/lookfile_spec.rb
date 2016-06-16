require 'spec_helper'

describe Lookfile do
  it 'has a version number' do
    expect(Lookfile::VERSION).not_to be nil
  end

  describe 'Initialize Lookfile directory' do
    it 'get lookfile with default base dir' do
      lookfile_dir = Lookfile.lookfile_dir
      default_base_dir = File.expand_path(Lookfile::BASE_DIR)

      expect(lookfile_dir).to include(default_base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end

    it 'get lookfile with setted base dir' do
      base_dir = File.expand_path('~/Documents')
      lookfile_dir = Lookfile.lookfile_dir(base_dir)

      expect(lookfile_dir).to include(base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end
  end
end
