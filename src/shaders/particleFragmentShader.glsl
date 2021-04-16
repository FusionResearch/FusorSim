
varying vec4 vColor;

void main() {

  // this makes a round circle
  float f = length(gl_PointCoord - vec2(0.5, 0.5));
  if (f > 0.5) {
    discard;
  }
  //try using alpha channel, not working?
  gl_FragColor = vec4(vColor.xyz, 0.01);
}
