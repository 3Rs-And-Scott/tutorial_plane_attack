Player = Object:extend()

function Player:new()
  self.img = playerImg
  self.x = love.graphics.getWidth() / 2 - self.img:getWidth() / 2
  self.y = love.graphics.getHeight() - 90
  self.speed = 250
end

function Player:update(dt)
  if love.keyboard.isDown("left", "a") then
    if self.x > 0 then
      self.x = self.x - self.speed * dt -- move the player to the left
    end
  elseif love.keyboard.isDown("right", "d") then
    if self.x < love.graphics.getWidth() - self.img:getWidth() then
      self.x = self.x + self.speed * dt -- move the player to the right
    end
  end
  if love.keyboard.isDown("up", "w") then
    if self.y > 0  then
      self.y = self.y - self.speed * dt -- move the player up
    end
  elseif love.keyboard.isDown("down", "s") then
    if self.y < love.graphics.getHeight() - self.img:getHeight() then
      self.y = self.y + self.speed * dt -- move the player down`
    end
  end
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end

function Player:offScreen()
  return self.y > love.graphics.getHeight() + 50
end
