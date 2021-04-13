;; Modified version of the wonderful https://gitlab.com/alexjgriffith/min-love2d-fennel

(require "love.event")
(local fennel (require "fennel"))
(local view (require "fennelview"))

;; This module exists in order to expose stdio over a channel so that it
;; can be used in a non-blocking way from another thread.

(local (event channel) ...)

(when channel
  (let [prompt (fn [] (io.write ">> ") (io.flush) (.. (io.read) "\n"))]
    ((fn looper [input]
       (when input
         ;; This is consumed by love.handlers[event]
         (love.event.push event input)
         (let [output (: channel :demand)
               next-line (and (. output 2) (= "next-line" (. output 2)))]
           ;; There is probably a more efficient way of determining an error
           (if next-line
             :ok

             (and (. output 2) (= "Error:" (. output 2)))
             (print (view output))

             (each [_ ret (ipairs output)]
               (print ret)))

           (io.flush)
           (looper (prompt)))))
     (prompt))))

{:start (fn start-repl []
          (let [code (love.filesystem.read "stdio.fnl")
                luac (if code
                       (love.filesystem.newFileData
                         (fennel.compileString code) "io")
                       (love.filesystem.read "stdio.lua"))
                thread (love.thread.newThread luac)
                io-channel (love.thread.newChannel)
                coro (coroutine.create fennel.repl)
                out (fn [val]
                      (: io-channel :push val))
                options {:readChunk (fn [parser-state]
                                      (when (> parser-state.stack-size 0)
                                        (: io-channel :push ["next-line" "next-line"]))
                                      (coroutine.yield))
                         :onValues out
                         :onError (fn [kind ...] (out [kind "Error:" ...]))
                         :pp view
                         :allowedGlobals false
                         :moduleName "fennel"}]
            ;; this thread will send "eval" events for us to consume:
            (coroutine.resume coro options)
            (: thread :start "eval" io-channel)
            (set love.handlers.eval
                 (fn [input]
                   (coroutine.resume coro input)))))}
