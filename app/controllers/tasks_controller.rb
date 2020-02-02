class TasksController < ApplicationController
  def index
    #@tasks = current_user.tasks.recent
    
    #(params[:q])に検索パラメーターが入り、Tasksテーブルを検索するRansack::Searchオブジェクトを生成
    @q = current_user.tasks.ransack(params[:q])
    #検索結果を表示するtasksオブジェクトを生成
    @tasks = @q.result(distinct: true)
  end

  def show
    @task = current_user.tasks.find(params[:id]) 
  end

  def new
    @task = Task.new
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    task = current_user.tasks.find(params[:id])
    task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  def create
    @task = current_user.tasks.new(task_params)

    #確認画面.戻るボタンのname属性：’back’（params[:back]）が得られた場合に新規登録画面に値を保持したまま戻す
    if params[:back].present?
      render :new
      return
    end

    if @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  #確認画面遷移アクション
  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  private

  #StrongParameters
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
