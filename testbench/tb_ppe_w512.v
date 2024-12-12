// Testbench 模块
module tb_ppe_w512;

    // 时钟周期定义
    parameter CLK_PERIOD = 10;

    // 输入信号
    reg clk;
    reg rst;
    reg [511:0] Req;
    reg [8:0] P_enc;

    // 输出信号
    wire [8:0] o_value;
    wire [8:0] o_value_inc;
    wire valid;

    // 实例化被测模块
    ppe_w512_p uut (
        .clk    (clk),
        .rst    (rst),
        .Req    (Req),
        .P_enc  (P_enc),
        .o_value(o_value),
        .o_value_inc(o_value_inc),
        .valid  (valid)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 初始化和复位
    initial begin
        // 初始化输入信号
        rst = 1'b0;
        Req = 512'b0;
        P_enc = 9'b0;

        // 复位信号
        #(CLK_PERIOD*2) rst = 1'b1;
        #(CLK_PERIOD*2) rst = 1'b0;
        #(CLK_PERIOD*4);
        
        // 测试向量2：多个位请求
        set_request_vector(7'b0100101, 9'd5);
        set_request_vector(7'b0101101, 9'd4);
        set_request_vector(7'b0100101, 9'd3);
        set_request_vector(7'b0100111, 9'd2);
        set_request_vector(7'b1100101, 9'd1);
        set_request_vector(7'b1010101, 9'd0);
        set_request_vector(7'b0100101, 9'd5);


        // 测试向量4：无请求
        #(CLK_PERIOD);
        P_enc = 9'd4;
        Req = 512'b0;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 9'd500;
        Req = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 9'd501;
        Req = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 9'd502;
        Req = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 9'd503;
        Req = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 9'd511;
        Req = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 仿真结束
        #(CLK_PERIOD*10);
        $finish;

    end
    
    task set_request_vector(
        input [6:0] req_bits,    // 前 7 位的位图，7 位二进制数
        input [8:0] P_enc_size   // P_enc 的大小，9 位数（假设 P_enc 为 9 位）
    );
        begin
            // 延迟 4 个时钟周期
            #(CLK_PERIOD);
            
            // 设置 P_enc
            P_enc = P_enc_size;
        
            // 初始化 Req 并根据 req_bits 设置
            Req = 512'b0;               // 初始化 Req 为 512 位全 0
            Req[6:0] = req_bits;        // 只设置前 7 位的值
        end
    endtask

endmodule