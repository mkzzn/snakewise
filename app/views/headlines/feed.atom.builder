atom_feed :language => 'en-US' do |feed|
  feed.title "Snakewise Headlines"
  feed.updated @headlines.first.created_at

  @headlines.each do |headline|
    feed.entry headline do |entry|
      entry.title headline.headline

      entry.author do |author|
        author.author_name
      end
    end
  end
end
