precision highp float;
//纹理采样器
uniform sampler2D Texture;
//纹理采样器
varying vec2 TextureCoordsVarying;
//时间撮
uniform float Time; void main (void) {
    
    //⼀次抖动滤镜的时⻓
    float duration = 0.7;
    
    //放⼤图⽚上限
    float maxScale = 1.1;
    
    //颜⾊偏移步⻓
    float offset = 0.02;
    
    //进度 0~1
    float progress = mod(Time, duration) / duration;
    // 0~1 //颜⾊偏移值(0-0.02)
    vec2 offsetCoords = vec2(offset, offset) * progress;
    //缩放⽐例(1.0 - 1.1)
    float scale = 1.0 + (maxScale - 1.0) * progress; 4

    //放⼤后的纹理坐标
    vec2 ScaleTextureCoords = vec2(0.5, 0.5) + (TextureCoordsVarying - vec2(0.5, 0.5)) / scale;
    
    //获取3组颜⾊ //原始颜⾊ + offsetCoords
    vec4 maskR = texture2D(Texture, ScaleTextureCoords + offsetCoords);
    //原始颜⾊ - offsetCoords
    vec4 maskB = texture2D(Texture, ScaleTextureCoords - offsetCoords);
    //原始颜⾊
    vec4 mask = texture2D(Texture, ScaleTextureCoords);
    
    //从3组颜⾊中分别取出: 红⾊R,绿⾊G,蓝⾊B,透明度A填充到⽚元着⾊器内置变量gl_FragColor内.
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a); }
