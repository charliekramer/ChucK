//hydra share screen + osc
s0.initScreen()
src(s0).out(o1)
osc(20).diff(o1).out(o2)
render(o2)


shape(40,.1,.9)
.add(
gradient()
.invert()
.color(0.9,0,1)
)
.saturate(({time})=>Math.sin(time))
.out(o0)

render()


shape(40,.1,.9)
.add(
gradient()
.invert()
.color(0.9,0,1)
)
.saturate(({time})=>Math.sin(time))
.colorama()
.out(o0)

shape()
.repeat(10,10)
.rotate(({time})=>Math.PI*time/100000)
.out(o1)

src(o1).out(o2)

src(o0)
.mult(o1)
.out(o3)

render()

/////////

s0.initCam()

src(s0)
.invert()
.thresh()
.out(o0)

gradient()
.invert()
.mult(o0)
.modulate(
  noise(2)
  )
.out(o1)
.add(
  noise(900,100)
  )
.out(o1)

render(o1)