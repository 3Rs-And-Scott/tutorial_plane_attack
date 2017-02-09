debug = true

-- player data
playerImg = nil
isAlive = true
score = 0

-- bullet timer, image, and collection
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
bullet2Img = nil
bullets = {}

-- enemy timer and collection
createEnemyTimerMaxMax = 0.8
createEnemyTimerMax = 0.8
difficultyTimerMax = 4.0
createEnemyTimer = createEnemyTimerMax
difficultyTimer = difficultyTimerMax
enemyImg = nil
enemies = {}

function love.load(args)
  Object = require "classic"
  require "player"
  require "enemy"

  playerImg = love.graphics.newImage("assets/plane.png")
  bulletImg = love.graphics.newImage("assets/bullet.png")
  bullet2Img = love.graphics.newImage("assets/bullet2.png")
  enemyImg = love.graphics.newImage("assets/enemy.png")

  player = Player()
end

function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.push("quit") -- quit the game
  end

  if not isAlive then
    if love.keyboard.isDown("r") then
      -- remove all our bullets and enemies from screen
      bullets = {}
      enemies = {}

      -- reset timers
      canShootTimer = canShootTimerMax
      createEnemyTimer = createEnemyTimerMax
      createEnemyTimerMax = createEnemyTimerMaxMax

      -- move player back to default position
      player = Player()

      -- reset our game state
      score = 0
      isAlive = true
    end
  else
    player:update(dt)

    -- Time out how far apart our shots can be.
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
      canShoot = true
    end

    if love.keyboard.isDown("space") and canShoot then
      -- create a bullet
      local newBullet = { x = player.x + player.img:getWidth() / 2 - 20, y = player.y + 10, img = bullet2Img }
      table.insert(bullets, newBullet)
      newBullet = { x = player.x + player.img:getWidth() / 2, y = player.y, img = bulletImg }
      table.insert(bullets, newBullet)
      newBullet = { x = player.x + player.img:getWidth() / 2 + 20, y = player.y + 10, img = bullet2Img }
      table.insert(bullets, newBullet)

      -- reset bullet timer
      canShoot = false
      canShootTimer = canShootTimerMax
    end

    for i, bullet in ipairs(bullets) do
      bullet.y = bullet.y - (250 * dt) -- make the bullets move
      if (bullet.y < 0) then
        table.remove(bullets, i) -- remove bullets that have gone off screen
      end
    end

    -- Time out enemy creation
    createEnemyTimer = createEnemyTimer - (1 * dt)
    if createEnemyTimer < 0 then
      createEnemyTimer = createEnemyTimerMax

      -- Create an enemy
      local newEnemy = Enemy()
      table.insert(enemies, newEnemy)
    end

    difficultyTimer = difficultyTimer - (1 * dt)
    if difficultyTimer < 0 then
      difficultyTimer = difficultyTimerMax
      createEnemyTimerMax = createEnemyTimerMax - 0.01
    end

    -- update the positions of enemies
    for i, enemy in ipairs(enemies) do
      enemy:update(dt)

      if enemy:offScreen() then -- remove enemies when they pass off the screen
        table.remove(enemies, i)
      end
    end

    -- run our collision detection
    -- Since there will be fewer enemies on screen than bullets we'll loop them first
    -- Also, we need to see if the enemies hit our player
    for i, enemy in ipairs(enemies) do
      for j, bullet in ipairs(bullets) do
        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
          table.remove(bullets, j)
          table.remove(enemies, i)
          score = score + 1
        end
      end

      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight())
      and isAlive then
        table.remove(enemies, i)
        isAlive = false
      end
    end
  end
end

function love.draw()
  if isAlive then
    player:draw()
  else
    love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
  end
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)  -- draw the bullet
  end
  for i, enemy in ipairs(enemies) do
    enemy:draw()
  end

  love.graphics.print(string.format("FPS: %s", love.timer.getFPS()), 10, 10)
  love.graphics.printf(string.format("%s", score), love.graphics.getWidth() - 90, love.graphics.getHeight() - 20, 80, "right")
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
