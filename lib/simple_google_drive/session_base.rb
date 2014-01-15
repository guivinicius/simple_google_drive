module SimpleGoogleDrive

  class SessionBase

    private

    def build_url(path, params = nil, upload = false)
      url = URI.parse("#{ upload ? API_UPLOAD_URL : API_BASE_URL }#{path}")
      url.query = URI.encode_www_form(params) if !params.nil?

      return url
    end

    def build_request(url, method = 'get', body = nil, content_type = nil)

      default_headers = {'User-Agent' => "Ruby/SimpleGoogleDrive/#{SimpleGoogleDrive::VERSION}", 'Authorization' => "Bearer #{@access_token}"}

      case method
        when 'get'
          req = Net::HTTP::Get.new(url, default_headers)
        when 'patch'
          req = Net::HTTP::Patch.new(url, default_headers)
        when 'post'
          req = Net::HTTP::Post.new(url, default_headers)
        when 'delete'
          req = Net::HTTP::Delete.new(url, default_headers)
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
            req["Content-Type"]= content_type
        else
            s = body.to_s
            req["Content-Length"] = s.length
            req["Content-Type"] = content_type
            req.body = s
        end

      end

      return req
    end

    def send_request(url, request)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      begin
        response = http.request(request)
      rescue Exception => e
        raise "Something wrong with the http response: #{e}"
      end

    end

    def parse_response(response)
      return "" if response.body.nil?

      if response.kind_of?(Net::HTTPServerError)
          raise "Google Drive Server Error: #{response} - #{response.body}"
      elsif response.kind_of?(Net::HTTPUnauthorized)
          raise "User is not authenticated."
      elsif not response.kind_of?(Net::HTTPSuccess)
          begin
              d = JSON.parse(response.body)
          rescue
              raise "Server Error: response=#{response}"
          end
      end

      begin
          JSON.parse(response.body)
      rescue JSON::ParserError
          raise "Unable to parse JSON response: #{response.body}"
      end

    end

    def build_multipart_body(file_object, body_object)
      content_type = MIME::Types.type_for(file_object.path).first.to_s

      body = <<-eos
          --simple_google_drive_boundary
          Content-Type: application/json; charset=UTF-8

          #{body_object.to_json}

          --simple_google_drive_boundary
          Content-Type: #{content_type}

          #{file_object.read}

          --simple_google_drive_boundary--
        eos
    end

    def build_resumable_body(file_object, body_object)

    end

  end

end