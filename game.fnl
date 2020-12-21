(fn love.load []
  (print "Hello, World!"))

(fn love.draw []
  (love.graphics.setColor 0 0.4 0.4)
  (love.graphics.rectangle "fill" 10 10 50 50))
