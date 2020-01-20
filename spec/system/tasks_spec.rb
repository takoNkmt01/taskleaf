require 'rails_helper'

describe 'タスク管理機能', type: :system do
   #ユーザーAとユーザーBをわかりやすくletで定義。
   let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
   let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
   #let!とすることで呼ばれる前から下記のテストデータを無条件に作成できる。
   let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

   #一覧表示機能の前処理
   before do
      #FactoryBotで設定したユーザーデータをデータベースに登録する。
      #user_a = FactoryBot.create(:user)
      #↓名前とEメールを指定した値に変えてユーザーデータを作成する。
      #user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')→letで定義したからいらない子
      #ユーザーAに紐付くタスクを作成する。タスク名とユーザー関連を指定する。
      #タスクオブジェクトはテストの後方で使う予定がないからローカル変数に代入しない
      #FactoryBot.create(:task, name: '最初のタスク', user: user_a)#→ここでletで定義sたuser_aが呼ばれてデータベースに登録される。

      #特定のURLにアクセスするには visit [URL] を用いる
      visit login_path
      #メールアドレスという<label>要素のテキストフィールドにメールアドレスを入力する。
      fill_in 'メールアドレス', with: login_user.email#→各contextから取得したlet(:login_user)を呼び出す
      #パスワードも同様
      fill_in 'パスワード', with: login_user.password
      #’ログインする’ボタンを押す
      click_button 'ログインする'
   end

   #同じ内容のit構文を共通化できるShared_Exampleメソッド
   shared_examples_for 'ユーザーAが作成したタスクが表示される' do
      it { expect(page).to have_content '最初のタスク' }
   end

   describe '一覧表示機能' do
      context 'ユーザーAがログインしている時' do
         let(:login_user) { user_a }

         #上記で宣言したShared_Exapleを呼び出す
         it_behaves_like 'ユーザーAが作成したタスクが表示される'
      end

      context 'ユーザーBがログインしている時' do
         let(:login_user) { user_b }

         it 'ユーザーAが作成したタスクが表示されない' do
            #page(画面)に期待するよ。ないはずだよね、「最初のタスク」という内容が
            expect(page).to have_no_content '最初のタスク'
         end
      end
   end

   describe '詳細表示機能' do
      context 'ユーザーAがログインしている時' do
         let(:login_user) { user_a }

         before do
            visit task_path(task_a)
         end

         it_behaves_like 'ユーザーAが作成したタスクが表示される'
      end
   end

   describe '新規作成昨日' do
      let(:login_user) { user_a }

      before do
         visit new_task_path
         fill_in '名称', with: task_name
         click_button '登録する'
      end

      context '新規作成画面で名称を入力したとき' do
         let(:task_name) { '新規作成のテストを書く' }

         it '正常に登録される' do
            #CSSセレクタを指定して’新規作成のテストを書く’タスクが登録されたかを検証する
            expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
         end
      end

      context '新規作成画面で名称を入力しなかったとき' do
         let(:task_name) { '' }

         it 'エラーをなる' do
            #id(error_explanation)を指定してその範囲の中で'名称を入力してください'の文言が含まれているかを検証する
            within '#error_explanation' do
               expect(page).to have_content '名称を入力してください'
            end
         end
      end
   end
end