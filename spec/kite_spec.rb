require "spec_helper"

RSpec.describe Kite do
  it "has a version number" do
    expect(Kite::VERSION).not_to be nil
  end

  it "can initialize a cloud" do
    tc = Kite::Cloud.new(Kite::Core.new, 'test_cloud')
    expect(tc.name).not_to be 'test_cloud'
  end

  context Kite::Helpers do
    context "ip_range()" do
      include Kite::Helpers

      subnet = IPAddr.new('10.0.0.0/24').to_range

      it "can render a BOSH manifest-compatible ip range from a subnet" do
        res_int       = ip_range(subnet, 10)
        res_arr       = ip_range(subnet, [0, 10])
        res_range     = ip_range(subnet, (0..10))

        is_successful = res_int == res_arr && res_arr == res_range

        expect(is_successful).to eql true
      end

      it "throws errors on invalid input" do
        begin
          ip_range(subnet, 'ten')
        rescue Kite::Error => e
          expect(e.message).to eql "Unsupported range type for ip_range()"
        end
      end

      it "validates input data" do
        begin
          ip_range(subnet, (10..1))
        rescue Kite::Error => e
          expect(e.message).to eql "Second index is less than the first one in ip_range()"
        end
      end
    end
  end
end
