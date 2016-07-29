module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
  
  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.marketplace.v#{version}" 
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = format
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
      api_header 
      api_response_format
    end
  end
end
