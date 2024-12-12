module ppe_w1024_p (
    input                               clk                        ,
    input                               rst                        ,
    input              [1023: 0]        Req                        ,
    input              [   9: 0]        P_enc                      ,
    output    reg         [   9: 0]     o_value                    ,
    output    reg         [   9: 0]     o_value_inc                ,
    output    reg                       valid                       
);

    wire               [   1: 0]        anyGnt_smpl_pe_thermo      ;
    wire               [   1: 0]        anyGnt_smpl_pe             ;

    wire               [1023: 0]        P_thermo                   ;

    reg                [1023: 0]        P_thermo_reg               ;
    reg                [1023: 0]        Req_reg                    ;
    reg                [   9: 0]        P_enc_reg                  ; 

    reg                [1023: 0]        Req_reg_4_s2               ;
    reg                [   9: 0]        P_enc_reg_4_s2             ; 

    wire               [1023: 0]        Gnt_smpl_pe                ;
    wire               [1023: 0]        Gnt_smpl_pe_thermo         ;
    wire               [1023: 0]        Gnt                        ;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            P_enc_reg <= 10'b0;
            P_enc_reg_4_s2 <= 10'b0;
        end else begin
            P_enc_reg <= P_enc;
            P_enc_reg_4_s2 <= P_enc_reg;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Req_reg <= 1024'b0;
            Req_reg_4_s2 <= 1024'b0;
        end else begin
            Req_reg <= Req;
            Req_reg_4_s2 <= Req_reg;
        end
    end   

    // 调整 thermometer_w1024 为支持 1024 位的 thermometer_w1024
    thermometer_w1024 u_thermometer (
        //.enc                                (P_enc                     ),
        .enc                                (P_enc_reg                 ),
        .thermo                             (P_thermo                  ) 
    ); 

    // 处理时序逻辑 pipeline
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P_thermo_reg <= 1024'b0;
        end else begin
            P_thermo_reg <= P_thermo;
        end
    end  

    // 修改为 smpl_pe_w512
    smpl_pe_w512 u0_smpl_pe_thermo_w512 (
        .Req                                ((~P_thermo_reg[511:0]) & Req_reg_4_s2[511:0]),
        .Gnt                                (Gnt_smpl_pe_thermo[511:0] ),
        .valid                              (anyGnt_smpl_pe_thermo[0]  ) 
    );

    smpl_pe_w512 u0_smpl_pe_w512 (
        .Req                                (Req_reg_4_s2[511:0]            ),
        .Gnt                                (Gnt_smpl_pe[511:0]        ),
        .valid                              (anyGnt_smpl_pe[0]         ) 
    );

    smpl_pe_w512 u1_smpl_pe_thermo_w512 (
        .Req                                ((~P_thermo_reg[1023:512]) & Req_reg_4_s2[1023:512]),
        .Gnt                                (Gnt_smpl_pe_thermo[1023:512]),
        .valid                              (anyGnt_smpl_pe_thermo[1]  ) 
    );

    smpl_pe_w512 u1_smpl_pe_w512 (
        .Req                                (Req_reg_4_s2[1023:512]          ),
        .Gnt                                (Gnt_smpl_pe[1023:512]      ),
        .valid                              (anyGnt_smpl_pe[1]         ) 
    );

    // 选择Gnt的逻辑
    // 使用连续赋值语句替代原来的 always 块
    assign Gnt = (anyGnt_smpl_pe_thermo == 2'b00) ? (
                    (anyGnt_smpl_pe == 2'b11) ? {512'b0, Gnt_smpl_pe[511:0]} :
                    Gnt_smpl_pe
                ) :
                ((anyGnt_smpl_pe_thermo == 2'b01 || anyGnt_smpl_pe_thermo == 2'b10) ? 
                    Gnt_smpl_pe_thermo :
                    (P_enc_reg_4_s2[9] ? {Gnt_smpl_pe_thermo[1023:512], 512'b0} : {512'b0, Gnt_smpl_pe_thermo[511:0]})
                );

    wire [9:0] o_value_wire;
    encoder_1024_to_10 u_encoder (
        .in                                 (Gnt                       ),
        .out                                (o_value_wire                   ) 
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            o_value_inc <= 10'b0;
            o_value <= 10'b0;
        end else begin
            o_value_inc <= o_value_wire + 1;
            o_value <= o_value_wire;
        end
    end
    

    // valid信号的逻辑
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            valid <= 1'b0;
        end else begin
            valid <= ~((anyGnt_smpl_pe_thermo | anyGnt_smpl_pe) == 2'b00);
        end
    end

endmodule
