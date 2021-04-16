// For PI declaration:
#include <common>

uniform sampler2D texturePosition;
uniform sampler2D textureVelocity;

uniform float cameraConstant;
uniform float density;

varying vec4 vColor;


// extract mass from fractional part of float
float getMass(vec4 tmpVel) {
  return fract(abs(tmpVel.w))*10.0;
}

// extract charge from whole part of float
float getCharge(vec4 tmpVel) {
  return trunc(tmpVel.w);
}



void main() {

  vec4 posTemp = texture2D(texturePosition, uv);
  vec3 pos = posTemp.xyz;

  vec4 velTemp = texture2D(textureVelocity, uv);
  vec3 vel = velTemp.xyz;
   //  charge is held before decimal point,  mass is held after 
  float mass = getMass(velTemp); 
  float charge = getCharge(velTemp);


  // neutrons are white
  vColor = vec4(1.0, 1.0, 1.0, 1.0);

  if(charge < -0.1)
  {
    //electrons are blue
    vColor = vec4(0.0, 0.0, 1.0, 1.0);
  }
  if(charge > 0.1)
  {
    //positve ions  are red
    vColor = vec4(1.0, 0.0, 0.0, 1.0);
  }

  vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);

  // draw more massive particles bigger
  float radius = clamp(10.0 * mass,0.5,0.99);

  // Apparent size in pixels
  if (mass == 0.0) {
    gl_PointSize = 0.0;
  } else {
    gl_PointSize = radius * cameraConstant / (-mvPosition.z);
  }

  gl_Position = projectionMatrix * mvPosition;
}