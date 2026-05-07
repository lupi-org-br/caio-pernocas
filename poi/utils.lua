function draw_box(box, camera)
    ui.draw_rect(box.x, box.y, box.x + box.width, box.y + box.height, false, 4)
end

function check_collision(a, b)
    return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end
