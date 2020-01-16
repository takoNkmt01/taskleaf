require 'rails_helper'

describe 'タスク管理機能', type: :system do
   describe '一覧表示機能' do
      #一覧表示機能の前処理
      before do
         #FactoryBotで設定したユーザーデータをデータベースに登録する。
         #user_a = FactoryBot.create(:user)
         #↓名前とEメールを指定した値に変えてユーザーデータを作成する。
         user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
         #ユーザーAに紐付くタスクを作成する。タスク名とユーザー関連を指定する。
         #タスクオブジェクトはテストの後方で使う予定がないからローカル変数に代入しない
         FactoryBot.create(:task, name: '最初のタスク', user: user_a)

         #特定のURLにアクセスするには visit [URL] を用いる
         visit login_path
         #メールアドレスという<label>要素のテキストフィールドにメールアドレスを入力する。
         fill_in 'メールアドレス', with: 'a@example.com'
         #パスワードも同様
         fill_in 'パスワード', with: 'password'
         #’ログインする’ボタンを押す
         click_button 'ログインする'
      end

      context 'ユーザーAがログインしている時' do
         it 'ユーザーAが作成したタスクが表示される' do
            #page(画面)に期待するよ。あるはずだよね、「最初のタスク」という内容が
            expect(page).to have_content '最初のタスク'
         end
      end

      context 'ユーザーBがログインしている時' do
         before do
            #ユーザーBを作成
            FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
         end

         it 'ユーザーAが作成したタスクが表示されない' do
            #page(画面)に期待するよ。ないはずだよね、「最初のタスク」という内容が
            expect(page).to have_no_content '最初のタスク'
         end
      end
   end
end