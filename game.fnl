(var lillian (love.graphics.newImage "lillian.png"))
(var x 50)
(var y 50)
(var speed 3)

(fn love.load []
  (print "Game loaded!"))

(fn love.update [dt]
  (if
    (love.keyboard.isDown "right")
    (set x (+ x speed))

    (love.keyboard.isDown "left")
    (set x (- x speed))

    (love.keyboard.isDown "down")
    (set y (+ y speed))

    (love.keyboard.isDown "up")
    (set y (- y speed))))

(fn love.draw []
  (love.graphics.draw lillian x y))

(comment
  (set speed 10))
