require "spec_helper"
require 'tmpdir'

RSpec.describe Kite do
  it "has a version number" do
    expect(Kite::VERSION).not_to be nil
  end

  it "can initialize a cloud" do
    tc = Kite::Cloud.new(Kite::Core.new, 'test_cloud')
    expect(tc.name).not_to be 'test_cloud'
  end
end
