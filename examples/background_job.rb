# https://gist.github.com/fj/c67a81a8ded757ccc075
require 'yaml'

module RangeQuery
  def weekly(since, till = since + 1.week)
    where(created_at: since...till)
  end
end

class SendWeeklySummary < DCI::Context(:author, posts: RangeQuery)
  def initialize(author) super(author: author, posts: author.posts) end

  def perform since: Date.today.at_beginning_of_week, weekly_posts: self.posts.weekly(since)
    weekly_digest = PostMailer.summary(weekly_posts, to: @author, title: "Your Posts this week")
    weekly_digest.deliver unless weekly_posts.empty?
  end

  # load decoded job
  def init_with(coder)
    initialize Author.find coder['author_id']
  end

  # encode job
  def encode_with(coder)
    coder['author_id'] = @author.id
  end
end
