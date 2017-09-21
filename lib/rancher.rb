require 'httparty'

# Temporary
ENV['CATTLE_CONFIG_URL'] = 'http://rancher.good2go.nl:8080/v1'
ENV['CATTLE_ACCESS_KEY'] = '6213857A47B100719E72'
ENV['CATTLE_SECRET_KEY'] = 'qzMBFXk28NxHefdYZqjkkT5TpGNevHoYcYGhuWF4'

class Rancher
  include HTTParty

  class Parser < HTTParty::Parser
    SupportedFormats = { 'application/json' => :json }

    protected

    def json
      JSON.parse(body, object_class: OpenStruct)
    end
  end

  base_uri ENV['CATTLE_CONFIG_URL'].split('/')[0..-2].join('/') + '/v2-beta'
  basic_auth ENV['CATTLE_ACCESS_KEY'], ENV['CATTLE_SECRET_KEY']
  parser Parser

  def stacks
    get('/stacks').parsed_response
  end

  def stack(id)
    get("/stacks/#{id}")
  end

  private

  def get(path)
    response = self.class.get(path)
    if response.code.to_s[0] == '2'
      response.parsed_response
    else
      raise "Error #{response.inspect}"
    end
  end
end
