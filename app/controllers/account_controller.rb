class AccountController < ApplicationController
    def get
        response = BaseResponse.new
        response.data = AccountGetResponse.new(
            username: @current_user.username,
            full_name: @current_user.full_name,
            profile_pic: @current_user.profile_pic
        )
        
        render json: response
        return
    end
end

class AccountGetResponse
    attr_accessor :username, :full_name, :profile_pic
    
    def initialize(params = {})
        @username = params.fetch(:username, nil)
        @full_name = params.fetch(:full_name, nil)
        @profile_pic = params.fetch(:profile_pic, nil)
    end
end