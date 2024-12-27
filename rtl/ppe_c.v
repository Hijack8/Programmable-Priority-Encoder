module ppe_c #(
  parameter PPE_C_WIDTH = 8,
  parameter PPE_C_LOG_W = 3 
) (
    input                               clk                        ,
    input                               rst                        ,
    input              [PPE_C_WIDTH-1:0]         Req                        ,
    output reg         [PPE_C_WIDTH-1:0]         Gnt_reg,
    output reg                          valid
);
    
    reg                [PPE_C_WIDTH-1:0]        Req_reg                    ;
    reg                [PPE_C_LOG_W-1:0]        P_enc_reg                  ;
    wire                               valid_wire                  ;
    wire [PPE_C_LOG_W-1:0] o_value_wire;

    wire [PPE_C_WIDTH-1:0] Gnt;

    ppe #(
      .PPE_WIDTH(PPE_C_WIDTH),
      .PPE_LOG_W(PPE_C_LOG_W)
    )u_ppe_w1024 (
        .Req                                (Req_reg                   ),
        .P_enc                              (P_enc_reg                 ),
        .Gnt(Gnt),
        .valid                              (valid_wire                )
    );

    encoder #(
      .WIDTH(PPE_C_WIDTH),
      .LOG_W(PPE_C_LOG_W)
    )u_encoder (
    .in                                 (Gnt_reg << 1 | Gnt_reg >> (PPE_C_WIDTH-1)),
    .out                                (o_value_wire) 
    );


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Req_reg     <= 0;
            P_enc_reg   <= 0;
            valid       <= 0;
        end else begin
            Req_reg     <= Req;
            Gnt_reg <= Gnt;
            P_enc_reg   <= o_value_wire;
            valid       <= valid_wire;
        end
    end
    
endmodule
