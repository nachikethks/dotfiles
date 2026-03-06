swayimg.imagelist.enable_adjacent(true)

swayimg.viewer.on_key("h", function()
    swayimg.viewer.open("prev")
end)

swayimg.viewer.on_key("l", function()
    swayimg.viewer.open("next")
end)
