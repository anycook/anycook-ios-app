precision mediump float;

uniform sampler2D s_texture;

varying vec2 v_texCoord;

void main()
{
    gl_FragColor = texture2D(s_texture, v_texCoord);
    
    // contrast
    float contrast = 1.5;
    vec4 texcolor = gl_FragColor;
    vec3 contrasted = (texcolor.rbg - 0.5) * contrast + 0.5;
    gl_FragColor = vec4(contrasted[0], contrasted[2], contrasted[1],texcolor.a);
    
    
    // burn
    float distance = distance(v_texCoord, vec2(0.5, 0.5));
    //float factor = 1.0/ (distance+1.0);
    float factor = smoothstep(0.8, 0.25, distance);
    gl_FragColor = gl_FragColor * factor;
   
}
