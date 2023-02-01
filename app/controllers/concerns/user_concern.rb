module UserConcern
  extend ActiveSupport::Concern

  def user_app_data(user)
    posts = Post.find_by_user_id(user.id)
    articles = Article.find_by_user_id(user.id)

    {
      user: user,
      posts: posts,
      articles: articles
    }
  end
end