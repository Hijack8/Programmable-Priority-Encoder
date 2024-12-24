module ppe_w1024 (
    input              [1023: 0]        Req                        ,// 请求信号，位宽为1024
    input              [   9: 0]        P_enc                      ,// 编码器输入，位宽为10
    // output             [   9: 0]        o_value                    ,// 编码器输出，位宽为10
    output reg [1023:0] Gnt,
    output                              valid                       // 输出valid信号
);

    wire               [1023: 0]        P_thermo                   ;// 热码信号，位宽为1024
    wire               [1023: 0]        Gnt_smpl_pe                ;// 授权信号，位宽为1024
    wire               [1023: 0]        Gnt_smpl_pe_thermo         ;// 热码授权信号，位宽为1024
    wire               [   1: 0]        anyGnt_smpl_pe_thermo      ;// 热码授权有效信号
    wire               [   1: 0]        anyGnt_smpl_pe             ;// 授权有效信号
    // reg                [1023: 0]        Gnt                        ;// 最终授权信号，位宽为1024

    // 实例化支持1024位的热码模块
    // thermometer_w1024 u_thermometer (
    // .enc                                (P_enc                     ),
    // .thermo                             (P_thermo                  ) 
    // );

    tothermo1024 rmo_mask(
      .x(P_enc),
      .y(P_thermo)
    );

    // 实例化四个采样授权模块，每个模块处理512位
    smpl_pe_w512_1 u0_smpl_pe_thermo_w512 (
    .Req                                ((~P_thermo[ 511:   0]) & Req[ 511:   0]),
    .Gnt                                (Gnt_smpl_pe_thermo[ 511:   0]),
    .valid                              (anyGnt_smpl_pe_thermo[0]  ) 
    );

    smpl_pe_w512_1 u0_smpl_pe_w512 (
    .Req                                (Req[ 511:   0]            ),
    .Gnt                                (Gnt_smpl_pe[ 511:   0]    ),
    .valid                              (anyGnt_smpl_pe[0]         ) 
    );

    smpl_pe_w512_1 u1_smpl_pe_thermo_w512 (
    .Req                                ((~P_thermo[1023: 512]) & Req[1023: 512]),
    .Gnt                                (Gnt_smpl_pe_thermo[1023: 512]),
    .valid                              (anyGnt_smpl_pe_thermo[1]  ) 
    );

    smpl_pe_w512_1 u1_smpl_pe_w512 (
    .Req                                (Req[1023: 512]            ),
    .Gnt                                (Gnt_smpl_pe[1023: 512]    ),
    .valid                              (anyGnt_smpl_pe[1]         ) 
    );

    // 生成valid信号，当任意一个授权有效时，valid为高
    // assign                              valid                     = ~((anyGnt_smpl_pe_thermo | anyGnt_smpl_pe) == 2'b00);
    assign valid = (anyGnt_smpl_pe[0] & anyGnt_smpl_pe[1]);
    
    // 实例化1024到10位的编码器
    // encoder_1024_to_10 u_encoder (
    // .in                                 (Gnt                       ),
    // .out                                (o_value                   ) 
    // );

    // 选择最终的Gnt信号逻辑
    always @* begin
        case(anyGnt_smpl_pe_thermo)
            2'b00: begin
                case(anyGnt_smpl_pe)
                    2'b00: begin
                        Gnt = Gnt_smpl_pe;
                    end
                    2'b01: begin
                        Gnt = Gnt_smpl_pe;
                    end
                    2'b10: begin
                        Gnt = Gnt_smpl_pe;
                    end
                    2'b11: begin
                        Gnt = {512'b0, Gnt_smpl_pe[ 511:   0]};
                    end
                endcase
            end
            2'b01: begin
                Gnt = Gnt_smpl_pe_thermo;
            end
            2'b10: begin
                Gnt = Gnt_smpl_pe_thermo;
            end
            2'b11: begin
                case (P_enc[9])
                    1'b0: begin
                        Gnt = {512'b0, Gnt_smpl_pe_thermo[ 511:   0]};
                    end
                    1'b1: begin
                        Gnt = {Gnt_smpl_pe_thermo[1023: 512], 512'b0};
                    end
                endcase
            end
        endcase
    end
endmodule
