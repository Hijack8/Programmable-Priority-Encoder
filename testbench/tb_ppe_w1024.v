// Testbench 模块
module tb_ppe_w1024;

    // 时钟周期定义
    parameter CLK_PERIOD = 10;

    // 输入信号
    reg clk;
    reg rst;
    reg [1023:0] Req;
    reg [9:0] P_enc;

    // 输出信号
    wire [9:0] o_value;
    wire [9:0] o_value_inc;
    wire valid;

    // 实例化被测模块
    ppe_w1024_p uut (
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
        Req = 1024'b0;
        P_enc = 10'b0;

        // 复位信号
        #(CLK_PERIOD*2) rst = 1'b1;
        #(CLK_PERIOD*2) rst = 1'b0;
        #(CLK_PERIOD*4);
        
        // 测试向量2：多个位请求
        set_request_vector(10'b0100101001, 10'd5);
        set_request_vector(10'b0101101001, 10'd4);
        set_request_vector(10'b0100101001, 10'd3);
        set_request_vector(10'b0100111001, 10'd2);
        set_request_vector(10'b1100101001, 10'd1);
        set_request_vector(10'b1010101001, 10'd0);
        set_request_vector(10'b0100101001, 10'd5);


        // 测试向量4：无请求
        #(CLK_PERIOD);
        P_enc = 10'd4;
        Req = 1024'b0;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 10'd500;
        Req = 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 10'd501;
        Req = 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 10'd502;
        Req = 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 10'd503;
        Req = 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 测试向量5：全1请求
        #(CLK_PERIOD*4);
        P_enc = 10'd511;
        Req = 1024'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // 仿真结束
        #(CLK_PERIOD*10);
        $finish;

    end
    
    // 定义设置请求向量的任务
    task set_request_vector(
        input [9:0] req_bits,    // 前 10 位的位图，10 位二进制数
        input [9:0] P_enc_size   // P_enc 的大小，10 位数
    );
        begin
            // 延迟一个时钟周期
            #(CLK_PERIOD);
            
            // 设置 P_enc
            P_enc = P_enc_size;
        
            // 初始化 Req 并根据 req_bits 设置
            Req = 1024'b0;               // 初始化 Req 为 1024 位全 0
            Req[9:0] = req_bits;         // 只设置前 10 位的值
        end
    endtask

endmodule
