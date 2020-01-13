class User < ApplicationRecord

=begin
      
   ●bycript Gem -has_secure_passwordメソッドの機能
    ・対象modelに「password」と「password_confirmation」を追加する➡︎DBには「password_digest」というcolumnにbycript関数化したパスワードを格納する。
    ・上記２項目のValidationの追加
    ・authenticateメソッドの追加
      
=end
   has_secure_password

   validates :name, presence: true
   validates :email, presence: true, uniqueness: true

   has_many :tasks
end
