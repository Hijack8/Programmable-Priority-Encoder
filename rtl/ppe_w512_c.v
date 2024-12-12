module ppe_w512_c(
    input                               clk                        ,
    input                               rst                      ,
    input              [ 511: 0]        Req                        ,
    input              [   8: 0]        P_enc                      ,
    output reg         [   8: 0]        o_value                    ,
    output reg                          valid                       // 输出valid信号
);

    reg                [ 511: 0]        Req_reg                    ; // 512 位
    reg                [   8: 0]        P_enc_reg                  ; // P_enc 是 9 位
    wire               [   8: 0]        o_value_wire               ; // o_value 是 9 位
    wire                               valid_wire                  ; // valid 信号

    // 调用 ppe_w512 模块
    ppe_w512 u_ppe_w512 (                                               // 修改子模块名称和接口
        .Req                                (Req_reg                   ),
        .P_enc                              (P_enc_reg                 ),
        .o_value                            (o_value_wire              ),
        .valid                              (valid_wire                )  // valid 信号传递
    );

    // 处理时序逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Req_reg <= 512'b0;
            P_enc_reg <= 9'b0;  // P_enc 设为9位
            o_value <= 9'b0;
            valid <= 1'b0;
        end else begin
            Req_reg <= Req;
            P_enc_reg <= P_enc;  // P_enc 仍为9位
            o_value <= o_value_wire;
            valid <= valid_wire;  // 从子模块传递valid信号
        end
    end

endmodule
