module CommentsHelper

  def comments_list_for(commentable)
    cell(Comment::Cell::Preview, collection: commentable.comments.oldest).call
  end

  def comment_form_for(commentable)
    cell(Comment::Cell::Form, commentable.comments.build).call
  end

  def link_to_comments_for(commentable, options={})
    link_class = 'comments_link ' + (options[:class] || '')
    link_to icon_tag('comments-alt'), comments_path(commentable_type: commentable.class.to_s, commentable_id: commentable.id),
            remote: true, class: link_class, data: {commentable_type: commentable.class.to_s, commentable_id: commentable.id,
            title: "#{t('comments.link') + link_to(icon_tag('plus'), '#', remote: true,
                 #new_comment_path(commentable_type: commentable.class.to_s, commentable_id: commentable.id),
                 class: 'btn btn-mini pull-right new_comment_link hidden')}"}
  end

  def new_comment_form_for(commentable, options={})
    comment = commentable.comments.build
    remote = (options[:remote].nil? ? true : options[:remote])
    form_for comment, remote: remote, class: 'new_comment', id: 'new_comment' do |f|
      f.hidden_field(:commentable_type) +
      f.hidden_field(:commentable_id) +
      f.text_area(:content, rows: 3) +
      f.submit(class: 'btn btn-primary')
    end.html_safe
  end

end
