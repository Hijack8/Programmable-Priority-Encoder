`timescale 1ns / 1ps
module scheduler #(
  parameter PPE_WIDTH = 8,
  parameter PPE_LOG_W =3 
) (
    input clk,
    input              [PPE_WIDTH*PPE_WIDTH-1: 0]        Req,
    output reg         [PPE_WIDTH*PPE_WIDTH-1: 0]        Gnt,
    output                              valid
);

  genvar i;
  wire [PPE_LOG_W-1:0] top_p_enc;
  wire [PPE_WIDTH-1:0] top_req;

  generate
    for (i = 0; i < PPE_WIDTH; i = i + 1) begin
      assign top_req[i] = |Req[(i + 1)*PPE_WIDTH-1:i*PPE_WIDTH];
    end
  endgenerate

  wire [PPE_WIDTH-1:0] gnt_top;
  ppe #(
    .PPE_WIDTH(PPE_WIDTH),
    .PPE_LOG_W(PPE_LOG_W)
  ) ppe_top (
    .Req(top_req),
    .P_enc(top_p_enc),
    .Gnt(Gnt_top),
    .valid(valid_top)
  );

  wire [PPE_LOG_W-1:0] o_top;
  encoder #(
    .WIDTH(PPE_WIDTH),
    .LOG_W(PPE_LOG_W)
  ) encoder_top(
    .in(Gnt_top<<1 | Gnt_top >> (PPE_WIDTH-1)),
    .out(o_top)
  );

  generate 
    for (i = 0; i < PPE_WIDTH; i = i + 1) begin 
      assign Gnt_o[(i+1)*PPE_WIDTH-1:i*PPE_WIDTH] = Gnt_top_reg[i] ? Gnt[i] : 0;
    end
  endgenerate

  generate 
    for (i = 0; i < PPE_WIDTH; i = i + 1) begin 
      ppe #(
        .PPE_WIDTH(PPE_WIDTH),
        .PPE_LOG_W(PPE_LOG_W)
      ) ppe_inst (
          .Req(Reqi[i]),
          .P_enc(P_enc[i]),
          .Gnt(Gnt[i]),
          .valid(valid[i])
      );

      encoder #(
        .WIDTH(PPE_WIDTH),
        .LOG_W(PPE_LOG_W)
      ) encoder_inst (
      .in(Gnt[i] << 1 | Gnt[i] >> (PPE_WIDTH-1)),
      .out(o_value[i]) 
      );
    end
  endgenerate


  reg [PPE_WIDTH-1:0] Gnt_top_reg;
  reg [PPE_WIDTH*PPE_WIDTH-1:0] Req_reg;

  reg [PPE_H_LOG_W-1:0] o_value_last[PPE_H_WIDTH_T-1:0];
  reg [PPE_H_LOG_W-1:0] P_enc[PPE_H_WIDTH_T-1:0]; // N * P_ecn
  wire [PPE_H_WIDTH-1:0] Gnt[PPE_H_WIDTH_T-1:0];
  wire [PPE_H_LOG_W-1:0] o_value[PPE_H_WIDTH_T-1:0];

  wire [PPE_H_WIDTH-1:0] Reqi[PPE_H_WIDTH_T-1:0];
  generate 
    for (i = 0; i < PPE_H_WIDTH_T; i = i + 1) begin 
      assign Reqi[i] = Req_reg[(i+1)*PPE_H_WIDTH-1:i*PPE_H_WIDTH];
    end
  endgenerate

  always@(posedge clk) begin 
    if (rst) begin 
      Gnt_top_reg <= 0;
      Req_reg <= 0;
    end else begin 

      for (j = 0; j < PPE_WIDTH; j = j + 1) begin 
        P_enc[j] <= Gnt_top_reg[j] ? o_value[j] : P_enc[j];
        o_value_last[j] <= o_value[j];
        if (Gnt_top_reg[j] && o_value[j] <= o_value_last[j]) begin
          top_p_enc <= o_top;
        end
      end
    end
  end




endmodule
