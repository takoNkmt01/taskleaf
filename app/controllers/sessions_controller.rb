class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    #始めにメールアドレスでユーザーを検索する。
    user = User.find_by(email: session_params[:email])

    #検索したユーザーのパスワード認証をauthenticateメソッドで行う。
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    #ログアウトする
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
