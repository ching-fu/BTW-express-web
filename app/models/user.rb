class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


   has_attached_file :user_photo, styles: { medium: "300x300#", thumb: "200x200#" }, default_url: "/images/:style/missing.png"
   do_not_validate_attachment_file_type :user_photo, content_type: /\Aimage\/.*\Z/

  has_many :orders

  before_create :generate_authentication_token

  def generate_authentication_token
   # self.authentication_token = SecureRandom.hex(16)
   self.authentication_token = Devise.friendly_token
  end

  def self.get_fb_data(access_token)
    res = RestClient.get "https://graph.facebook.com/v2.4/me",  { :params => { :fields => "email,name, picture.type(large)", :access_token => access_token } }

    if res.code == 200
    JSON.parse( res.to_str)
    else
    Rails.logger.warn(res.body)
    nil
    end
  end

  def self.from_omniauth(auth)
      # Case 1: Find existing user by facebook uid
      user = User.find_by_fb_uid( auth.uid )
      if user
         user.fb_token = auth.credentials.token
         #user.fb_raw_data = auth
         user.save!
        return user
      end

      # Case 2: Find existing user by email
      existing_user = User.find_by_email( auth.info.email )
      if existing_user
        existing_user.fb_uid = auth.uid
        existing_user.fb_token = auth.credentials.token
        #existing_user.fb_raw_data = auth
        existing_user.save!
        return existing_user
      end

      # Case 3: Create new password
      user = User.new
      user.fb_pic = auth.info.image
      user.fb_uid = auth.uid
      user.fb_token = auth.credentials.token
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      #user.fb_raw_data = auth
      user.save!
      return user
    end

    def self.from_omniauth_api(auth)
        # Case 1: Find existing user by facebook uid
        user = User.find_by_fb_uid( auth.uid )
        if user
           user.fb_token = auth.credentials.token
           #user.fb_raw_data = auth
           user.save!
          return user
        end

        # Case 2: Find existing user by email
        existing_user = User.find_by_email( auth.info.email )
        if existing_user
          existing_user.fb_uid = auth.uid
          existing_user.fb_token = auth.credentials.token
          #existing_user.fb_raw_data = auth
          existing_user.save!
          return existing_user
        end

        # Case 3: Create new password
        user = User.new
        user.fb_uid = auth.uid
        user.fb_pic = auth.info.picture.data.url
        user.fb_token = auth.credentials.token
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        #user.fb_raw_data = auth
        user.save!
        return user
      end

    def user_approve(id,token)
      #if id & token match, return user
    end
end
