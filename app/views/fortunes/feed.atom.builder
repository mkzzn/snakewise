atom_feed :language => 'en-US' do |feed|
  feed.title "Snakewise Fortunes"
  feed.updated @fortunes.first.created_at

  @fortunes.each do |fortune|
    feed.entry fortune do |entry|
      entry.title fortune.fortune

      entry.author do |author|
        author.author_name
      end
    end
  end
end
