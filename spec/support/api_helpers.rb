module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = nil)
    options = {} if options.nil?
    send method, path, options
  end
end
