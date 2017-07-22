# Adapter
Class helping to build flexible, adaptive iOS interfaces with extrimely easy API:

<br>

<img src="https://raw.githubusercontent.com/antiflasher/Adapter/master/illustration_main%402x.png" title="Adapter">

Why? Sometimes UI designers need to adjust size or text to a particular screen size, like adaptive design in the web.

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

## Usage

### 1. Scaled value from the list of explisit break points

1.1 **Create a `Dictionary` of break points**

Add only screen widths you care about: `[w320: 80, w375: 100, w414: 120]`. 

Use `.default`to set a default value for screen widths you haven't specified: `[w320.default: 80, w375: 100, w414: 120]`. 

Also, you can use `wAny` to set a default value: `[wAny: 50, w414: 100]`.


1.2 **Get a value for particular screen width**

Simply add `.scaled` to a dictionary: `[w320.default: 80, w375: 100, w414: 120].scaled`.

If you gave list of `Int`, `Float`, `Double` of `CGFloat` values, a `CGFloat` value will be returned – in order to use it directly as font size, constrint constant and other interface tweeking.

If you haven't set the default value, well the first dictionary value will be used, which is almost arbitrary value, you know :)
Comflicts are solved towards more specific instruction. []
