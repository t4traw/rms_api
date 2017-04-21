require "rms_item_api/version"

require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'oga'
require 'hashie'

module RmsItemApi
  class RmsItemApi
    ENDPOINT = 'https://api.rms.rakuten.co.jp/es/1.0/item/'.freeze

    def initialize(serviceSecret:, licenseKey:)
      @serviceSecret = serviceSecret
      @licenseKey = licenseKey
      @quiet_option = nil
    end

    def quiet!
      @quiet_option = true
      self
    end

    def get(item_data)
      result = connection('get').get {|r| r.params['itemUrl'] = item_data}
      check_system_status(result.body, "Get")
    end

    def update(item_data)
      request_xml = {itemUpdateRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true)
      result = connection('update').post {|r| r.body = request_xml}
      check_system_status(result.body, "Update")
    end

    def insert(item_data)
      request_xml = {itemInsertRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true)
      result = connection('insert').post {|r| r.body = request_xml}
      check_system_status(result.body, "Insert")
    end

    def delete(item_data)
      request_xml = {itemDeleteRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true)
      result = connection('delete').post {|r| r.body = request_xml}
      check_system_status(result.body, "Delete")
    end

    private

      def connection(method)
        Faraday.new(url: ENDPOINT + method) do |conn|
          conn.adapter(Faraday.default_adapter)
          conn.headers['Authorization'] = encoded_key
        end
      end

      def encoded_key
        if @serviceSecret.blank? && @licenseKey.blank?
          error_msg = "serviceSecret and licenseKey are required"
          raise StandardError, error_msg
        else
          "ESA " + Base64.strict_encode64(@serviceSecret + ":" + @licenseKey)
        end
      end

      def check_system_status(result, method)
        parsed_xml = Oga.parse_xml(result)
        system_status = Oga.parse_xml(result).xpath("result/status/systemStatus").text
        if system_status == 'NG'
          raise Oga.parse_xml(result).xpath("result/status/message").text
        else
          parse_response(parsed_xml, method)
        end
      end

      def parse_response(parsed_xml, method)
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

  end # class rms_item_api
end # module rms_item_api
