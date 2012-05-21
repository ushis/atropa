atom_feed do |feed|
  feed.title 'atropa'
  feed.updated @videos[0].created_at if @videos.length > 0

  @videos.each do |video|
    feed.entry(video) do |entry|
      entry.title video.title
      entry.content link_to(video_preview(video, 300), video_url(video)), type: :html

      entry.author do |author|
        author.name video.user.username
      end
    end
  end
end
