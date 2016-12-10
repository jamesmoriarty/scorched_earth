include Java

import java.awt.event.WindowEvent
import java.awt.image.BufferStrategy
import javax.swing.JFrame
import java.awt.Canvas
import java.awt.Dimension
import javax.swing.JPanel
import java.awt.Color

require 'scorched_earth/game'
require 'scorched_earth/event/mouse_pressed'
require 'scorched_earth/event/mouse_released'
require 'scorched_earth/event/mouse_moved'

module ScorchedEarth
  class GameWindow
    include java.awt.event.MouseMotionListener
    include java.awt.event.MouseListener

    attr_reader :buffer_strategy, :canvas, :game

    def initialize(width, height)
      @container = JFrame.new
      @canvas    = Canvas.new
      @panel     = @container.get_content_pane

      @container.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE

      @panel.set_preferred_size Dimension.new width, height
      @panel.set_layout nil
      @container.set_cursor nil
      @panel.add @canvas

      @container.pack
      @container.set_resizable false
      @container.set_visible true

      @canvas.set_bounds 0, 0, width, height

      @canvas.add_mouse_listener self
      @canvas.add_mouse_motion_listener self

      @canvas.set_ignore_repaint true
      @canvas.create_buffer_strategy 2
      @buffer_strategy = @canvas.get_buffer_strategy

      @game = ScorchedEarth::Game.new canvas.width, canvas.height
    end

    def run
      last_time = Time.now

      game.setup

      loop do
        delta     = Time.now - last_time
        last_time = Time.now
        graphics  = buffer_strategy.get_draw_graphics

        game.update delta
        game.render graphics

        graphics.dispose
        buffer_strategy.show

        sleep 1.0 / 60
      end
    end

    private

    def mouse_moved(event)
      x = event.point.x
      y = event.point.y

      game.publish Event::MouseMoved.new x, y
    end

    def mouse_dragged(*args); end

    def mouse_pressed(event)
      x = event.point.x
      y = event.point.y

      game.publish Event::MousePressed.new x, y
    end

    def mouse_released(event)
      x = event.point.x
      y = event.point.y

      game.publish Event::MouseReleased.new x, y
    end

    def mouse_clicked(*args); end

    def mouse_entered(*args); end

    def mouse_exited(*args); end
  end
end
