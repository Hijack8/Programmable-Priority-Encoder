module ppe_w1024_c(
    input                               clk                        , // 时钟信号
    input                               rst                        , // 复位信号
    input              [1023:0]        Req                        , // 1024位请求信号
    output [  9:0]        o_value_wire                    , // 10位输出值
    output reg                          valid                       // 输出valid信号
);
    
    // 内部寄存器定义
    reg                [1023:0]        Req_reg                    ; // 1024位寄存器
    reg                [  9:0]        P_enc_reg                  ; // 10位P_enc寄存器
    wire                               valid_wire                  ; // valid信号线网

    wire [1023:0] Gnt;
    reg [1023:0] Gnt_reg;
    
    // 实例化 ppe_w1024 模块
    ppe_w1024 u_ppe_w1024 (
        .Req                                (Req_reg                   ), // 连接1024位Req_reg
        .P_enc                              (P_enc_reg                 ), // 连接10位P_enc_reg
        // .o_value                            (o_value_wire              ), // 连接10位o_value_wire
        .Gnt(Gnt),
        .valid                              (valid_wire                )  // 连接valid信号
    );

    // 实例化1024到10位的编码器
    encoder_1024_to_10 u_encoder (
    .in                                 (Gnt_reg                       ),
    .out                                (o_value_wire                   ) 
    );


    
    // 时序逻辑处理
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Req_reg     <= 1024'b0; // 复位时清零1024位Req_reg
            P_enc_reg   <= 10'b0;    // 复位时清零10位P_enc_reg
            valid       <= 1'b0;     // 复位时使能信号无效
        end else begin
            Req_reg     <= Req;          // 更新Req_reg
            Gnt_reg <= Gnt;
            // Gnt_reg <= (Gnt << 1) | (Gnt >> 1023); // 循环左移1位
            P_enc_reg   <= o_value_wire;        // 更新P_enc_reg
            valid       <= valid_wire;   // 更新valid信号
        end
    end
    
endmodule
