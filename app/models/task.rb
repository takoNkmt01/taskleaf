class Task < ApplicationRecord
   #1つのタスクに1つの画像を紐付けることを意味する。そしてTaskモデルからはそれをimageと呼ぶことを指定
   has_one_attached :image
   
   validates :name, presence: true
   validates :name, length: { maximum: 30 }
   validate :validate_name_not_including_comma

   belongs_to :user

   scope :recent, -> { order(created_at: :desc) }

   #ransackable_attributesで検索対象することを許可するcolumnを指定する。
   def self.ransackable_attributes(auth_object = nill)
      %w[name created_at]
   end

   #ransackable_associationsで検索条件に含める関連を指定する。空の配列を返すように指定すれば意図しない関連を排除できる。
   def self.ransackable_associations(auth_object = nill)
      []
   end

   private

   def validate_name_not_including_comma
      errors.add(:name, 'にカンマを含めることはできません。') if name&.include?(',')
   end
end
