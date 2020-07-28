---
layout: post
title:  "Viscous fluid flow prediction with U-Net"
image:  /assets/posts/flownn/preview.png
date:   2018-06-01 16:44:00 +0700
---

This is my attempt to use deep learning techniques for realistic simulation of viscous fluid flow. [Here](https://github.com/agerasev/flownn) you can find the source code and notebooks.

{% include youtube_player.html id="4N-s4f00J6s" %}

| *Left side:* Numerical solution | *Right side:* U-Net prediction |

## Simulation

### Theory

Navier-Stokes equation for incompressible fluid can be written in the following form:

$$
\frac{\partial \overrightarrow{\upsilon}}{\partial t} = - (\overrightarrow{\upsilon} \cdot \nabla) \overrightarrow{\upsilon} + \nu \Delta \overrightarrow{\upsilon} - \frac{1}{\rho} \nabla p + \overrightarrow{f}
$$

where
+ $$ \overrightarrow{\upsilon} $$ - velocity field,
+ $$ p $$ - pressure field,
+ $$ \nu $$ - fluid viscosity,
+ $$ \rho $$ - fluid density,
+ $$ \overrightarrow{f} $$ - external force.

Previous equation is also complemented by the incompressibility condition:

$$
\nabla \cdot \overrightarrow{\upsilon} = 0
$$

### Implementation

One of the simplest numerical solution implementation of this equation is described in [chapter 38](https://developer.download.nvidia.com/books/HTML/gpugems/gpugems_ch38.html) of the [GPU Gems](https://developer.nvidia.com/gpugems/gpugems/contributors) book. It uses grid-based representation of the spatial fields (velocity, pressure, etc.) and Jacobi iteration technique to solve the above mentioned differential equations. This algorithm can be effectively implemented on the GPU, but the more accuracy we want to get, the more iterations need to be done.

The algorithm was implemented in OpenCL.

## Prediction


## Results


