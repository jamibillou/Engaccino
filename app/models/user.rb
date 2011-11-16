class User < ActiveRecord::Base
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  middle_name        :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  birthdate          :date
#  phone              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  facebook_connect   :boolean(1)
#  linkedin_connect   :boolean(1)
#  twitter_connect    :boolean(1)
#  admin              :boolean(1)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

