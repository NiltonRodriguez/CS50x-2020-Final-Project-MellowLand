# [CS50x(2020) Final Project:](https://cs50.harvard.edu/x/2020/project/#final-project) __Mellow Land__
## Video Demo: [CS50x Final Project 2020](https://www.youtube.com/watch?v=88to8FiGnXQ)

## Description:

Mellow Land is a Platform game developed in Lua with Löve2D. Inspired on Mario, Megaman, Kirby and other classic platform games.

The main character is Mellow, who have the ability to change element when collect the element Coins.

Each element have two skills:<br>
Fire: Can dash and shoot flames.Powerful against Beh.<br>
Water: Have higher jump and shoot bubbles. Powerful against Cal.<br>
Wing: Have a Quad Jump and shoot a breeze. Powerful against Squ.

Mellow can collect boxes and for each 15 boxes gain 1 life.

The goal is to collect the elemental coins, boxes and complete the four stages.

### Content:
- [Assets](/assets): Contains all the images used in the game. All are my own design made on Autodesk Sketchbook and Procreate.
- [Map](/map): For the map design I used Tiled, a tile map editor. This folder contains the map files (Tiled and Lua).
- [SFX](/sfx): Contains the music and sound effects.
- [STI](/sti): And external library by [Landon Manning](https://github.com/karai17) for the tiled map and box2d physics implementation.
- [Box Class](/box.lua): Contains the parameters for the box implementation: The box initialization, count, animations and physics.
- [Camera Class](/camera.lua): Contains the implementation of the camera movement.
- [Cloud Class](/cloud.lua): Contains the parameters for the cloud implementation: The cloud initialization, damage and physics.
- [Coin Class](/coin.lua): Contains the parameters for the implementation of the elemental coins: The coins initialization, remove, count, animations and physics.
- [Enemy Class](/enemy.lua): Contains the parameters for the 3 enemy types. The enemy initialization, remove, movement, animations, damage and physics.
- [Flag class](/flag.lua): Contains the parameters for the flag implementation.
- [Font](/font.ttf): 04B_30 by Yuji Oshimoto.
- [GUI Class](/gui.lua): Contains the parameters to display information on the stage screen as: lives, boxes, coins and the stage.
- [Loser Class](/loser.lua): Contains the animation to display the Game Over screen.
- [Main](/main.lua): Contains the parameters to run the game. Is the file that load, update and render the game.
- [Map Class](/map.lua): Contains the parameters to load all the elements of the map for each stage.
- [Messages](/messages.lua): Contains the parameters to display all the non playable screens and the current frames per second (FPS).
- [Player Class](/Player.lua): Contains the player parameters as: the player initialization, animations, movement and physics.
- [Power Class](/power.lua) Contains the parameters for the 3 powers the player can use.
- [Winner](/winner.lua): Contains the animation to display victory screen.

## Special Thanks.

I want to thank all who participated on this project. My family support that has no limits, Joha who always listened and stayed with me no matter what.<br/>
Simon Rahnasto who teach me a lot and brought me light when I needed.<br/>
And the CS50 Crew that helped me become better than I was on Week 0.
