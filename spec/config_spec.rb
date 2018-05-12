require 'spec_helper'

describe Kite do
  include TmpDirIsolation

  let(:opts) { { raise_error: false } }

  it 'needs folder with kite structure' do
    expect(capture(:stderr) do
      run "#{ KITE_BIN } config get key --env test", opts
    end.strip).to eq "Invalid path: \"#{Dir.pwd}\""
  end

  describe 'has valid root path' do
    before(:each) do
      run "#{ KITE_BIN } new .", silent: true
      File.open('config/cloud.yml', 'w') { |f| f.write 'key: value' }
      FileUtils.mkdir_p('config/environments/test')
      File.open('config/environments/test/vars.example.yml', 'w') { |f| f.write 'key: value' }
    end

    after(:each) do
      File.delete('config/cloud.yml')
      FileUtils.rm_r('config/environments')
    end

    it 'returns value for valid selector' do
      expect(capture(:stdout) do
        run "#{ KITE_BIN } config get key --env test", opts
      end.strip).to eq 'value'
    end

    it 'returns error for invalid selector' do
      expect(capture(:stderr) do
        run "#{ KITE_BIN } config get invalid --env test", opts
      end.strip).to eq 'Invalid query: "invalid"'
    end
  end
end
