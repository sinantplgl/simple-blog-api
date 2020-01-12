class BaseResponse
    attr_accessor :has_error, :message, :data

    def initialize(params = {})
        @has_error = params.fetch(:has_error, false)
        @message = params.fetch(:message, nil)
        @data = params.fetch(:data, nil)
    end

    def set_message(m)
        @has_error = true
        @message = m
    end
end