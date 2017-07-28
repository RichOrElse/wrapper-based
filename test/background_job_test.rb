Post = Struct.new(:id, :author, :created_at)
Author = Struct.new(:id, :email, :posts)
PostMailer = Class.new

require 'test_helper'
require 'active_support/all'
require_relative '../examples/background_job'

class BackgroundJobTest < MiniTest::Test
  def setup
    @mail   = stub :deliver
    @author = Author[1, 'author@background-job-test.com']
    @post   = Post[1, @author, Time.now]
    Author.stubs(:find).with(1).returns(@author)
    PostMailer.stubs(summary: @mail)
  end

  def test_deserialized_job_perform
    @mail.expects(:deliver)
    @author.stubs(:posts).returns stub(where: [@post])

    job         = SendWeeklySummary[@author]
    encoded     = YAML.dump job
    decoded_job = YAML.load encoded
    decoded_job.perform

    assert_equal encoded, decoded_job.to_yaml
    assert_equal @author, decoded_job.author
  end

  def test_perform_with_empty_posts
    @mail.expects(:deliver).never
    @author.stubs(:posts).returns stub(where: [])
    SendWeeklySummary[@author].perform
  end
end
