---
layout: post
title:  "Viscous fluid flow prediction with U-Net"
date:   2018-06-01 16:44:00 +0700
categories: jekyll update
---

## Solution

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
