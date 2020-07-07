precision highp int;
precision highp float;
uniform mat4 u_projectionMatrix;
uniform mat4 u_offsetScaleMatrix;
uniform mat4 u_offsetRotateMatrix;

uniform mat4 u_projAMatrix;
uniform mat4 u_projBMatrix;
uniform mat4 u_projTransform;
uniform mat4 u_renderTransform;
uniform mat4 u_invertProjTransform;
uniform vec2 u_eyepos;
uniform vec2 u_eyeposlow;
attribute vec2 a_position;
attribute float a_index;
attribute float a_size;
{{init}}
varying vec2 v_texCoord;
varying float v_size;

void main(void) {
  {{main}}

  mat4 offsetMatrix = u_offsetScaleMatrix;
  float size = a_size;
  if (a_iscircle == 0.){
      mat4 rotateMatrix = mat4(
              vec4(a_cosangle, -a_sinangle, 0., 0.),
              vec4(a_sinangle, a_cosangle, 0., 0.),
              vec4(0.),
              vec4(0.)
              );
      offsetMatrix *= rotateMatrix*u_offsetRotateMatrix;
  } else {
      size /= 3.;
  }

  float offsetX = a_index == 0.0 || a_index == 3.0 ? -size / 2.0 : size / 2.0;
  float offsetY = a_index == 0.0 || a_index == 1.0 ? -size / 2.0 : size / 2.0;
  vec4 offsets = offsetMatrix * vec4(offsetX, offsetY, 0.0, 0.0);
  //vec4 outPosition = u_projTransform * vec4(a_position,0.,1.);
  //outPosition = (u_projTransform * u_invertProjTransform) * outPosition;
  //vec4 outPosition = u_projTransform * vec4(a_position, 0., 1.);
  //
  //vec4 position = vec4(a_position, 0., 1.);
  //mat4 projAMatrix = u_projAMatrix;
  //mat4 projBMatrix = u_projBMatrix;
  //projAMatrix[3][3] = 1.;
  //projBMatrix[3][3] = pow(10., -6.);
  //vec4 outPosition = projAMatrix * position + projBMatrix * position;
  //vec4 outPosition = u_projAMatrix * position;
  //vec4 outPosition = u_renderTransform * vec4(a_position, 0., 1.);
  //outPosition = u_projectionMatrix * outPosition;

  vec2 p = a_position - u_eyepos;
  p -= u_eyeposlow;
  vec4 outPosition = u_projTransform * vec4(p, 0., 1.);
  gl_Position = outPosition + offsets;
  float u = a_index == 0.0 || a_index == 3.0 ? 0.0 : 1.0;
  float v = a_index == 0.0 || a_index == 1.0 ? 0.0 : 1.0;
  v_texCoord = vec2(u, v);
  v_size = size;
}
