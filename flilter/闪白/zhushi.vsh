precision highp float;
//纹理采样器
uniform sampler2D Texture;
//纹理坐标
varying vec2 TextureCoordsVarying;
//时间撮 uniform
float Time;
//PI 常量
const float PI = 3.1415926;

void main (void) {
    //⼀次闪⽩滤镜的时⻓
    float duration = 0.6;
    //表示将传⼊的时间转换到⼀个周期内，即 time 的范围是 0 ~ 0.6
    float time = mod(Time, duration);
    //⽩⾊颜⾊遮罩
    vec4 whiteMask = vec4(1.0, 1.0, 1.0, 1.0);
    
    //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 0.0 ~ 1.0 之间，并随着时间变化 5
    float amplitude = abs(sin(time * (PI / duration)));
    
    //获取纹理坐标对应的纹素颜⾊值
    vec4 mask = texture2D(Texture, TextureCoordsVarying);
    
    //利⽤混合⽅程式: 将纹理颜⾊与⽩⾊遮罩融合. //注意: ⽩⾊遮罩的透明度会随着时间变化做调整 //我们已经知道了如何实现两个层的叠加.当前的透明度来计算最终的颜⾊值即可。
    gl_FragColor = mask * (1.0 - amplitude) + whiteMask * amplitude; }
