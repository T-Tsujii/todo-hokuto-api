require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }
  let(:user) { create(:user) }

  describe "GET #index" do
    subject { get(tasks_path, headers: headers) }
    before { create_list(:task, 3, user_id: current_user.id) }

    context "トークン認証情報がない場合" do
      subject { get(tasks_path) }
      let!(:task) { create(:task, user_id: current_user.id) }
      it "エラーする" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ユーザーのタスクが存在するとき" do
      it "タスク一覧を取得できること" do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json.size).to eq 3
        expect(json[0].keys).to eq %w[id body isCompleted]
        expect(json[0]["id"]).to eq Task.first.id
        expect(json[0]["body"]).to eq Task.first.body
        expect(json[0]["isCompleted"]).to eq Task.first.is_completed
      end
    end
  end

  describe "POST #create" do
    subject { post(tasks_path, params: task_params, headers: headers) }
    let(:task_params) { { body: Faker::Book.title, isCompleted: true } }

    context "トークン認証情報がない場合" do
      subject { post(tasks_path, params: task_params) }
      it "エラーする" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "パラメータが正常なとき" do
      it "タスクが保存されること" do
        expect { subject }.to change { Task.count }.by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json.keys).to eq %w[task message]
        expect(json["task"]["body"]).to eq task_params[:body]
        expect(json["task"]["isCompleted"]).to eq false
      end
    end

    context "パラメータが異常なとき" do
      let(:task_params) { { task: attributes_for(:task, :invalid) } }
      it "タスクが保存されないこと" do
        expect { subject }.not_to change { Task.count }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["body"]).to include "を入力してください"
      end
    end
  end

  describe "PATCH #update" do
    subject { patch(task_path(task.id), params: task_params, headers: headers) }

    context "未完了のタスクに対し，パラメータが正常で，本人の投稿の場合" do
      let(:task) { create(:task, :incomplete, user_id: current_user.id) }
      let(:task_params) { { isCompleted: true } }
      it "投稿が更新されること" do
        expect { subject }
          .to change { task.reload.is_completed }
          .from(task.is_completed).to(task_params[:isCompleted])
        expect(task.reload.completed_at).not_to eq Time.new(2000, 1, 1, 0, 0, 0)
        expect(response).to have_http_status(:ok)
      end
    end

    context "未完了のタスクに対し，パラメータが正常でないとき" do
      let(:task) { create(:task, :incomplete, user_id: current_user.id) }
      let(:task_params) { { isCompleted: false } }
      it "422エラーが発生すること" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "完了済みのタスクに対し，パラメータが正常で，本人の投稿の場合" do
      let(:task) { create(:task, :complete, user_id: current_user.id) }
      let(:task_params) { { isCompleted: false } }
      it "投稿が更新されること" do
        expect { subject }
          .to change { task.reload.is_completed }
          .from(task.is_completed).to(task_params[:isCompleted])
        expect(task.reload.completed_at).to eq Time.new(2000, 1, 1, 0, 0, 0)

        expect(response).to have_http_status(:ok)
      end
    end

    context "完了済みのタスクに対し，パラメータが正常でないとき" do
      let(:task) { create(:task, :complete, user_id: current_user.id) }
      let(:task_params) { { isCompleted: true } }
      it "422エラーが発生すること" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete(task_path(task.id), headers: headers) }

    context "本人の投稿の場合" do
      let!(:task) { create(:task, user_id: current_user.id) }
      it "投稿が削除されること" do
        expect { subject }.to change { Task.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "本人以外の投稿の場合" do
      let!(:task) { create(:task, user_id: user.id) }
      it "エラーする" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "トークン認証情報がない場合" do
      subject { delete(task_path(task.id)) }
      let!(:task) { create(:task, user_id: current_user.id) }
      it "エラーする" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
