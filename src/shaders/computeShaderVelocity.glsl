// generate the forces on each particle due to the device and other particles
// For PI declaration:
#include <common>

#define delta (1.0 / 60.0)

uniform float ion_repulsion;
uniform float density;
uniform float b_field;
uniform float e_field_per_cm;

const float width = resolution.x;
const float height = resolution.y;


float trunc(float x) {
  if (x >= 0.0) {
    return floor(x); 
  } else {
    return ceil(x);
  }
}

// extract mass from fractional part of float
float getMass(vec4 tmpVel) {
  return fract(abs(tmpVel.w))*10.0;
}

// extract charge from whole part of float
float getCharge(vec4 tmpVel) {
  return trunc(tmpVel.w);
}

float encodeChargeMass(float charge, float mass)
{
   return charge + ((mass/10.0)*sign(charge)); 
}



void main() {
  // get our particle information
  vec2 uv = gl_FragCoord.xy / resolution.xy;
  // generate unique particle id from position in the texture
  float idParticle = uv.y * resolution.x + uv.x;

  // get the particle position from texture color data
  vec4 tmpPos = texture2D(texturePosition, uv);
  vec3 pos = tmpPos.xyz;

  // get particle velocity data from texture color data
  vec4 tmpVel = texture2D(textureVelocity, uv);
  vec3 vel = tmpVel.xyz;
  float mass = getMass(tmpVel);
  float charge = getCharge(tmpVel);
  if (mass > 0.0) {

    // placeholder for all forces acting on particle
    vec3 acceleration = vec3(0.0);

    // Charge interaction
    for (float y = 0.0; y < height; y++) {

      for (float x = 0.0; x < width; x++) {

        vec2 secondParticleCoords = vec2(x + 0.5, y + 0.5) / resolution.xy;
        vec3 pos2 = texture2D(texturePosition, secondParticleCoords).xyz;
        vec4 velTemp2 = texture2D(textureVelocity, secondParticleCoords);
        vec3 vel2 = velTemp2.xyz;
        float charge2 = trunc(tmpVel.w);

        float idParticle2 =
            secondParticleCoords.y * resolution.x + secondParticleCoords.x;

        if (idParticle == idParticle2) {
          continue;
        }

        if (charge2 == 0.0) {
          continue;
        }

        vec3 dPos = pos2 - pos;
        float distance = length(dPos);

        if (distance == 0.0) {
          continue;
        }

        // Checks collision/ fusion
        if (distance < 0.01) {

          if (idParticle > idParticle2) {
            // This particle fuses with the other
            //vel = vec3( y,x,y+x );
            mass = 0.2; 
            charge = 0.0;

          } else {
            // This particle dies
            mass = 0.0;
            charge = 0.0;
            vel = vec3( 0.0 );
            break;
          }
        }

        float distanceSq = distance * distance;

        float chargeField = ion_repulsion * charge2 / distanceSq;

        chargeField = min(chargeField, 1000.0);

        acceleration -= chargeField * normalize(dPos);
      }

      if (mass == 0.0) {
        break;
      }
    }

    // Dynamics
    // static electric field from end electrodes ?
    acceleration -= vec3(0.0, pos.y * e_field_per_cm * delta /mass, 0.0);
    vel += delta * acceleration;

    //magnetic field rotates velocity vector
    vel = vec3(cos(b_field*delta)*vel.x - sin(b_field*delta)*vel.z , vel.y, sin(b_field*delta)*vel.x + cos(b_field*delta)*vel.z);
  }

  gl_FragColor = vec4(vel, encodeChargeMass(charge,mass));
}
