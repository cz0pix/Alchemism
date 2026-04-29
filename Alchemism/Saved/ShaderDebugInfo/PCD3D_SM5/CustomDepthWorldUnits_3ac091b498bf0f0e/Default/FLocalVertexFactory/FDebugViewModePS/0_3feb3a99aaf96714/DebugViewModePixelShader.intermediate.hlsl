#pragma warning(disable : 3571) // pow() intrinsic suggested to be used with abs()
cbuffer View
{
    float4 View_View_InvDeviceZToWorldZTransform : packoffset(c78);
};

cbuffer InstancedView
{
    row_major float4x4 InstancedView_InstancedView_SVPositionToTranslatedWorld[2] : packoffset(c88);
    row_major float4x4 InstancedView_InstancedView_ScreenToRelativeWorld[2] : packoffset(c96);
    float4 InstancedView_InstancedView_ViewOriginHigh[2] : packoffset(c144);
    float4 InstancedView_InstancedView_ViewRectMin[2] : packoffset(c297);
    float4 InstancedView_InstancedView_ViewSizeAndInvSize : packoffset(c299);
};

cbuffer DebugViewModePass
{
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[5] : packoffset(c7);
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[8] : packoffset(c12);
};

cbuffer Material
{
    float4 Material_Material_PreshaderBuffer[1] : packoffset(c0);
};

float4 CPUTexelFactor;
float4 NormalizedComplexity;
int2 AnalysisParams;
float PrimitiveAlpha;
int TexCoordAnalysisIndex;
float CPULogDistance;
uint bShowQuadOverdraw;
uint bOutputQuadOverdraw;
int LODIndex;
float3 SkinCacheDebugColor;
int VisualizeMode;

RWTexture2D<uint> DebugViewModePass_QuadOverdraw;

static uint gl_PrimitiveID;
static float4 gl_FragCoord;
static float4 in_var_TEXCOORD0;
static float4 in_var_TEXCOORD1;
static float4 in_var_TEXCOORD2;
static float3 in_var_TEXCOORD3;
static float3 in_var_TEXCOORD4;
static float3 in_var_TEXCOORD5;
static uint in_var_VIEW_ID;
static float4 out_var_SV_Target0;

struct SPIRV_Cross_Input
{
    float4 in_var_TEXCOORD0 : TEXCOORD0;
    float4 in_var_TEXCOORD1 : TEXCOORD1;
    float4 in_var_TEXCOORD2 : TEXCOORD2;
    float3 in_var_TEXCOORD3 : TEXCOORD3;
    float3 in_var_TEXCOORD4 : TEXCOORD4;
    float3 in_var_TEXCOORD5 : TEXCOORD5;
    nointerpolation uint in_var_VIEW_ID : VIEW_ID;
    uint gl_PrimitiveID : SV_PrimitiveID;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 out_var_SV_Target0 : SV_Target0;
};

