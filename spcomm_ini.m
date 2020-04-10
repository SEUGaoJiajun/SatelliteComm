clear;
clc;
sp_factor = 256;                                       %扩频序列长度
bit_rate = 7500;                                        %比特速率
spread_code = 2*randi([0,1],1,sp_factor)-1;             %扩频序列
rolloff = 0.25;                                         %基带滤波器滚降系数
rrc_span_symbol = 16;                                   %基带滤波器以符号数计算，冲激响应长度为多少个符号
rrc_multiply_rate = 4;                                  %基带滤波器内插值倍率，每个基带符号滤波器输出多少个样本
f_err = 100;                                             %载波频差(Hz)
wf_err = 2*pi*f_err;                                    %载波角频率
ch_delay = 12.4;                                        %信道随机的延迟，以最高的 Ts =1/bit_rate/sp_factor/rrc_multiply_rate 为单位
Ts = 1/bit_rate/sp_factor/rrc_multiply_rate;            %Ts 系统最高采样时钟
Tb = 1/bit_rate;                                        %Tb PLL环路滤波采样时钟 = 每一个信息比特持续时间
Tspb = 1/bit_rate/sp_factor;                            %Tspb 扩频之后的一个比特持续时间
bit_clk_err_ratio = 10e-5;                               %位定时误差率，即参考晶振相对中心频率的误差，大致在10-100ppm左右
deltaT_per_sample = bit_clk_err_ratio;               %就是每一个发送时钟节拍Ts过后，实际接收的时钟比发送的节拍多或少的时间差

spread_code_up = zeros(1,rrc_multiply_rate*sp_factor);
for i = 1:sp_factor
    spread_code_up(rrc_multiply_rate*(i-1)+1)=spread_code(sp_factor-i+1); %spread_code_up 倒过来排序为了用滤波器模块实现相关运算
end;
fs = bit_rate*sp_factor*rrc_multiply_rate; % fs = FPGA系统采样频率
fs2 = bit_rate; % fs2 比特频率

Kvco = 2*pi*fs; % Kvco，VCO增益，单位Rad/number，这里的number归一化为fs，即number/fs = 所需频率，对于数控振荡器若32位字长，则这个量需要*2^32
fn =100;        % 设定的环路滤波器
wn = 2*pi*fn;   % 环路角频率
Ksai = 1;       % 环路阻尼系数
 %tao1和tao2为模拟锁相环理想积分器配置下的系数，环路滤波器拉普拉斯变换 F(s) = (1+tao2*s)/(tao1*s)，
 %这个滤波器可用一个线性比例部分tao2/tao1与一个积分器1/s/tao1相加来实现PID控制（没有微分项），积分器在离散时间域 = 累加器*Tb
 %Tb = 信息比特持续时间
tao1 = Kvco/(wn^2);
tao2 = Ksai*2/wn;
%以上为锁相环参数，锁相环的捕捉带有限，只有200Hz左右，所以一开始需要锁频环的辅助，锁频环检测相邻节拍角度差异直接得到频差





