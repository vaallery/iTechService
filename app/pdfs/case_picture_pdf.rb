# encoding: utf-8
class CasePicturePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(file)
    super page_size: 'A4', page_layout: :portrait
    @case_height = 126.mm
    @case_width = 62.mm
    @x1 = 60.mm
    @y1 = 200.mm
    @x2 = @x1 + @case_width
    @y2 = @y1 - @case_height
    @r = 10.mm

    save_graphics_state do
      soft_mask do
        fill_color 'ffffff'
        fill_and_stroke do
          draw_countour
        end
      end
      image file, width: @case_width + 20.mm, height: @case_height + 10.mm, at: [@x1 - 10.mm, @y1 + 5.mm]
    end
    stroke { draw_countour }
  end

  private

  def draw_countour
    # left side
    line [@x1, @y1 - @r], [@x1, @y1 + 5.mm]
    rounded_vertex @r, [@x1, @y1 + 5.mm], [@x1 - @r, @y1 + 5.mm], [@x1 - @r, @y1 - 5.mm]
    line_to @x1 - 10.mm, @y2 + 5.mm
    rounded_vertex @r, [@x1 - @r, @y2 + 5.mm], [@x1 - @r, @y2 - 5.mm], [@x1, @y2 - 5.mm]
    line_to @x1, @y2 + @r

    # bottom side
    rounded_vertex @r, [@x1, @y2 + @r], [@x1, @y2], [@x1 + @r, @y2]
    line_to @x1 + @r, @y2 - 2.mm
    line_to @x2 - @r, @y2 - 2.mm
    line_to @x2 - @r, @y2
    rounded_vertex @r, [@x2 - @r, @y2], [@x2, @y2], [@x2, @y2 + @r]

    # right side
    line_to @x2, @y2 - 5.mm
    rounded_vertex @r, [@x2, @y2 - 5.mm], [@x2 + @r, @y2 - 5.mm], [@x2 + @r, @y2 + @r]
    line_to @x2 + @r, @y1 - 5.mm
    rounded_vertex @r, [@x2 + @r, @y1 - 5.mm], [@x2 + @r, @y1 + 5.mm], [@x2, @y1 + 5.mm]
    line_to @x2, @y1 - @r

    # top side
    rounded_vertex @r, [@x2, @y1 - @r], [@x2, @y1], [@x2 - @r, @y1]
    line_to @x2 - @r, @y1 + 2.mm
    line_to @x1 + @r, @y1 + 2.mm
    line_to @x1 + @r, @y1
    rounded_vertex @r, [@x1 + @r, @y1], [@x1, @y1], [@x1, @y1 - @r]
  end

end