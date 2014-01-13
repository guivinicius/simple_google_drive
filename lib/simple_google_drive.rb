require 'uri'
require 'net/http'
require 'json'

class SimpleGoogleDrive
  GEM_VERSION = "0.0.1"

  API_HOST  = "www.googleapis.com"
  API_VERSION = "2"
  API_UPLOAD_URL = "https://#{API_HOST}/upload/drive/v#{API_VERSION}"
  API_BASE_URL = "https://#{API_HOST}/drive/v#{API_VERSION}"

  attr_accessor :access_token

  def initialize(oauth2_access_token)

    if oauth2_access_token.is_a?(String)
      @access_token = oauth2_access_token
    else
      raise ArgumentError, "oauth2_access_token doesn't have a valid type"
    end

  end

  private

  def build_url(path, params = nil, upload = false)
    uri = URI.parse("#{ upload ? API_UPLOAD_URL : API_BASE_URL }#{path}")
    uri.query = URI.encode_www_form(params) if !params.nil?

    return uri
  end

  def request(uri, method = 'get', body = nil)

    default_headers = {'User-Agent' => "Ruby/SimpleGoogleDrive/#{GEM_VERSION}", 'Authorization' => "Bearer #{@access_token}"}

    case method
      when 'get'
        req = Net::HTTP::Get.new(uri, default_headers)
      when 'patch'
        req = Net::HTTP::Patch.new(uri, default_headers)
      when 'post'
        req = Net::HTTP::Post.new(uri, default_headers)
      when 'delete'
        req = Net::HTTP::Delete.new(uri, default_headers)
    end

    if !body.nil?
      if body.is_a?(Hash)
        req.set_form_data(body)
      elsif body.respond_to?(:read)
          if body.respond_to?(:length)
              req["Content-Length"] = body.length.to_s
          elsif body.respond_to?(:stat) && body.stat.respond_to?(:size)
              req["Content-Length"] = body.stat.size.to_s
          else
              raise ArgumentError, "Don't know how to handle 'body' (responds to 'read' but not to 'length' or 'stat.size')."
          end
          req.body_stream = body
          req.content_type = 'multipart/form-data'
      else
          s = body.to_s
          req["Content-Length"] = s.length
          req.body = s
      end
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    begin
      response = http.request(req)
    rescue Exception => e
      # raise e
    end

  end

  def parse_response(response)

    if response.kind_of?(Net::HTTPServerError)
        raise DropboxError.new("Dropbox Server Error: #{response} - #{response.body}", response)
    elsif response.kind_of?(Net::HTTPUnauthorized)
        raise DropboxAuthError.new("User is not authenticated.", response)
    elsif not response.kind_of?(Net::HTTPSuccess)
        begin
            d = JSON.parse(response.body)
        rescue
            raise "Dropbox Server Error: body=#{response.body}", response
        end
        if d['user_error'] and d['error']
            raise DropboxError.new(d['error'], response, d['user_error'])  #user_error is translated
        elsif d['error']
            raise DropboxError.new(d['error'], response)
        else
            raise DropboxError.new(response.body, response)
        end
    end

    return "" if response.body.nil?

    begin
        JSON.parse(response.body)
    rescue JSON::ParserError
        raise "Unable to parse JSON response: #{response.body}"
    end

  end

  public

  def about
    url = build_url("/about")
    response = request(url)
    parse_response(response)
  end

  def files_get(file_id, params = nil)
    url = build_url("/files/#{file_id}", params)
    response = request(url)
    parse_response(response)
  end

  def files_insert(body = {}, params = nil)
    url = build_url("/files", params)
    response = request(url, 'post', body.to_json)
    parse_response(response)
  end

  def files_upload(file_obj, params = nil)
    raise ArgumentError, "Invalid upload type. Choose between media, multipart or resumable." if params[:uploadType].nil?

    url = build_url("/files", params, true)
    response = request(url, 'post', file_obj)
    parse_response(response)
  end

  def files_patch(file_id, body = nil, params = nil)
    url = build_url("/files/#{file_id}", params)
    response = request(url, 'patch', body)
    parse_response(response)
  end

  def files_copy(file_id, body = nil, params = nil)
    url = build_url("/files/#{file_id}/copy", params)
    response = request(url, 'post', body)
    parse_response(response)
  end

  def files_delete(file_id)
    url = build_url("/files/#{file_id}")
    response = request(url, 'delete')
    parse_response(response)
  end

  def files_list(params = nil)
    url = build_url("/files", params)
    response = request(url)
    parse_response(response)
  end

  def files_touch(file_id)
    url = build_url("/files/#{file_id}/touch")
    response = request(url, 'post')
    parse_response(response)
  end

  def files_trash(file_id)
    url = build_url("/files/#{file_id}/trash")
    response = request(url, 'post')
    parse_response(response)
  end

  def files_untrash(file_id)
    url = build_url("/files/#{file_id}/untrash")
    response = request(url, 'post')
    parse_response(response)
  end

  def files_watch(file_id, body = nil)
    url = build_url("/files/#{file_id}/watch")
    response = request(url, 'post', body.to_json)
    parse_response(response)
  end

end
