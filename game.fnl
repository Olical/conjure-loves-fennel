(fn love.load []
  (global lillian (love.graphics.newImage "lillian.png"))
  (global x 50)
  (global y 50)
  (global speed 3)
  (print "Game loaded!"))

(fn love.update []
  (if
    (love.keyboard.isDown "right")
    (global x (+ x speed))

    (love.keyboard.isDown "left")
    (global x (- x speed))

    (love.keyboard.isDown "down")
    (global y (+ y speed))

    (love.keyboard.isDown "up")
    (global y (- y speed))))

(fn love.draw []
  (love.graphics.draw lillian x y))
