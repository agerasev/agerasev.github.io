---
layout: post
title:  "Lobachevsky (hyperbolic) space ray tracer"
image:  /assets/posts/hypertrace/preview.png
date:   2020-04-14 13:54:10 +0700
---

## Theory

The approach was inspired by the [Game of Life on Lobachevsky plane](https://habr.com/ru/post/168421/) and extrapolated to 3-dimensional space.

### Position

The position in 3-dimensional Lobachevsky space is represented by a [quaternion](https://en.wikipedia.org/wiki/Quaternion) of form:

$$ \mathbf{p} = x + iy + jz $$

where $$x$$, $$y$$ and $$z$$ are coordinates in [Poincaré half-space model](https://en.wikipedia.org/wiki/Poincar%C3%A9_half-plane_model) with $$ z > 0 $$.

The point of origin in such representation is $$j$$.

### Transformation

#### Requirements

In Lobachevsky space we have only 2 kinds of similarity transformations: shift and rotation (and their combination). To implement them we need at least 3 following basic transformations:

1. Shift along $$z$$-axis.
2. Rotation around $$z$$-axis.
3. Rotation around $$y$$-axis.

In Poincaré half-space model shift along $$z$$-axis is simply a scaling; and rotation around $$z$$-axis remains itself. The rotation around $$y$$-axis is more tricky - it's like twisting around unit ring lying in $$ x = 0 $$ plane.

#### Representation

Required transformations could be represented by the subset of quaternionic [Möbius transformations](https://en.wikipedia.org/wiki/M%C3%B6bius_transformation):

$$ f(\mathbf{q}) = (a \mathbf{q} + b)(c \mathbf{q} + d)^{-1} $$

where $$\mathbf{q}$$ is a quaternion representing position, $$a$$, $$b$$, $$c$$ and $$d$$ - some complex numbers which satisfy $$ad - bc = 1$$. Remember that quaternion multiplication is non-commutative.

We can also write this transformation in matrix form:

$$
f(\mathbf{q}) =
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\mathbf{q}
$$

Interestingly, we can consider the composition of Möbius transformations as the matrix product.

Now let's write down our basic transformations as Möbius transformations:

1. Shift along $$z$$-axis by the distance $$L$$:

   $$
   S_x = \begin{bmatrix}
   e^{L/2} & 0 \\
   0 & e^{-L/2}
   \end{bmatrix}
   $$

2. Rotation around $$z$$-axis by the angle $$\varphi$$:

   $$
   R_z = \begin{bmatrix}
   \cos{\frac{\varphi}{2}} + i\sin{\frac{\varphi}{2}} & 0 \\
   0 & \cos{\frac{\varphi}{2}} - i\sin{\frac{\varphi}{2}}
   \end{bmatrix}
   $$

3. Rotation around $$y$$-axis by the angle $$\theta$$:

   $$
   R_y = \begin{bmatrix}
   \cos{\frac{\theta}{2}} & -\sin{\frac{\theta}{2}} \\
   \sin{\frac{\theta}{2}} & \cos{\frac{\theta}{2}}
   \end{bmatrix}
   $$

#### Derivation

We also need to have a derivative of the transformation, e.g. to apply the transformation to direction rather than point. The [derivation of quaternionic functions](https://en.wikipedia.org/wiki/Quaternionic_analysis#The_derivative_for_quaternions) isn't easy because of their non-commutativity, and also the derivative is direction-dependent.

The derivative of quaternionic function $$f$$ at the point $$\mathbf{p}$$ along the direction $$\mathbf{v}$$:

$$
\frac{d f(\mathbf{q})}{d \mathbf{q}} \circ \mathbf{v} = \lim_{\varepsilon \to 0} \frac{f(\mathbf{q} + \varepsilon \mathbf{v}) - f(\mathbf{q})}{\varepsilon} 
$$

Substituting our Möbius transformation for $$f$$ and slightly simplifying the formula we get:

$$
\mathbf{P} = a \mathbf{q} + b
$$

$$
\mathbf{Q} = c \mathbf{q} + d
$$

$$
\frac{d f(\mathbf{q})}{d \mathbf{q}} \circ \mathbf{v} = a \mathbf{v} \mathbf{Q}^{-1} + \mathbf{P} (\overline{(c \mathbf{v})} - 2 [\mathbf{Q} \cdot (c \mathbf{v})] \mathbf{Q}^{-1}) |\mathbf{Q}|^{-2}
$$

where $$\overline{\mathbf{x}}$$ is quaternionic conjugation, and $$[\mathbf{x} \cdot \mathbf{y}]$$ is dot product of two quaternions as if they were 4-dimensional vectors.
