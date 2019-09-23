---
layout: post
title:  "Clay: Ray tracer in Rust and OpenCL"
date:   2019-09-23 15:16:00 +0700
---

## About
{:.no_toc}

This post is about my attempt to write a small Monte-Carlo ray tracer in Rust and OpenCL. It is aimed to be a convenient framework for toy experiments with ray tracing, so the main goals was modularity and extendability, and also performance were taken into account. Here is the [main page of the project](https://clay-rs.github.io).

## Table of content
{:.no_toc}

* TOC
{:toc}

## Preface

I like computer graphics and especially ray tracing because being based only on a few physical rules it is able to produce beautiful images. Sometimes to draw a pretty image of some data or check some new idea it is necessary to implement a simple ray tracer which requires a lot of boilerplate code. Instead of implementing this code every time it would be nice to use some flexible ray tracing framework.

### Existing solutions

Some existing ray tracing engines are proprietary, some are too specialized and aren't allow you to do arbitrary things with rays. I've found amazing [Mitsuba renderer](https://www.mitsuba-renderer.org/) which is open-source, research-oriented and very customizable. But it seems to be relatively heavy and complex, and, what is most important, it is quite slow for short-time rendering (according to [this article](https://www.cg.tuwien.ac.at/research/publications/2018/glanz-2017-pbrcomparison/) it performs around *one* sample per pixel per second for 800x600 pixels on sufficiently complex scene). Note, that in long run it could perform much better because of using advanced techniques like Metropolis light transport that converges faster than simple backward light propagation. But for fast prototyping it's undesirable to wait for minutes to get perceptible image, it should be got as fast as possible - in real-time in the ideal case.

### My previous work

I've already implemented some kind of ray tracing engine while trying to render parametric surfaces like biquadratic Bezier patches ([source code](https://github.com/agerasev/cltracer), [demo](https://youtu.be/Fz5wcgmms_Q)). It is written in C++ and OpenCL and is quite fast - it renders a scene of sufficient quality in real-time because it runs on GPU (around 100 samples per pixel per second for 800x600 pixels on GTX 970). Here is the video rendered by it:

{% include youtube_player.html id="Fz5wcgmms_Q" %}

But this ray tracing engine is very specialized for its current task and it would be quite painful to adapt it for a new one.

So I decided to implement a new ray tracing engine with GPGPU support using fresh new tools and taking previous mistakes into account. 

## The new ray tracer

This time I'm focusing on modularity and extendability of the project to make it possible to re-use it in different applications.

I've decided to use [Rust programming language](https://www.rust-lang.org/) for the host part of the project because it is as fast as C/C++ but much more reliable at the same time. It has strict but flexible type system with compile-time checks and such system allows to implement modularity in convenient and reliable way. Also Rust has friendly community and rich ecosystem of useful tools and libraries.

I continue to use [OpenCL](https://www.khronos.org/opencl/) for implementing the device part because it is the one of the most popular frameworks for GPGPU programming and has the widest range of supported devices (unlike CUDA).

The name **Clay** is chosen due to self-named material which is plastic and able to take any desired form during fabrication but becomes hard and reliable after the production is complete. Also this name could be considered as some of the letters from the phrase *"Open**CL** R**ay** tracer"*.

Much more information about project, its principles, architecture and usage could be found on the [main page of the project](https://clay-rs.github.io) and [corresponding](https://clay-rs.github.io/architecture) [subsections](https://clay-rs.github.io/usage).

The project lives on Github in [Clay-rs](https://github.com/clay-rs) organization. All its components are licensed under dual *MIT/Apache-2.0* license, so you can freely use, modufy and redistribute the program even for commercial purposes.

## Results

For now the minimal skeleton of the project is almost complete, but it could be changed and extended in future releases. And there are only very limited set of implementations of shapes, materials, etc. for the moment, but it should and will be extended in future.

There are also a small set of examples to demonstrating current capabilities of the engine. You can find them [here](https://clay-rs.github.io/usage/#examples).

### Rendered images

Some objects illuminated by two light sources:

![](https://clay-rs.github.io/gallery/posts/001/scene.jpg)

### Logarithmic correction
{:.no_toc}

Some scenes could contain places with very different illumination levels. To draw both very dark and very bright objects on the same image it is reasonable to use logarithmic scale.

Linear scale:
![](https://clay-rs.github.io/gallery/posts/001/log_filter/without.jpg)

Logarithmic scale:
![](https://clay-rs.github.io/gallery/posts/001/log_filter/with.jpg)

Also note that wide logarithmic range cause colors to become gray and you may need to increase color contrast in such case.

### Global illumination
{:.no_toc}

One of the main advantages of ray tracing is the ability to account diffused light so objects could be illuminated not only directly by light source but also by secondary rays from other illuminated objects.

![](https://clay-rs.github.io/gallery/posts/001/room_01.jpg)

![](https://clay-rs.github.io/gallery/posts/001/room_02.jpg)

Note that these images are rendered without logarithmic correction to show difference in brightness more clearly.

### Statistics accumulation
{:.no_toc}

If you draw static scene and don't move the camera the Monte-Carlo statistics will be accumulated gradually increasing the image quality.

200 milliseconds of rendering:
![](https://clay-rs.github.io/gallery/posts/001/progress/01.jpg)

2 seconds:
![](https://clay-rs.github.io/gallery/posts/001/progress/02.jpg)

20 seconds:
![](https://clay-rs.github.io/gallery/posts/001/progress/03.jpg)

3 minutes 20 seconds:
![](https://clay-rs.github.io/gallery/posts/001/progress/04.jpg)

About 30 minutes:
![](https://clay-rs.github.io/gallery/posts/001/progress/05.jpg)

These images are rendered on GeForce GTX 970, times could differ for different hardware.

### Benchmarking

In the following table the platforms where I've tried to run Clay are listed along with their relative performance. Performance was measured for relatively heavy `05_indirect_lighting` example at initial position of camera and the viewport size was `800x600`. Performance is represented in last column as *number of samples per pixel per second* (the value printed by `FrameCounter` as `FPS`).

| Platform             | Device               | OS      | SPPPS    |
|----------------------|----------------------|---------|----------|
| AMD APP              | Radeon RX 570        | Windows | **91**   |
| NVIDIA CUDA          | GeForce GTX 970      | Linux   | **64**   |
| NVIDIA CUDA          | GeForce 840M         | Windows | **12**   |
| Intel OpenCL         | HD Graphics 4400     | Windows | **10**   |
| POCL                 | Intel Core i7-2600K  | Linux   | **0.45** |

`05_indirect_lighting` example renders simple interior of the room illuminated by secondary rays. To trace sufficient number of paths to simulate global illumination the maximum number of ray bounces is set to **8**. We may estimate the average number of actual bounces per sample to be **6.2** considering importance sampling probability and that almost all rays stay in such closed space until the end. That means that about **190 millions** of rays are simulated per second on GTX 970, and about **270 millions** - on RX 570.

## Contribution

Contributions are extremely welcome. The project is designed to be very powerful, but for now it contains only basic functionality, so there is a lot of things to implement.

Here is the possible directions of work:

+ *New shapes, materials, etc.* - there are only basic primitives like ellipse and parallelepiped added for testing purposes, but it is possible to add various types of objects like composite objects (made of polygons, for example), scalar function for ray marching, some objects for volumetric rendering and many others.
+ *New techniques of raytracing* - for now there is only basic backward ray propagation technique implemented with some improvement in importance sampling. But it would be great to implement some advanced techniques like bidirectional ray tracing, Metropolis light transport, photon maps and other ones.
+ *Tests and debugging* - the project lacks of testing a lot. Tests should be added to check current functionality and avoid regression in the future, as well as testing new features.
+ *Optimization and benchmarking* - there are a lot of unoptimized performance-critical code and it would be great if someone more experienced in GPU programming reviewed device-side code.
+ *Documentation* - it would be nice to add more user-friendly documentation, examples and tutorials.
+ *Project architecture* - some ideas of extending or improving core structure to make the project more suitable for some new functionality or fix some flaws may be discussed and implemented.

## Conclusion

It was an interesting and informative experience for me. I practiced a lot of of Rust, GPGPU programming in OpenCL, and ray tracing techniques. Also this activity was demanded on me to recall some mathematical background like linear algebra, calculus, probability theory and computational mathematics including Monte-Carlo methods. And what is the most important now I've got a convenient ray tracing framework to experiment with and extend it in the future and I would be very glad if it was helpful for someone else.

If you have some questions, suggestion, ideas or something else you can freely reach me out via links in the page footer.

Thank you for reading this article!
