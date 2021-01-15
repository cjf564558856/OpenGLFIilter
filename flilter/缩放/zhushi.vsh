//顶点坐标
attribute vec4 Position;
//纹理坐标
attribute vec2 TextureCoords;
//纹理坐标
varying vec2 TextureCoordsVarying;

//时间撮(及时更新)
uniform float Time;

//PI
const float PI = 3.1415926;

void main (void) {
    //⼀次缩放效果时⻓ = 0.6ms
    float duration = 0.6;
    //最⼤缩放幅度
    float maxAmplitude = 0.3;
    //表示传⼊的时间周期.即time的范围被控制在[0.0~0.6];
    //mod(a,b),求模运算. a%b
    float time = mod(Time, duration);
    //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 1.0 ~ 1.3 之间，并随着时间变化
    float amplitude = 1.0 + maxAmplitude * abs(sin(time * (PI / duration)));
    //放⼤关键: 将顶点坐标的 x 和 y 分别乘上⼀个放⼤系数，在纹理坐标不变的情况下，就达到了拉伸的 效果。//x,y 放⼤; z和w保存不变
    gl_Position = vec4(Position.x * amplitude, Position.y * amplitude, Position.zw); ////纹理坐标传递给TextureCoordsVarying
    TextureCoordsVarying = TextureCoords;
