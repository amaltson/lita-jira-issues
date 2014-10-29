class JiraGateway

  attr_reader :http, :config

  def initialize(http, config)
    @http = http
    @config = config
  end

  def data_for_issue(key)
    http.basic_auth(config.username, config.password)
    response = http.get(config.url + '/rest/api/2/issue/' + key)
    MultiJson.load(response.body, symbolize_keys: true)
  end

end
