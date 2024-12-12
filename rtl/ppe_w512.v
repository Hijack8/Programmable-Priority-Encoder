module ppe_w512 (
    input              [ 511: 0]        Req                        ,
    input              [   8: 0]        P_enc                      ,
    output             [   8: 0]        o_value                    ,
    output                              valid                       // 输出valid信号
);

    wire               [ 511: 0]        P_thermo                   ;
    wire               [ 511: 0]        Gnt_smpl_pe                ;
    wire               [ 511: 0]        Gnt_smpl_pe_thermo         ;
    wire               [   1: 0]        anyGnt_smpl_pe_thermo      ;
    wire               [   1: 0]        anyGnt_smpl_pe             ;
    reg                [ 511: 0]        Gnt                        ;


    // 调整 thermometer_w1024 为支持 512 位的 thermometer_w512
    thermometer_w512 u_thermometer (
    .enc                                (P_enc                     ),
    .thermo                             (P_thermo                  ) 
    );

    // 修改为 smpl_pe_w256
    smpl_pe_w256 u0_smpl_pe_thermo_w256 (
    .Req                                ((~P_thermo[255:0]) & Req[255:0]),
    .Gnt                                (Gnt_smpl_pe_thermo[255:0] ),
    .valid                              (anyGnt_smpl_pe_thermo[0]  ) 
    );

    smpl_pe_w256 u0_smpl_pe_w256 (
    .Req                                (Req[255:0]                ),
    .Gnt                                (Gnt_smpl_pe[255:0]        ),
    .valid                              (anyGnt_smpl_pe[0]         ) 
    );

    smpl_pe_w256 u1_smpl_pe_thermo_w256 (
    .Req                                ((~P_thermo[511:256]) & Req[511:256]),
    .Gnt                                (Gnt_smpl_pe_thermo[511:256]),
    .valid                              (anyGnt_smpl_pe_thermo[1]  ) 
    );

    smpl_pe_w256 u1_smpl_pe_w256 (
    .Req                                (Req[511:256]              ),
    .Gnt                                (Gnt_smpl_pe[511:256]      ),
    .valid                              (anyGnt_smpl_pe[1]         ) 
    );

    // valid信号的逻辑
    assign                              valid                     = ~((anyGnt_smpl_pe_thermo | anyGnt_smpl_pe) == 2'b0);
    
    encoder_512_to_9 u_encoder (
    .in                                 (Gnt                       ),
    .out                                (o_value                   )
    );

    // 选择Gnt的逻辑
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
                        Gnt = {256'b0, Gnt_smpl_pe[255:0]};
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
                        Gnt = {256'b0, Gnt_smpl_pe_thermo[255:0]};
                    end
                    1'b1: begin
                        Gnt = {Gnt_smpl_pe_thermo[511:256], 256'b0};
                    end
                endcase
            end
        endcase
    end
endmodule
