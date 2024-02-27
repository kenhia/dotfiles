function occasional_fortune --description 'display fortune if time has passed'
    # how long to wait between cookies in seconds
    set fasting_time 900

    # how long since last cookie 
    if test "$last_fortune_cookie" = ""
        set -U last_fortune_cookie 0
    end
    set elapsed (math (date +%s) - $last_fortune_cookie)
    if test $elapsed -gt $fasting_time
        set_color blue
        fortune
        set_color normal
        # We got a cookie! Let's record the time so we don't overeat
        set -U last_fortune_cookie (date +%s)
    end
end
