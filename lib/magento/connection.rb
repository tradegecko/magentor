module MagentoAPI
  class Connection
    attr_accessor :session, :config, :logger, :last_call
    MAX_ATTEMPTS = 2
    SERVICE_UNAVAILABLE_REGEX = /error.*503/

    def initialize(config = {})
      @logger = MagentoAPI.logger
      @config = config
      @last_call = nil
      self
    end

    def client
      @client ||= XMLRPC::Client.new_from_uri(config[:uri])
      @client.http_header_extra = {"accept-encoding" => "identity"}.merge(config.fetch(:http_header_extra, {}))
      @client
    end

    def connect
      connect! if session.nil?
    end

    def call(method = nil, *args)
      cache? ? call_with_caching(method, *args) : call_without_caching(method, *args)
    end

    private

      def connect!
        log_call("login")
        begin
          retry_on_connection_error do
            @session = client.call("login", config[:username], config[:api_key])
          end
        rescue RuntimeError => e
          if e.message.match?(SERVICE_UNAVAILABLE_REGEX)
            log_call("Failed to connect. URI=#{config[:uri]&.host}")
            raise ServiceUnavailable.new(503, "Service Unavailable")
          else
            raise e
          end
        end
      end

      def cache?
        !!config[:cache_store]
      end

      def call_without_caching(method = nil, *args)
        attempts ||= 0
        log_call("#{method}, #{args.inspect}")
        connect
        retry_on_connection_error do
          client.call_async("call", session, method, args).tap do |response|
            notify_about_request(method, response, args)
          end
        end
      rescue XMLRPC::FaultException => e
        notify_about_request(method, e.faultString, args)
        if e.faultCode == 5 # Session timeout
          connect!
          attempts += 1
          retry if attempts < MAX_ATTEMPTS
        end
        raise MagentoAPI::ApiError, e
      end

      def call_with_caching(method = nil, *args)
        config[:cache_store].fetch(cache_key(method, *args)) do
          call_without_caching(method, *args)
        end
      end

      def cache_key(method, *args)
        "#{config[:username]}@#{config[:host]}:#{config[:port]}#{config[:path]}/#{method}/#{args.inspect}"
      end

      def retry_on_connection_error
        attempts = 0
        begin
          yield
        rescue EOFError
          attempts += 1
          retry if attempts < MAX_ATTEMPTS
        end
      end

      def log_call(message)
        @last_call = message
        logger.debug "call: #{message}"
      end


      def notify_about_request(method, response, *args)
        ActiveSupport::Notifications.instrument("request.magento_api") do |payload|
          payload[:method]        = method
          payload[:request_uri]   = config[:uri].to_s
          payload[:request_body]  = if args.is_a?(Array) &&
                                       args[0].is_a?(Array) &&
                                       args[0][1].is_a?(Hash)
                                      args[0][1].to_json
                                    end
          payload[:response_body] = response.to_s
        end
      end
  end
end
