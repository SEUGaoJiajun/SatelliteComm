clear;
clc;
sp_factor = 256;                                       %��Ƶ���г���
bit_rate = 7500;                                        %��������
spread_code = 2*randi([0,1],1,sp_factor)-1;             %��Ƶ����
rolloff = 0.25;                                         %�����˲�������ϵ��
rrc_span_symbol = 16;                                   %�����˲����Է��������㣬�弤��Ӧ����Ϊ���ٸ�����
rrc_multiply_rate = 4;                                  %�����˲����ڲ�ֵ���ʣ�ÿ�����������˲���������ٸ�����
f_err = 100;                                             %�ز�Ƶ��(Hz)
wf_err = 2*pi*f_err;                                    %�ز���Ƶ��
ch_delay = 12.4;                                        %�ŵ�������ӳ٣�����ߵ� Ts =1/bit_rate/sp_factor/rrc_multiply_rate Ϊ��λ
Ts = 1/bit_rate/sp_factor/rrc_multiply_rate;            %Ts ϵͳ��߲���ʱ��
Tb = 1/bit_rate;                                        %Tb PLL��·�˲�����ʱ�� = ÿһ����Ϣ���س���ʱ��
Tspb = 1/bit_rate/sp_factor;                            %Tspb ��Ƶ֮���һ�����س���ʱ��
bit_clk_err_ratio = 10e-5;                               %λ��ʱ����ʣ����ο������������Ƶ�ʵ���������10-100ppm����
deltaT_per_sample = bit_clk_err_ratio;               %����ÿһ������ʱ�ӽ���Ts����ʵ�ʽ��յ�ʱ�ӱȷ��͵Ľ��Ķ���ٵ�ʱ���

spread_code_up = zeros(1,rrc_multiply_rate*sp_factor);
for i = 1:sp_factor
    spread_code_up(rrc_multiply_rate*(i-1)+1)=spread_code(sp_factor-i+1); %spread_code_up ����������Ϊ�����˲���ģ��ʵ���������
end;
fs = bit_rate*sp_factor*rrc_multiply_rate; % fs = FPGAϵͳ����Ƶ��
fs2 = bit_rate; % fs2 ����Ƶ��

Kvco = 2*pi*fs; % Kvco��VCO���棬��λRad/number�������number��һ��Ϊfs����number/fs = ����Ƶ�ʣ���������������32λ�ֳ������������Ҫ*2^32
fn =100;        % �趨�Ļ�·�˲���
wn = 2*pi*fn;   % ��·��Ƶ��
Ksai = 1;       % ��·����ϵ��
 %tao1��tao2Ϊģ�����໷��������������µ�ϵ������·�˲���������˹�任 F(s) = (1+tao2*s)/(tao1*s)��
 %����˲�������һ�����Ա�������tao2/tao1��һ��������1/s/tao1�����ʵ��PID���ƣ�û��΢���������������ɢʱ���� = �ۼ���*Tb
 %Tb = ��Ϣ���س���ʱ��
tao1 = Kvco/(wn^2);
tao2 = Ksai*2/wn;
%����Ϊ���໷���������໷�Ĳ�׽�����ޣ�ֻ��200Hz���ң�����һ��ʼ��Ҫ��Ƶ���ĸ�������Ƶ��������ڽ��ĽǶȲ���ֱ�ӵõ�Ƶ��





