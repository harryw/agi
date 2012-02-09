# Monkey Patch to hook Mauth Signer into ActiveResource
module ActiveResource #:nodoc:
  module Extend
    module MauthSigner
       class ActiveResource::Connection
         # get request(:get, path, build_request_headers(headers, :get, self.site.merge(path)))
         # delete request(:delete, path, build_request_headers(headers, :delete, self.site.merge(path)))
         # put request(:put, path, body.to_s, build_request_headers(headers, :put, self.site.merge(path)))
         # post request(:post, path, body.to_s, build_request_headers(headers, :post, self.site.merge(path)))

         def request(method, path, *arguments)
           mauth_config = YAML.load_file(File.join(Rails.root, "config", "mauth.yml"))[Rails.env]
           mauth_config = mauth_config.symbolize_keys
           mauth_config[:private_key] = File.read(mauth_config[:private_key_file])
           mauth_signer = MAuth::Signer.new(mauth_config)

           mauth_params = {
             :verb => method.to_s.upcase,
             :request_url => URI.parse(path).path,
             :body => [:post, :put].include?(method) ? arguments.first : nil,
             :app_uuid => mauth_config[:app_uuid]
           }
           signed_headers = mauth_signer.signed_request_headers(mauth_params)

           arguments.last.update(signed_headers)

           # this is the original part
           result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
             payload[:method]      = method
             payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
             payload[:result]      = http.send(method, path, *arguments)
           end
           handle_response(result)
         rescue Timeout::Error => e
           raise TimeoutError.new(e.message)
         rescue OpenSSL::SSL::SSLError => e
           raise SSLError.new(e.message)
         end
       end
     end
  end
end



