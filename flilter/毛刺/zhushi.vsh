precision highp float;
//纹理采样器
uniform sampler2D Texture;
//纹理坐标
varying vec2 TextureCoordsVarying;
//时间撮
uniform float Time;
//PI 常量
const float PI = 3.1415926;
//随机数
float rand(float n) {
    //fract(x),返回x的⼩数部分 //返回:sin(n) * 43758.5453123
    return fract(sin(n) * 43758.5453123);
    
}

void main (void) {
    //最⼤抖动
    float maxJitter = 0.06;
    //⼀次⽑刺滤镜的时⻓
    float duration = 0.3;
    //红⾊颜⾊偏移
    float colorROffset = 0.01;
    //绿⾊颜⾊偏移
    float colorBOffset = -0.025; 6
    
    //表示将传⼊的时间转换到⼀个周期内，即 time 的范围是 0 ~ 0.6 float time = mod(Time, duration * 2.0); //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 1.0 ~ 1.3 之间，并随着时间变化
    float amplitude = max(sin(time * (PI / duration)), 0.0);
    
    // -1~1 像素随机偏移范围(-1,1)
    float jitter = rand(TextureCoordsVarying.y) * 2.0 - 1.0;
    
    // -1~1 //判断是否需要偏移,如果jtter范围< 最⼤抖动*振幅
    bool needOffset = abs(jitter) < maxJitter * amplitude;
    
    //获取纹理x 坐标,根据needOffset,来计算它的X撕裂,如果是needOffset = yes 则撕裂⼤;如果 needOffset = no 则撕裂⼩;
    float textureX = TextureCoordsVarying.x + (needOffset ? jitter : (jitter * amplitude * 0.006));
    
    //获取纹理撕裂后的x,y坐标
    vec2 textureCoords = vec2(textureX, TextureCoordsVarying.y);
    
    //颜⾊偏移 //获取3组颜⾊: 根据撕裂计算后的纹理坐标,获取纹素的颜⾊
    vec4 mask = texture2D(Texture, textureCoords);
    
    //获取3组颜⾊: 根据撕裂计算后的纹理坐标,获取纹素的颜⾊
    vec4 maskR = texture2D(Texture, textureCoords + vec2(colorROffset * amplitude, 0.0));
    
    //获取3组颜⾊: 根据撕裂技术后的纹理坐标,获取纹素颜⾊
    vec4 maskB = texture2D(Texture, textureCoords + vec2(colorBOffset * amplitude, 0.0));
    
    //颜⾊主要撕裂: 红⾊和蓝⾊部分.所以只调整红⾊
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a); }
