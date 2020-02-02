class TaskMailer < ApplicationMailer
   #メールの送信元を統一する
   default from: 'taskleaf@example.com'

   def creation_email(task)
      #引数で登録したTaskオブジェクトを後でメール本文のテンプレートで流用するためインスタンス変数に代入する。
      @task = task
      #メール作成、送信を行うmailメソッド。from、to、subjectなどを指定する。
      mail(
         subject: 'タスク作成完了メール',
         to: 'user@example.com',
         from: 'taskleaf@example.com',
      )
   end
end
