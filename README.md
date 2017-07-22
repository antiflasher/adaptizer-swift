# Adapter.swift
Class helping to build flexible, adaptive iOS interfaces with extremely easy API:

<br>

<img src="https://raw.githubusercontent.com/antiflasher/Adapter/master/illustration_main%402x.png" title="Adapter">

Why? Sometimes UI designers need to adjust size or text to a particular screen size, like the adaptive design on the web.

The big picture of various screen sizes:

<img width="758" height="575" src="https://raw.githubusercontent.com/antiflasher/Adapter/master/illustration_sizes%402x.png" title="Screen Sizes">

All screen width in points:

```
// w320  >  wC  iPhone  iPad
// w375  >  wC  iPhone  iPad
// w414  >  wC  iPhone
// w438  >  wC          iPad
// w507  >  wC          iPad
// w568  >  wC  iPhone
// w639  >  wC          iPad
// w667  >  wC  iPhone
// -------------------------
// w678  >  wR          iPad
// w694  >  wR          iPad
// w736  >  wR  iPhone
// w768  >  wR          iPad
// w981  >  wR          iPad
// w1024 >  wR          iPad
// w1366 >  wR          iPad
```

Adapter supports three ways to refer a particular screen size:
1. Exact screen width in points: `w320`, `w375`, `w414` and so on, regardless of the device type
2. SizeClass + Device type: `wC.phone`, `wR.pad`
3. SizeClass, regardless of the device type: `wC.all`, `wR.all`

<br>

## Installation

<br>

## Usage

### 1. Scaled value from the list of explicit break points

You can give a list of exact values for various screen width, and Adapter returns one for the current screen.

<br>

**1.1 Create a `Dictionary` of break points**

Add only screen widths you care about: `[w320: 80, w375: 100, w414: 120]`.

`Keys` are in `ScreenIdentifier` type. All of them starts with `w`. `Values` – any you want to scale: `CGFloat/Float/Double/Int` for font sizes, constraints constant and so on; `String` for adjusting text; `Bool`for hiding elements and so on.

Use `.default`to set a default value for screen widths you haven't specified: `[w320.default: 80, w375: 100, w414: 120]`. 

Also, you can use `wAny` to set a default value: `[wAny: 50, w414: 100]`.

If you haven't set the default value in your dictionary, well the first dictionary value is used, which is almost arbitrary value, you know :)

<br>

**1.2 Get a value for particular screen width**

Simply add `.scaled` to a dictionary: `[w320.default: 80, w375: 100, w414: 120].scaled`.

If you gave a list of `Int`, `Float`, `Double` of `CGFloat` values, a `CGFloat` value is returned – for you to use it directly as font size, constraint constant and other interface tweakings without type conversion. If you gave a list of other value types, the result is of the same type.

Conflicts are solved towards more specific instruction. F.x. you set `[w320: 80, wC.phone: 100, wC.all: 120]`. For screen width of 320 points, all three instructions applicable, but `w320` is the only one exact, so it is used, the others are ignored. For screen width of 375 points on an iPhone, second and third instructions are applicable, but `wC.phone` is more specific instruction, so it is used.

<br>
<br>

### 2. Scaled value by using original value and multipliers

You can give a list of multipliers to adjust one provided original value to various screen width.

<br>

**2.1 Create a `Dictionary` of break points**

A dictionary is created the very same way as described in `1.1`. The only one difference is that the `values` are not exact values, but multipliers of `Double` type.

<br>

**2.2 Set `scalingRule`**

This dictionary of multipliers is used as a scaling rule. To set the rule, add `.scalingRule()` to the dictionary: `[w320: 0.8, w375: 1.0, w414: 1.2].scalingRule()`

<br>

**2.3 Scale an original value**

Add `.scaled` to a value of `Int`, `Float`, `Double` of `CGFloat` type: `20.scaled`. As the result, a value in `CGFloat`is returned.

To keep pixel-perfect, the result is rounded by default. If you don't want the result to be rounded, say it be setting the rule: `.scalingRule(rounding: false)`

<br>

## Thanks to

<a href="https://evilmartians.com/?utm_source=adapter">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>
