precision highp float;
//纹理采样器
uniform sampler2D Texture;
//纹理坐标
varying vec2 TextureCoordsVarying;
//时间撮
uniform float Time;
//PI 常量 7
const float PI = 3.1415926;

//⼀次幻觉滤镜的时⻓
const float duration = 2.0;

//这个函数可以计算出，在某个时刻图⽚的具体位置。通过它我们可以每经过⼀段时间，去⽣成⼀个新的 层
vec4 getMask(float time, vec2 textureCoords, float padding) {
    //圆周坐标
    vec2 translation = vec2(sin(time * (PI * 2.0 / duration)), cos(time * (PI * 2.0 / duration)));
    //纹理坐标 = 纹理坐标+偏离量 * 圆周坐标
    vec2 translationTextureCoords = textureCoords + padding * translation;
    //根据这个坐标获取新图层的坐标
    vec4 mask = texture2D(Texture, translationTextureCoords);
    return mask;
}

//这个函数可以计算出，某个时刻创建的层，在当前时刻的透明度。
float maskAlphaProgress(float currentTime, float hideTime, float startTime) { //duration+currentTime-startTime % duration
    float time = mod(duration + currentTime - startTime, duration);
    return min(time, hideTime);
    
}

void main (void) {
        
    //表示将传⼊的时间转换到⼀个周期内，即 time 的范围是 0 ~ 2.0
    float time = mod(Time, duration);
    //放⼤倍数
    float scale = 1.2;
    //偏移量
    float padding = 0.5 * (1.0 - 1.0 / scale);
    //放⼤后的纹理坐标
    vec2 textureCoords = vec2(0.5, 0.5) + (TextureCoordsVarying - vec2(0.5, 0.5)) / scale; 8

    //隐藏时间
    float hideTime = 0.9;
    //时间间隔
    float timeGap = 0.2;
    //注意: 只保留了红⾊的透明的通道值,因为幻觉效果残留红⾊.
    //新图层的-R⾊透明度 0.5
    float maxAlphaR = 0.5;
    // max R
    //新图层的-G⾊透明度 0.05
    float maxAlphaG = 0.05;
    // max G
    //新图层的-B⾊透明度 0.05
    float maxAlphaB = 0.05;
    // max B
    //获得新的图层坐标!
    vec4 mask = getMask(time, textureCoords, padding);
    float alphaR = 1.0;
    // R
    float alphaG = 1.0;
    // G
    float alphaB = 1.0;
    // B
    //最终图层颜⾊
    vec4 resultMask = vec4(0, 0, 0, 0);
    //循环
    for (float f = 0.0; f < duration; f += timeGap) {
        float tmpTime = f;
        //获取到0-2.0秒内所获取的运动后的纹理坐标
        vec4 tmpMask = getMask(tmpTime, textureCoords, padding);
        
        //某个时刻创建的层，在当前时刻的红绿蓝的透明度
        float tmpAlphaR = maxAlphaR - maxAlphaR * maskAlphaProgress(time, hideTime, tmpTime) / hideTime; float tmpAlphaG = maxAlphaG - maxAlphaG * maskAlphaProgress(time, hideTime, tmpTime) / hideTime; float tmpAlphaB = maxAlphaB - maxAlphaB * maskAlphaProgress(time, hideTime, tmpTime) / hideTime;
        //累积每⼀层每个通道乘以透明度颜⾊通道
        resultMask += vec4(tmpMask.r * tmpAlphaR, tmpMask.g * tmpAlphaG, tmpMask.b * tmpAlphaB, 1.0);
        //透明度递减
        alphaR -= tmpAlphaR;
        alphaG -= tmpAlphaG;
        alphaB -= tmpAlphaB;
        
    }
    //最终颜⾊ += 红绿蓝 * 透明度
    resultMask += vec4(mask.r * alphaR, mask.g * alphaG, mask.b * alphaB, 1.0);
    //将最终颜⾊填充到像素点⾥.
    gl_FragColor = resultMask;
    
}
