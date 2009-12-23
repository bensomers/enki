atom_feed(
  :url         => formatted_posts_path(:tag => @tag, :format => 'atom', :only_path => false),
  :root_url    => posts_path(:tag => @tag, :only_path => false),
  :schema_date => '2008'
) do |feed|
  feed.title     posts_title(@tag)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:edited_at).max
  feed.generator "Enki", "uri" => "http://enkiblog.com"

  @posts.each do |post|
   feed.entry(post, :url => post_path(post, :only_path => false), :published => post.published_at, :updated => post.edited_at) do |entry|
      entry.title   post.title
      entry.content post.body_html, :type => 'html'

      feed.author do |xml|
        xml.name  post.author.name
        xml.email post.author.email
      end
    end
  end
end
