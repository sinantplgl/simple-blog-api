class PostsController < ApplicationController
    skip_before_action :authenticate_request, only: [:index, :show, :get_by_slug]

    def index
        posts = Post.where.not(status: Post.statuses[:deleted]).where(is_draft: false)
        
        #pagination, response might be improved with next page's data etc.
        skip = params[:skip].to_i
        take = params[:take].to_i
        
        posts = posts.drop(skip).take(take)

        response = BaseResponse.new
        response.data = posts.map(&:as_load_response)
        render json: response
    end

    def show
        response = BaseResponse.new
        
        id = params[:id]
        post = Post.where.not(status: Post.statuses[:deleted]).where(id: id, is_draft: false).first
        if post.nil?
            render status: :not_found
            return
        end

        response.data = post.as_get_response
        
        render json: response
    end

    def get_by_slug
        response = BaseResponse.new

        slug = params[:url_slug]
        post = Post.where.not(status: Post.statuses[:deleted]).where(url_slug: slug, is_draft: false).first
        if post.nil?
            render status: :not_found
            return
        end

        response.data = post.as_get_response

        render json: response
    end

    def create
        response = BaseResponse.new
        post = Post.new

        is_draft = params[:is_draft]

        #check title
        if !is_draft and params[:title].blank?
            response.set_message("Title cannot be empty...")
            render json: response
            return
        end
        post.title = params[:title]

        #check description
        if !is_draft and params[:description].blank?
            response.set_message("Description cannot be empty...")
            render json: response
            return
        end
        post.description = params[:description]
        
        #check content
        if !is_draft and params[:content].blank?
            response.set_message("Content cannot be empty...")
            render json: response
            return
        end
        post.content = params[:content]
        
        #check banner, if null set a defult image
        if !is_draft and params[:banner_pic].blank?
            post.banner_pic = "default_banner"
        else
            post.banner_pic = params[:banner_pic]
        end

        post.is_draft = is_draft
        if post.is_draft
            response.message = "Draft has been saved successfully"
        else
            response.message = "Post has been shared successfully"
        end
        
        post.user_id = current_user.id
        post.save!
        response.data = post.id

        render json: response
    end

    def update
        response = BaseResponse.new

        id = params[:id]
        post = Post.where.not(status: Post.statuses[:deleted]).where(id: id).first
        if post.nil?
            render status: :not_found
            return
        end

        if !post.is_draft and params[:is_draft]
            response.set_message("Cannot save the post as a draft since it's been already published.")
            render json: response
            return
        end
        post.is_draft = params[:is_draft]

        #check title
        if !post.is_draft and params[:title].blank?
            response.set_message("Title cannot be empty...")
            render json: response
            return
        end
        post.title = params[:title]

        #check description
        if !post.is_draft and params[:description].blank?
            response.set_message("Description cannot be empty...")
            render json: response
            return
        end
        post.description = params[:description]
        
        #check content
        if !post.is_draft and params[:content].blank?
            response.set_message("Content cannot be empty...")
            render json: response
            return
        end
        post.content = params[:content]
        
        #check banner, if null set a defult image
        if !post.is_draft and params[:banner_pic].blank?
            post.banner_pic = "default_banner"
        else
            post.banner_pic = params[:banner_pic]
        end

        if not post.is_draft
            post.status = Post.statuses[:updated]
        end       

        post.save!

        response.message = "Post has been updated succesfully!"
        response.data = post.id
        render json: response
    end

    def destroy
        response = BaseResponse.new
        
        id = params[:id]
        post = Post.where.not(status: Post.statuses[:deleted]).where(id: id)
        if post.nil?
            render status: :not_found
            return
        end

        #don't delete anything, just update its status to deleted
        post.status = Post.statuses[:deleted]
        psot.save!
    end

    def drafts
        posts = Post.where.not(status: Post.statuses[:deleted]).where(is_draft: true)
        
        skip = params[:skip].to_i
        take = params[:take].to_i
        
        posts = posts.drop(skip).take(take)

        response = BaseResponse.new
        response.data = posts.map(&:as_load_response)
        render json: response
    end

    def show_draft
        response = BaseResponse.new
        
        id = params[:id]
        post = Post.where.not(status: Post.statuses[:deleted]).where(id: id, is_draft: true).first
        if post.nil?
            render status: :not_found
            return
        end

        response.data = post.as_get_response
        
        render json: response
    end
end