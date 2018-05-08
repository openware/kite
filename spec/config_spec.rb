require 'spec_helper'

RSpec.describe Kite do
  it 'needs folder with kite structure' do
    expect(capture(:stderr) do
      Kite::Core.start(%w(config get key --env test))
    end.strip).to eq "Invalid path: \"#{Dir.pwd}\""
  end

  describe 'has valid root path' do
    before(:each) do
      File.open('config/cloud.yml', 'w') { |f| f.write 'key: value' }
      Dir.mkdir('config/environments')
      Dir.mkdir('config/environments/test')
      File.open('config/environments/test/vars.example.yml', 'w') { |f| f.write 'key: value' }
    end

    after(:each) do
      File.delete('config/cloud.yml')
      File.delete('config/environments/test/vars.example.yml')
      Dir.delete('config/environments/test')
      Dir.delete('config/environments')
    end

    it 'returns value for valid selector' do
      expect(capture(:stdout) do
        Kite::Core.start(%w(config get key --env test))
      end.strip).to eq '"value"'
    end

    it 'returns error for invalid selector' do
      expect(capture(:stderr) do
        Kite::Core.start(%w(config get invalid --env test))
      end.strip).to eq 'Invalid query: "invalid"'
    end
  end
end