void frag_main()
{
    float4x4 _122 = InstancedView_InstancedView_ScreenToRelativeWorld[in_var_VIEW_ID];
    float3 _128 = float3(InstancedView_InstancedView_ViewOriginHigh[in_var_VIEW_ID].xyz);
    float4 _706 = 0.0f.xxxx;
    [branch]
    if (((((VisualizeMode == 1) || (VisualizeMode == 2)) || (VisualizeMode == 3)) || (VisualizeMode == 4)) || (VisualizeMode == 12))
    {
        float3 _701 = 0.0f.xxx;
        if (bOutputQuadOverdraw != 0u)
        {
            float3 _615 = NormalizedComplexity.xyz;
            float3 _700 = 0.0f.xxx;
            [branch]
            if ((bShowQuadOverdraw != 0u) && (NormalizedComplexity.x > 0.0f))
            {
                uint2 _627 = uint2(gl_FragCoord.xy) / uint2(2u, 2u);
                uint _629 = 0u;
                int _632 = 0;
                _629 = 3u;
                _632 = 0;
                uint _630 = 0u;
                int _633 = 0;
                [loop]
                for (int _634 = 0; _634 < 24; _629 = _630, _632 = _633, _634++)
                {
                    uint _655 = 0u;
                    int _656 = 0;
                    [branch]
                    if (true && (_632 == 1))
                    {
                        uint4 _644 = DebugViewModePass_QuadOverdraw[_627].xxxx;
                        uint _645 = _644.x;
                        bool _648 = ((_645 >> 2u) - 1u) != uint(gl_PrimitiveID);
                        uint _653 = 0u;
                        [flatten]
                        if (_648)
                        {
                            _653 = _629;
                        }
                        else
                        {
                            _653 = _645 & 3u;
                        }
                        _655 = _653;
                        _656 = _648 ? (-1) : _632;
                    }
                    else
                    {
                        _655 = _629;
                        _656 = _632;
                    }
                    int _671 = 0;
                    [branch]
                    if (_656 == 2)
                    {
                        uint4 _661 = DebugViewModePass_QuadOverdraw[_627].xxxx;
                        uint _663 = _661.x & 3u;
                        uint _669 = 0u;
                        int _670 = 0;
                        [branch]
                        if (_663 == _655)
                        {
                            DebugViewModePass_QuadOverdraw[_627] = 0u;
                            _669 = _655;
                            _670 = -1;
                        }
                        else
                        {
                            _669 = _663;
                            _670 = _656;
                        }
                        _630 = _669;
                        _671 = _670;
                    }
                    else
                    {
                        _630 = _655;
                        _671 = _656;
                    }
                    [branch]
                    if (_671 == 0)
                    {
                        uint _678;
                        InterlockedCompareExchange(DebugViewModePass_QuadOverdraw[_627], 0u, (uint(gl_PrimitiveID) + 1u) << 2u, _678);
                        int _687 = 0;
                        [branch]
                        if (((_678 >> 2u) - 1u) == uint(gl_PrimitiveID))
                        {
                            uint _686;
                            InterlockedAdd(DebugViewModePass_QuadOverdraw[_627], 1u, _686);
                            _687 = 1;
                        }
                        else
                        {
                            _687 = (_678 == 0u) ? 2 : _671;
                        }
                        _633 = _687;
                    }
                    else
                    {
                        _633 = _671;
                    }
                }
                [branch]
                if (_632 == 2)
                {
                    DebugViewModePass_QuadOverdraw[_627] = 0u;
                }
                float3 _699 = _615;
                _699.x = NormalizedComplexity.x * (4.0f / float((_632 != (-2)) ? (1u + _629) : 0u));
                _700 = _699;
            }
            else
            {
                _700 = _615;
            }
            _701 = _700;
        }
        else
        {
            _701 = NormalizedComplexity.xyz;
        }
        _706 = float4(_701, 1.0f);
    }
    else
    {
        float4 _603 = 0.0f.xxxx;
        if (VisualizeMode == 5)
        {
            float3 _596 = 0.0f.xxx;
            if (CPULogDistance >= 0.0f)
            {
                float4 _573 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                float _582 = clamp(log2(max(1.0f, length(_573.xyz / _573.w.xxx))) - CPULogDistance, -1.9900000095367431640625f, 1.9900000095367431640625f);
                int _585 = int(floor(_582) + 2.0f);
                _596 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_585].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_585 + 1].xyz, frac(_582).xxx);
            }
            else
            {
                _596 = 0.014999999664723873138427734375f.xxx;
            }
            _603 = float4(_596, PrimitiveAlpha);
        }
        else
        {
            float4 _563 = 0.0f.xxxx;
            if (VisualizeMode == 6)
            {
                float3 _556 = 0.0f.xxx;
                if (TexCoordAnalysisIndex >= 0)
                {
                    bool _476 = false;
                    float _493 = 0.0f;
                    do
                    {
                        _476 = TexCoordAnalysisIndex == 0;
                        [flatten]
                        if (_476)
                        {
                            _493 = CPUTexelFactor.x;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 1)
                        {
                            _493 = CPUTexelFactor.y;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 2)
                        {
                            _493 = CPUTexelFactor.z;
                            break;
                        }
                        _493 = CPUTexelFactor.w;
                        break;
                    } while(false);
                    float3 _555 = 0.0f.xxx;
                    if (_493 > 0.0f)
                    {
                        float4 _501 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                        float3 _505 = _501.xyz / _501.w.xxx;
                        float2 _520 = 0.0f.xx;
                        do
                        {
                            [flatten]
                            if (_476)
                            {
                                _520 = in_var_TEXCOORD1.xy;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 1)
                            {
                                _520 = in_var_TEXCOORD1.zw;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 2)
                            {
                                _520 = in_var_TEXCOORD2.xy;
                                break;
                            }
                            _520 = in_var_TEXCOORD2.zw;
                            break;
                        } while(false);
                        float2 _521 = ddx_fine(_520);
                        float2 _522 = ddy_fine(_520);
                        float _541 = clamp(log2(_493) - log2(sqrt(length(cross(ddx_fine(_505), ddy_fine(_505))) / max(abs(mad(_521.x, _522.y, -(_521.y * _522.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        int _544 = int(floor(_541) + 2.0f);
                        _555 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_544].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_544 + 1].xyz, frac(_541).xxx);
                    }
                    else
                    {
                        _555 = 0.014999999664723873138427734375f.xxx;
                    }
                    _556 = _555;
                }
                else
                {
                    float _326 = 0.0f;
                    float _327 = 0.0f;
                    if (CPUTexelFactor.x > 0.0f)
                    {
                        float4 _297 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                        float3 _301 = _297.xyz / _297.w.xxx;
                        float2 _303 = ddx_fine(in_var_TEXCOORD1.xy);
                        float2 _304 = ddy_fine(in_var_TEXCOORD1.xy);
                        float _323 = clamp(log2(CPUTexelFactor.x) - log2(sqrt(length(cross(ddx_fine(_301), ddy_fine(_301))) / max(abs(mad(_303.x, _304.y, -(_303.y * _304.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _326 = max(_323, -1024.0f);
                        _327 = min(_323, 1024.0f);
                    }
                    else
                    {
                        _326 = -1024.0f;
                        _327 = 1024.0f;
                    }
                    float _366 = 0.0f;
                    float _367 = 0.0f;
                    if (CPUTexelFactor.y > 0.0f)
                    {
                        float4 _337 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                        float3 _341 = _337.xyz / _337.w.xxx;
                        float2 _343 = ddx_fine(in_var_TEXCOORD1.zw);
                        float2 _344 = ddy_fine(in_var_TEXCOORD1.zw);
                        float _363 = clamp(log2(CPUTexelFactor.y) - log2(sqrt(length(cross(ddx_fine(_341), ddy_fine(_341))) / max(abs(mad(_343.x, _344.y, -(_343.y * _344.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _366 = max(_363, _326);
                        _367 = min(_363, _327);
                    }
                    else
                    {
                        _366 = _326;
                        _367 = _327;
                    }
                    float _406 = 0.0f;
                    float _407 = 0.0f;
                    if (CPUTexelFactor.z > 0.0f)
                    {
                        float4 _377 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                        float3 _381 = _377.xyz / _377.w.xxx;
                        float2 _383 = ddx_fine(in_var_TEXCOORD2.xy);
                        float2 _384 = ddy_fine(in_var_TEXCOORD2.xy);
                        float _403 = clamp(log2(CPUTexelFactor.z) - log2(sqrt(length(cross(ddx_fine(_381), ddy_fine(_381))) / max(abs(mad(_383.x, _384.y, -(_383.y * _384.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _406 = max(_403, _366);
                        _407 = min(_403, _367);
                    }
                    else
                    {
                        _406 = _366;
                        _407 = _367;
                    }
                    float _446 = 0.0f;
                    float _447 = 0.0f;
                    if (CPUTexelFactor.w > 0.0f)
                    {
                        float4 _417 = mul(float4(gl_FragCoord.xyz, 1.0f), InstancedView_InstancedView_SVPositionToTranslatedWorld[in_var_VIEW_ID]);
                        float3 _421 = _417.xyz / _417.w.xxx;
                        float2 _423 = ddx_fine(in_var_TEXCOORD2.zw);
                        float2 _424 = ddy_fine(in_var_TEXCOORD2.zw);
                        float _443 = clamp(log2(CPUTexelFactor.w) - log2(sqrt(length(cross(ddx_fine(_421), ddy_fine(_421))) / max(abs(mad(_423.x, _424.y, -(_423.y * _424.x))), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _446 = max(_443, _406);
                        _447 = min(_443, _407);
                    }
                    else
                    {
                        _446 = _406;
                        _447 = _407;
                    }
                    int2 _449 = int2(gl_FragCoord.xy);
                    float _455 = ((_449.x & 8) == (_449.y & 8)) ? _447 : _446;
                    float3 _473 = 0.0f.xxx;
                    if (abs(_455) != 1024.0f)
                    {
                        int _462 = int(floor(_455) + 2.0f);
                        _473 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_462].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_462 + 1].xyz, frac(_455).xxx);
                    }
                    else
                    {
                        _473 = 0.014999999664723873138427734375f.xxx;
                    }
                    _556 = _473;
                }
                _563 = float4(_556, PrimitiveAlpha);
            }
            else
            {
                float4 _281 = 0.0f.xxxx;
                if ((VisualizeMode == 7) || (VisualizeMode == 8))
                {
                    float4 _280 = 0.0f.xxxx;
                    if (AnalysisParams.y != 0)
                    {
                        _280 = 256.0f.xxxx;
                    }
                    else
                    {
                        _280 = float4(0.0f, 0.0f, 0.0f, PrimitiveAlpha);
                    }
                    _281 = _280;
                }
                else
                {
                    float4 _270 = 0.0f.xxxx;
                    if (VisualizeMode == 9)
                    {
                        _270 = float4(0.0f, 0.0f, 0.0f, PrimitiveAlpha);
                    }
                    else
                    {
                        float4 _266 = 0.0f.xxxx;
                        if (VisualizeMode == 10)
                        {
                            float3 _240 = _122[3].xyz + _128;
                            float4x4 _242 = _122;
                            _242[3] = float4(_240.x, _240.y, _240.z, _122[3].w);
                            _266 = float4(DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[LODIndex].xyz * mad(0.949999988079071044921875f, dot(max(lerp((length(-((View_View_InvDeviceZToWorldZTransform.y + ((-1.0f) / View_View_InvDeviceZToWorldZTransform.w)).xxx * mul(float4(mad((gl_FragCoord.xy - InstancedView_InstancedView_ViewRectMin[in_var_VIEW_ID].xy) * InstancedView_InstancedView_ViewSizeAndInvSize.zw, 2.0f.xx, (-1.0f).xx), 1.0f, 0.0f), _242).xyz)) * 0.00999999977648258209228515625f).xxx, Material_Material_PreshaderBuffer[0].yzw, Material_Material_PreshaderBuffer[0].x.xxx), 0.0f.xxx), float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f)), 0.0500000007450580596923828125f), 1.0f);
                        }
                        else
                        {
                            float4 _217 = 0.0f.xxxx;
                            if (VisualizeMode == 11)
                            {
                                float3 _191 = _122[3].xyz + _128;
                                float4x4 _193 = _122;
                                _193[3] = float4(_191.x, _191.y, _191.z, _122[3].w);
                                _217 = float4(SkinCacheDebugColor * mad(0.949999988079071044921875f, dot(max(lerp((length(-((View_View_InvDeviceZToWorldZTransform.y + ((-1.0f) / View_View_InvDeviceZToWorldZTransform.w)).xxx * mul(float4(mad((gl_FragCoord.xy - InstancedView_InstancedView_ViewRectMin[in_var_VIEW_ID].xy) * InstancedView_InstancedView_ViewSizeAndInvSize.zw, 2.0f.xx, (-1.0f).xx), 1.0f, 0.0f), _193).xyz)) * 0.00999999977648258209228515625f).xxx, Material_Material_PreshaderBuffer[0].yzw, Material_Material_PreshaderBuffer[0].x.xxx), 0.0f.xxx), float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f)), 0.0500000007450580596923828125f), 1.0f);
                            }
                            else
                            {
                                _217 = float4(1.0f, 0.0f, 1.0f, 1.0f);
                            }
                            _266 = _217;
                        }
                        _270 = _266;
                    }
                    _281 = _270;
                }
                _563 = _281;
            }
            _603 = _563;
        }
        _706 = _603;
    }
    out_var_SV_Target0 = _706;
}

[earlydepthstencil]
SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_PrimitiveID = stage_input.gl_PrimitiveID;
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    in_var_TEXCOORD0 = stage_input.in_var_TEXCOORD0;
    in_var_TEXCOORD1 = stage_input.in_var_TEXCOORD1;
    in_var_TEXCOORD2 = stage_input.in_var_TEXCOORD2;
    in_var_TEXCOORD3 = stage_input.in_var_TEXCOORD3;
    in_var_TEXCOORD4 = stage_input.in_var_TEXCOORD4;
    in_var_TEXCOORD5 = stage_input.in_var_TEXCOORD5;
    in_var_VIEW_ID = stage_input.in_var_VIEW_ID;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.out_var_SV_Target0 = out_var_SV_Target0;
    return stage_output;
}
