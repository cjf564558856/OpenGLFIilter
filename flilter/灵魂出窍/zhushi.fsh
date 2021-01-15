precision highp float;

uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

uniform float Time;

void main (void) {
    //一次灵魂出窍时长
    float duration = 0.7;
    //透明度上限
    float maxAlpha = 0.4;
    //图片放大上限
    float maxScale = 1.8;
    
    //进度【0-1】
    float progress = mod(Time, duration) / duration; // 0~1
    //透明度【0.4，0】
    float alpha = maxAlpha * (1.0 - progress);
    //缩放比例【1.8，1.0】
    float scale = 1.0 + (maxScale - 1.0) * progress;
    
    //放大纹理坐标
    float weakX = 0.5 + (TextureCoordsVarying.x - 0.5) / scale;
    float weakY = 0.5 + (TextureCoordsVarying.y - 0.5) / scale;
    
    //坐标
    vec2 weakTextureCoords = vec2(weakX, weakY);
    
    //当前像素点纹理坐标 和 放大后的纹理坐标
    vec4 weakMask = texture2D(Texture, weakTextureCoords);
    vec4 mask = texture2D(Texture, TextureCoordsVarying);
    
    //混合方程式
    gl_FragColor = mask * (1.0 - alpha) + weakMask * alpha;
}

