module SimpleGoogleDrive

  class Client < SessionBase

    attr_accessor :access_token

    def initialize(oauth2_access_token)

      if oauth2_access_token.is_a?(String)
        @access_token = oauth2_access_token
      else
        raise ArgumentError, "oauth2_access_token doesn't have a valid type"
      end

    end

    public

    def about
      url = build_url("/about")
      request = build_request(url)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_get(file_id, params = nil)
      url = build_url("/files/#{file_id}", params)
      request = build_request(url)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_insert(body = {}, params = nil)
      url = build_url("/files", params)
      request = build_request(url, 'post', body.to_json)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_upload(file_object, args = {})
      raise ArgumentError, "Invalid upload type. Choose between media, multipart or resumable." if args[:uploadType].nil?

      case args[:uploadType].to_s
        when 'media'
          body = file_object
          content_type = MIME::Types.type_for(file_object.path).first.to_s
        when 'multipart'
          body = build_multipart_body(file_object, args[:body_object])
          content_type = "multipart/related;boundary=simple_google_drive_boundary"
        when 'resumable'
          body = build_resumable_body(file_object, args[:body_object])
          content_type = ""
      end

      url = build_url("/files", args[:parameters], true)
      request = build_request(url, 'post', body, content_type)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_patch(file_id, body = nil, params = nil)
      url = build_url("/files/#{file_id}", params)
      request = build_request(url, 'patch', body)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_copy(file_id, body = nil, params = nil)
      url = build_url("/files/#{file_id}/copy", params)
      request = build_request(url, 'post', body)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_delete(file_id)
      url = build_url("/files/#{file_id}")
      request = build_request(url, 'delete')
      response = send_request(url, request)

      parse_response(response)
    end

    def files_list(params = nil)
      url = build_url("/files", params)
      request = build_request(url)
      response = send_request(url, request)

      parse_response(response)
    end

    def files_touch(file_id)
      url = build_url("/files/#{file_id}/touch")
      request = build_request(url, 'post')
      response = send_request(url, request)

      parse_response(response)
    end

    def files_trash(file_id)
      url = build_url("/files/#{file_id}/trash")
      request = build_request(url, 'post')
      response = send_request(url, request)

      parse_response(response)
    end

    def files_untrash(file_id)
      url = build_url("/files/#{file_id}/untrash")
      request = build_request(url, 'post')
      response = send_request(url, request)

      parse_response(response)
    end

    def files_watch(file_id, body = nil)
      url = build_url("/files/#{file_id}/watch")
      request = build_request(url, 'post', body.to_json)
      response = send_request(url, request)

      parse_response(response)
    end

  end

end