require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 10)
      create_list(:article, 5, :published)
    end

    it "公開済み記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq Article.published.count
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在し公開済みの場合" do
      let(:article) { create(:article, :published) }
      let(:article_id) { article.id }

      it "記事の詳細を表示できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 100000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "指定した記事が下書き状態の場合" do
      let(:article) { create(:article, :draft) }
      let(:article_id) { article.id }

      it "詳細が見れない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { authenticate_user_headers(current_user) }

    context "公開済みを選択したとき" do
      let(:params) { { article: attributes_for(:article, :published) } }

      it "公開記事を作成できる" do
        expect { subject }.to change { current_user.articles.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "published"
      end
    end

    context "下書きを選択したとき" do
      let(:params) { { article: attributes_for(:article, :draft) } }

      it "下書き記事を作成できる" do
        expect { subject }.to change { current_user.articles.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "draft"
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { authenticate_user_headers(current_user) }

    context "自分の記事を更新するとき" do
      let(:article) { create(:article, user: current_user) }

      it "任意の記事の更新ができる" do
        expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
                              change { Article.find(article.id).body }.from(article.body).to(params[:article][:body])
      end
    end

    context "他のuserの記事を更新しようとるすとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), params: params, headers: headers) }

    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:params) { { article: attributes_for(:article) } }
    let(:headers) { authenticate_user_headers(current_user) }

    context "自分の記事を削除するとき" do
      it "記事の削除ができる" do
        expect { subject }.to change { current_user.articles.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他のuserの記事を削除するとき" do
      let!(:article) { create(:article, user: other_user) }
      let(:other_user) { create(:user) }
      let(:params) { { article: attributes_for(:article) } }

      it "削除できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
