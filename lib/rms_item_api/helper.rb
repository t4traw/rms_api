module RmsItemApi
  module Helper

    ENDPOINT = 'https://api.rms.rakuten.co.jp/es/1.0/item/'.freeze
    def connection(method)
      Faraday.new(url: ENDPOINT + method) do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.headers['Authorization'] = encoded_key
      end
    end

    def convert_json_from_xml(xml)
      XmlSimple.xml_in(xml)
    end

    def handler(xml)
      rexml = REXML::Document.new(xml)
      self.define_singleton_method(:all) { convert_json_from_xml(xml) }

      # そのその通信がまともにできなかった場合はここがNGになる
      status = rexml.elements["result/status/systemStatus"].text
      status_parser(rexml)
    end

    private

    def status_parser(rexml)
      interfaceId = rexml.elements["result/status/interfaceId"].text
      api = interfaceId.split('.')[0]
      method = interfaceId.split('.')[1]
      response_code = rexml.elements["result/#{api}#{method.capitalize}Result/code"].text

      yml = "#{File.dirname(__FILE__)}/../../config/error_codes.yml"
      error_codes = YAML.load_file(yml)

      self.define_singleton_method(:result) { error_codes[response_code] }
      self.define_singleton_method(:is_success?) { response_code == 'N000' ? true : false }

      self.is_success?
    end

    def encoded_key
      if @serviceSecret.blank? && @licenseKey.blank?
        error_msg = "serviceSecret and licenseKey are required"
        raise StandardError, error_msg
      else
        "ESA " + Base64.strict_encode64(@serviceSecret + ":" + @licenseKey)
      end
    end

    def parse_response(rexml)
      method = rexml.elements['result/status/interfaceId'].text
      result_code = parsed_xml.xpath("result/item#{method}Result/code").text
      case method
      when 'Get'
        if result_code == 'N000'
          puts "#{method} succeeded" unless @quiet_option
          xpoint = 'result/itemGetResult/item'
          parsed_xml.xpath(xpoint).each do |xml|
            xml.children.each_with_index do |x, index|
              not_have_children = true

              x.children.each do |y|
                y.children.each do |z|
                  not_have_children = false
                  begin
                    self.define_singleton_method(z.name.underscore) {
                      z.text.force_encoding('utf-8')
                    }
                  rescue => e
                    puts e unless @quiet_option
                  end
                end
              end

              if not_have_children
                self.define_singleton_method(x.name.underscore) {
                  x.text.force_encoding('utf-8')
                }
              end

            end
          end
          return self
        else
          puts "指定された商品管理番号は存在しません" unless @quiet_option
        end

      when 'Update', 'Insert', 'Delete'
        if result_code == 'N000'
          puts "#{method} succeeded" unless @quiet_option
        else
          config_file = "#{File.dirname(__FILE__)}/../config/field_name.yml"
          field_name = Hashie::Mash.new(YAML.load_file(config_file))
          xpoint = "result/item#{method}Result/errormessages"
          parsed_xml.xpath(xpoint).each do |xml|
            xml.children.each do |x|
              error_field = x.xpath('fieldId').text
              error_description = x.xpath('msg').text.force_encoding('utf-8')
              puts "#{field_name[error_field]}:#{error_description}" unless @quiet_option
            end
          end
        end
      end # case
    end # parse_response

  end
end
