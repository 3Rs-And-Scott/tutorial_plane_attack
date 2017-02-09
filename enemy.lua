Enemy = Object:extend()

function Enemy:new()
  self.img = enemyImg
  self.x = math.random(10, love.graphics.getWidth() - self.img:getWidth() - 10)
  self.y = 10
end

function Enemy:update(dt)
  self.y = self.y + (150 * dt)
end

function Enemy:draw()
  love.graphics.draw(self.img, self.x, self.y)
end

function Enemy:offScreen()
  return self.y > love.graphics.getHeight() + 50
end
