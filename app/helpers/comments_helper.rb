module CommentsHelper

  def link_to_comments_for(commentable)
    link_to icon_tag('comments-alt'), comments_path(commentable_type: commentable.class.to_s, commentable_id: commentable.id),
            remote: true, class: 'comments_link', data: {commentable_type: commentable.class.to_s, commentable_id: commentable.id,
            title: "#{t('comments.link') + link_to(icon_tag('plus'), '#', remote: true,
                 #new_comment_path(commentable_type: commentable.class.to_s, commentable_id: commentable.id),
                 class: 'btn btn-mini pull-right new_comment_link hidden')}"}
  end

  def new_comment_form_for(commentable)
    comment = commentable.comments.build
    form_for comment, remote: true, class: 'new_comment_form', id: 'new_comment_form' do |f|
      f.hidden_field(:commentable_type) +
      f.hidden_field(:commentable_id) +
      f.text_area(:content, rows: 3) +
      f.submit(class: 'btn btn-primary')
    end.html_safe
  end

end
