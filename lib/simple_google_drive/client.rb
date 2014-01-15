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

    def files_upload(file_obj, params = {})
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

end