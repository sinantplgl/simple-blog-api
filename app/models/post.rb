class Post < ApplicationRecord
    enum status: {active: 1, updated: 2, deleted: 10}, _prefix: :record
    belongs_to :user
    before_save :generate_slug

    def as_load_response
        {
            id: self.id,
            user: {
                id: self.user_id,
                username: self.user.username,
                fullName: self.user.full_name,
                profile_pic: self.user.profile_pic
            },
            title: self.title,
            url_slug: self.url_slug,
            banner_pic: self.banner_pic,
            description: self.description,
            status: self.status,
            created_at: self.created_at,
            updated_at: self.updated_at,
        }
    end

    def as_get_response
        {
            id: self.id,
            user: {
                id: self.user_id,
                username: self.user.username,
                fullName: self.user.full_name,
                profile_pic: self.user.profile_pic
            },
            title: self.title,
            url_slug: self.url_slug,
            banner_pic: self.banner_pic,
            description: self.description,
            content: self.content,
            status: self.status,
            created_at: self.created_at,
            updated_at: self.updated_at,
        }
    end

    def generate_slug
        self.url_slug = self.title.parameterize + "-" + Time.now.strftime('%s') unless self.title.nil?
    end
end
