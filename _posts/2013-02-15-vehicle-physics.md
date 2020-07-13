---
layout: post
title:  "Simple 3D vehicle physics simulator"
image:  /assets/posts/vehicle-physics/preview.png
date:   2013-02-15 05:34:50 +0800
---

I worked on this toy project in the winter between 2012 and 2013. This was my first year in Novosibirsk State University. I studied calculus, linear algebra and mechanics, and I tried to apply some new knowledge I learnt. I already tried to learn C++ and OpenGL by myself.

## Video

{% include youtube_player.html id="7S7wDXqOB8Y" %}

## Source

You can find the source code at the GitHub: [https://github.com/agerasev/akadem](https://github.com/agerasev/akadem).

You can easily build it by yourself using `make`. The only libraries required are `SDL` and `SDL_ttf`.

Also the `windows_build` branch already contains pre-built binaries for Windows.

## Simulation

The vehicle acts as rigid body with its own mass and moment of inertia. There are 3 forces acting on this body:  

+ Gravity - simply applies constant force to the center of mass of the body.
+ Wheel spring reaction - that force coming from compressed wheel springs that obey Hooke's law.
+ Friction of 4 kinds:
  + Wheel spring friction - simulates the shock absorber behavior. Follows the liquid friction law.
  + Wheel rotation friction - small force that is applied to the rotating wheel. Proportional to the wheel rotation speed.
  + Tire sliding friction - the force that coming from tire sliding on the ground. Its direction is opposite to the tire sliding direction, and its absolute value depends only on the wheel reaction force and doesn't depends on sliding speed.
  + Tire static friction - when sliding friction is greater than the force that is enough to synchronize the tire with the ground, then the second one is used instead and called static friction force.

The wheels themselves have no mass and geometry. They are simply positioned under the vehicle at the intersection with the surface. The tire velocity is simply the wheel velocity added to its lower point rotation velocity.

## Models

Mitsubishi L200 model is used as vehicle model. The texture was made from images taken from official Mitsubishi website, the 3D shape was created in custom 3D editor (included in source as `3d-editor`).

![Custom 3D editor]({{ "/assets/posts/vehicle-physics/3d-builder.png" | relative_path }})
*3D editor screenshot*

Terrain has a shape of a square patch of a surface defined by the following equation:

$$
z = -\frac{1}{1 + x^2 + y^2}
$$
