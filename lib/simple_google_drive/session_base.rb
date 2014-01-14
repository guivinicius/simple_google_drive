module SimpleGoogleDrive

  class SessionBase

    private

    def build_url(path, params = nil, upload = false)
      uri = URI.parse("#{ upload ? API_UPLOAD_URL : API_BASE_URL }#{path}")
      uri.query = URI.encode_www_form(params) if !params.nil?

      return uri
    end

    def request(uri, method = 'get', body = nil)

      default_headers = {'User-Agent' => "Ruby/SimpleGoogleDrive/#{SimpleGoogleDrive::VERSION}", 'Authorization' => "Bearer #{@access_token}"}

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

  end

end