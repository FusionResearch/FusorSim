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
  float mass = tmpVel.w;
  if (mass > 0.0) {

    // placeholder for all forces acting on particle
    vec3 acceleration = vec3(0.0);

    // Gravity interaction
    for (float y = 0.0; y < height; y++) {

      for (float x = 0.0; x < width; x++) {

        vec2 secondParticleCoords = vec2(x + 0.5, y + 0.5) / resolution.xy;
        vec3 pos2 = texture2D(texturePosition, secondParticleCoords).xyz;
        vec4 velTemp2 = texture2D(textureVelocity, secondParticleCoords);
        vec3 vel2 = velTemp2.xyz;
        float mass2 = velTemp2.w;

        float idParticle2 =
            secondParticleCoords.y * resolution.x + secondParticleCoords.x;

        if (idParticle == idParticle2) {
          continue;
        }

        if (mass2 == 0.0) {
          continue;
        }

        vec3 dPos = pos2 - pos;
        float distance = length(dPos);

        if (distance == 0.0) {
          continue;
        }

        // Checks collision

        if (distance < 0.0) {

          if (idParticle < idParticle2) {

            // This particle is aggregated by the other
            // vel = ( vel * mass + vel2 * mass2 ) / ( mass + mass2 );
            // mass += mass2;
            // radius = radiusFromMass( mass );

          } else {

            // This particle dies
            // mass = 0.0;
            // radius = 0.0;
            // vel = vec3( 0.0 );
            break;
          }
        }

        float distanceSq = distance * distance;

        float gravityField = ion_repulsion * mass2 / distanceSq;

        gravityField = min(gravityField, 1000.0);

        acceleration -= gravityField * normalize(dPos);
      }

      if (mass == 0.0) {
        break;
      }
    }

    // Dynamics
    //electric field
    acceleration -= vec3(0.0, pos.y * e_field_per_cm * delta, 0.0);
    vel += delta * acceleration;
    //magnetic field rotates velocity vector
    vel = vec3(cos(b_field*delta)*vel.x - sin(b_field*delta)*vel.z , vel.y, sin(b_field*delta)*vel.x + cos(b_field*delta)*vel.z);
  }

  gl_FragColor = vec4(vel, mass);
}
