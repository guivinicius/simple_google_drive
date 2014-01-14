require 'uri'
require 'net/http'
require 'json'

require 'simple_google_drive/version'
require 'simple_google_drive/session_base'
require 'simple_google_drive/client'

module SimpleGoogleDrive

  API_HOST  = "www.googleapis.com"
  API_VERSION = "2"
  API_UPLOAD_URL = "https://#{API_HOST}/upload/drive/v#{API_VERSION}"
  API_BASE_URL = "https://#{API_HOST}/drive/v#{API_VERSION}"

  def self.new(oauth2_access_token)
    Client.new(oauth2_access_token)
  end

end
