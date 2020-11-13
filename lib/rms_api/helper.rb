module RmsApi
  module Helper
    ENDPOINT_BASE = 'https://api.rms.rakuten.co.jp/es/1.0/'.freeze

    def connection(service:, method:)
      Faraday.new(url: ENDPOINT_BASE + "#{service}/#{method}") do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.headers['Authorization'] = encoded_key
      end
    end

    def convert_xml_into_json(xml)
      Hash.from_xml(xml)
    end

    def handler(response)
      rexml = REXML::Document.new(response.body)
      define_singleton_method(:all) { convert_xml_into_json(response.body) }
      check_system_status(rexml)
      status_parser(response_code: get_response_code(rexml), error_messages: get_error_messages(rexml))
      get_response_parser(rexml) if response.env.method == :get
      self
    end

    private

    def encoded_key
      if @serviceSecret.blank? && @licenseKey.blank?
        error_msg = 'serviceSecret and licenseKey are required'
        raise StandardError, error_msg
      else
        'ESA ' + Base64.strict_encode64(@serviceSecret + ':' + @licenseKey)
      end
    end

    def check_system_status(rexml)
      systemStatus = rexml.elements['result/status/systemStatus'].text
      raise rexml.elements['result/status/message'].text if systemStatus == 'NG'
    end

    def get_response_code(rexml)
      endpoint = get_endpoint(rexml)[:camel]
      rexml.elements["result/#{endpoint}Result/code"].text
    end

    def get_error_messages(rexml)
      endpoint = get_endpoint(rexml)[:camel]
      err_point = "result/#{endpoint}Result/errorMessages/errorMessage/msg"
      result = []
      rexml.elements.each(err_point) do |element|
        result << element.text
      end
      result
    end

    def get_endpoint(rexml)
      result = {}
      interfaceId = rexml.elements['result/status/interfaceId'].text
      result[:api] = interfaceId.split('.')[0]
      result[:method] = interfaceId.split('.')[1]
      result[:camel] = "#{result[:api]}#{result[:method].capitalize}"
      result
    end

    def status_parser(response_code:, error_messages:)
      response_codes = YAML.load_file("#{File.dirname(__FILE__)}/../../config/response_codes.yml")
      define_singleton_method(:is_success?) { response_code == 'N000' }
      define_singleton_method(:message) { response_codes[response_code] }
      define_singleton_method(:errors) { error_messages }
    end

    def get_response_parser(rexml)
      xpoint = "result/#{get_endpoint(rexml)[:camel]}Result/item"
      rexml.elements.each(xpoint) do |result|
        result.children.each do |el|
          next if el.to_s.strip.blank?

          define_element_method(el)
        end
      end
      self
    end

    def define_element_method(el)
      define_singleton_method(el.name.underscore) do
        if el.has_elements?
          Hash.from_xml(el.to_s)
        else
          el.text.try!(:force_encoding, 'utf-8')
        end
      end
    end

    def post_response_parser(_rexml)
      self
    end
  end
end

class Hash
  class << self
    def from_xml(rexml)
      xml_elem_to_hash rexml.root
    end

    private

    def xml_elem_to_hash(el)
      value = el.has_elements? ? merged_children(el) : el.text
      { el.name.to_sym => value }
    end

    def merged_children(el)
      result = {}
      el.each_element do |e|
        result.merge!(xml_elem_to_hash(e)) do |_k, v1, v2|
          v1.is_a?(Array) ? v1 << v2 : [v1, v2]
        end
      end
      result
    end
  end
end
