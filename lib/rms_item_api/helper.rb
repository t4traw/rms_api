module RmsItemApi
  module Helper

    ENDPOINT = 'https://api.rms.rakuten.co.jp/es/'.freeze
    def connection(url, method)
      p "connectionにきましたーーーーー"
      Faraday.new(url: ENDPOINT + url + method) do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.headers['Authorization'] = encoded_key
      end
    end

    def convert_xml_into_json(xml)
      p "convert_xml_into_jsonにきましたーーーーーーーー"
      Hash.from_xml(xml)
    end

    def handler(response)
      p "ハンドラーにきたよーーーーーーーーーー"
      rexml = REXML::Document.new(response.body)
      p "rexmlは#{rexml}だよーーーーーーーー"
      self.define_singleton_method(:all) { convert_xml_into_json(response.body) }
      if rexml.elements["result/status/systemStatus"].text == "NG"
        p "エラーだよーーーーーーーー"
        raise rexml.elements["result/status/message"].text
      end
      status_parser(rexml)
      case response.env.method
      when :get
        p "getにきたよーーーーーーーーーーーーーー"
        get_response_parser(rexml)
      # when :post
      #   post_response_parser(rexml)
      end

      self
    end

    private

    def encoded_key
      p "encoded_keyにきたよーーーーーーーーーーー"
      if @serviceSecret.blank? && @licenseKey.blank?
        error_msg = "serviceSecret and licenseKey are required"
        raise StandardError, error_msg
      else
        "ESA " + Base64.strict_encode64(@serviceSecret + ":" + @licenseKey)
      end
    end

    def get_endpoint(rexml)
      p "get_endpointにきたよーーーーーーーーーーー"
      result = {}
      interfaceId = rexml.elements["result/status/interfaceId"].text
      dot_count = interfaceId.count(".")
      result[:api] = interfaceId.split('.')[dot_count-1]
      p result[:api]
      result[:method] = interfaceId.split('.')[dot_count]
      p result[:method]
      result[:camel] = "#{result[:api]}#{result[:method].capitalize}"
      result
    end

    def status_parser(rexml)
      p "status_parserにきたよーーーーーーーーーーー"
      endpoint = get_endpoint(rexml)
      if endpoint[:api] == "item"
        p "endpoint[:api] == itemだよ"
        xpoint = "result/#{endpoint[:camel]}Result/code" # origin
      elsif endpoint[:api] == "category"
        p "endpoint[:api] == categoryだよ"
        xpoint = "result/#{endpoint[:camel]}Result/code" # origin
      elsif endpoint[:api] == "genre"
        p "endpoint[:api] == genreだよ"
        xpoint = "result/navigation#{endpoint[:api].capitalize}GetResult/genre" # 無理やり
      elsif endpoint[:api] == "cabinet"
        p "endpoint[:api] == cabinetだよ"
        xpoint = "result/#{endpoint[:api]}UsageGetResult/genre" # 無理やり
      end
      p xpoint
      p "xpointが見れてるよーーーーーーーーーーーー！"
      response_code = rexml.elements[xpoint].text

      yml = "#{File.dirname(__FILE__)}/../../config/response_codes.yml"
      response_codes = YAML.load_file(yml)

      self.define_singleton_method(:is_success?) { response_code == 'N000' ? true : false }
      self.define_singleton_method(:message) { response_codes[response_code] }
      err_point = "result/#{endpoint[:camel]}Result/errorMessages/errorMessage/msg"
      err_msg = []
      rexml.elements.each(err_point) do |element|
        err_msg << element.text
      end
      self.define_singleton_method(:errors) { err_msg }
      p "is_success?を通過するよーー？？？？？？？？？？？"
      self.is_success?
      p "is_success?を通過しましたーーーーーーーーーーーー"
    end

    def get_response_parser(rexml)
      p "get_response_parserにきたよーーーーー"
      endpoint = get_endpoint(rexml)
      if endpoint[:api] == "item"
        p "endpoint[:api] == itemだよ"
        xpoint = "result/#{endpoint[:camel]}Result/#{endpoint[:api]}" # origin
      elsif endpoint[:api] == "category"
        p "endpoint[:api] == categoryだよ"
        xpoint = "result/#{endpoint[:camel]}Result/#{endpoint[:api]}" # origin
      elsif endpoint[:api] == "genre"
        p "endpoint[:api] == genreだよ"
        xpoint = "result/navigation#{endpoint[:api].capitalize}GetResult/#{endpoint[:api]}" # genre無理やり
      elsif endpoint[:api] == "cabinet"
        p "endpoint[:api] == cabinetだよ"
        xpoint = "result/navigation#{endpoint[:api].capitalize}GetResult/#{endpoint[:api]}" # genre無理やり
      end
      rexml.elements.each(xpoint) do |result|
        p result
        result.children.each do |el|
          p el
          next if el.to_s.strip.blank?
          if el.has_elements?
            p "エレメントを持っているよ"
            begin
              self.define_singleton_method(el.name.underscore) {
                Hash.from_xml(el.to_s)
              }
            rescue => e
              puts e
            end
          else
            begin
              self.define_singleton_method(el.name.underscore) {
                el.text.try!(:force_encoding, 'utf-8')
              }
            rescue => e
              puts e
            end
          end
        end
      end
      self
    end

    def post_response_parser(rexml)
      p "post_response_parserにきましたーーーーーーー"
      self
    end

  end
end

class Hash
  class << self

    def from_xml(rexml)
      p "from_xmlにきましたーーーーーーー"
      xml_elem_to_hash rexml.root
    end

    private

    def xml_elem_to_hash(el)
      p "xml_elem_to_hashにきましたーーーーーーー"
      value = if el.has_elements?
        children = {}
        el.each_element do |e|
          children.merge!(xml_elem_to_hash(e)) do |k,v1,v2|
            v1.is_a?(Array) ?  v1 << v2 : [v1,v2]
          end
        end
        children
      else
        el.text
      end
      { el.name.to_sym => value }
    end

  end
end
