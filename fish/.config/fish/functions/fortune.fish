function fortune --description 'display fortune in blue' --wraps fortune
	set_color blue
        command fortune
        set_color normal
end
