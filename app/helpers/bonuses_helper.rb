module BonusesHelper

  def bonus_popover_title(bonus)
    button_to_close_popover(data: {owner: "#bonus_#{bonus.id}"}) +
    content_tag(:strong, bonus.name)
  end

  def bonus_popover_content(bonus)
    content_tag(:p, bonus.comment) +
    render(bonus.karmas)
  end

end