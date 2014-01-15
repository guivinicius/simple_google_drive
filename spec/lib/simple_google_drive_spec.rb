require 'spec_helper'

describe SimpleGoogleDrive do

  let(:oauth2_access_token) { "1/fFBGRNJru1FQd44AzqT3Zg" }

  it "returns a new client instance" do
    expect(SimpleGoogleDrive.new(oauth2_access_token)).to be_instance_of(SimpleGoogleDrive::Client)
  end

end