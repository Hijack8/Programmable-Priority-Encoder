module ppe_w512_p (
    input                               clk                        ,
    input                               rst                        ,
    input              [ 511: 0]        Req                        ,
    input              [   8: 0]        P_enc                      ,
    output    reg         [   8: 0]     o_value                    ,
    output    reg         [   8: 0]     o_value_inc                ,
    output    reg                       valid                       
);

    wire               [   1: 0]        anyGnt_smpl_pe_thermo      ;
    wire               [   1: 0]        anyGnt_smpl_pe             ;

    wire               [ 511: 0]        P_thermo                   ;

    reg                [ 511: 0]        P_thermo_reg               ;
    reg                [ 511: 0]        Req_reg                    ;
    reg                [   8: 0]        P_enc_reg                  ; 

    reg                [ 511: 0]        Req_reg_4_s2               ;
    reg                [   8: 0]        P_enc_reg_4_s2             ; 

    wire               [ 511: 0]        Gnt_smpl_pe                ;
    wire               [ 511: 0]        Gnt_smpl_pe_thermo         ;
    wire               [ 511: 0]        Gnt                        ;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            P_enc_reg <= 9'b0;
            P_enc_reg_4_s2 <= 9'b0;
        end else begin
            P_enc_reg <= P_enc;
            P_enc_reg_4_s2 <= P_enc_reg;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Req_reg <= 512'b0;
            Req_reg_4_s2 <= 512'b0;
        end else begin
            Req_reg <= Req;
            Req_reg_4_s2 <= Req_reg;
        end
    end   


    // 调整 thermometer_w1024 为支持 512 位的 thermometer_w512
    thermometer_w512 u_thermometer (
    //.enc                                (P_enc                     ),
    .enc                                (P_enc_reg                 ),
    .thermo                             (P_thermo                  ) 
    ); 

    // 处理时序逻辑 pipeline
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P_thermo_reg <= 512'b0;
        end else begin
            P_thermo_reg <= P_thermo;
        end
    end  
                          

    // 修改为 smpl_pe_w256
    smpl_pe_w256 u0_smpl_pe_thermo_w256 (
    .Req                                ((~P_thermo_reg[255:0]) & Req_reg_4_s2[255:0]),
    .Gnt                                (Gnt_smpl_pe_thermo[255:0] ),
    .valid                              (anyGnt_smpl_pe_thermo[0]  ) 
    );

    smpl_pe_w256 u0_smpl_pe_w256 (
    .Req                                (Req_reg_4_s2[255:0]            ),
    .Gnt                                (Gnt_smpl_pe[255:0]        ),
    .valid                              (anyGnt_smpl_pe[0]         ) 
    );

    smpl_pe_w256 u1_smpl_pe_thermo_w256 (
    .Req                                ((~P_thermo_reg[511:256]) & Req_reg_4_s2[511:256]),
    .Gnt                                (Gnt_smpl_pe_thermo[511:256]),
    .valid                              (anyGnt_smpl_pe_thermo[1]  ) 
    );

    smpl_pe_w256 u1_smpl_pe_w256 (
    .Req                                (Req_reg_4_s2[511:256]          ),
    .Gnt                                (Gnt_smpl_pe[511:256]      ),
    .valid                              (anyGnt_smpl_pe[1]         ) 
    );

    // 选择Gnt的逻辑
    // 使用连续赋值语句替代原来的 always 块
    assign Gnt = (anyGnt_smpl_pe_thermo == 2'b00) ? (
                    (anyGnt_smpl_pe == 2'b11) ? {256'b0, Gnt_smpl_pe[255:0]} :
                    Gnt_smpl_pe
                ) :
                ((anyGnt_smpl_pe_thermo == 2'b01 || anyGnt_smpl_pe_thermo == 2'b10) ? 
                    Gnt_smpl_pe_thermo :
                    (P_enc_reg_4_s2[8] ? {Gnt_smpl_pe_thermo[511:256], 256'b0} : {256'b0, Gnt_smpl_pe_thermo[255:0]})
                );

    wire [8:0] o_value_wire;
    // encoder_512_to_9 u_encoder (
    // .in                                 (Gnt                       ),
    // .out                                (o_value_wire                   ) 
    // );
    encoder_512_to_9_reg u_encoder (
    .in                                 (Gnt                       ),
    .out                                (o_value_wire                   ) 
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            o_value_inc <= 9'b0;
            o_value <= 9'b0;
        end else begin
            o_value_inc <= o_value_wire+1;
            o_value <= o_value_wire;
        end
    end
    

    // valid信号的逻辑
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            valid <= 512'b0;
        end else begin
            valid <= ~((anyGnt_smpl_pe_thermo | anyGnt_smpl_pe) == 2'b0);
        end
    end

endmodule
