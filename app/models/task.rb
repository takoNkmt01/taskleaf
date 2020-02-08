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

   #属性と出力する順番を定義する
   def self.csv_attributes
      ["name", "description", "created_at", "updated_at"]
   end

   #csv出力
   def self.generate_csv
      #CSVデータの文字列生成
      CSV.generate(headers: true) do |csv|
         #一行目のヘッダを出力する
         csv << csv_attributes
         #全タスクを取得し一行ごとに出力する
         all.each do |task|
            csv << csv_attributes.map{ |attr| task.send(attr) }
         end
      end
   end

   #CSVインポート
   def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
         task = new
         #to_hashメソッドで値をヘッダーに対応したHash形式で取得する。
         task.attributes = row.to_hash.slice(*csv_attributes)
         task.save!
      end
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
