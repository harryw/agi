module ActiveResource #:nodoc:
  module Extend
    module ShowErrors
       class ActiveResource::ConnectionError
         def to_s
           message = "Failed."
           message << "  Response code = #{response.code}." if response.respond_to?(:code)
           message << "  Response message = #{response.message}." if response.respond_to?(:message)
           message << "  Response body = #{response.body}." if response.respond_to?(:body)
           message
         end
       end
     end
  end  
end