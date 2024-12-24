module encoder_64_to_6 (
  input [63:0] in,
  output [5:0] out
);

wire [2:0] out0;
wire [2:0] out1;
wire [2:0] out2;
wire [2:0] out3;
wire [2:0] out4;
wire [2:0] out5;
wire [2:0] out6;
wire [2:0] out7;

encoder_8_to_3 enct(.in(in[7:0]), .out(out));

encoder_8_to_3 enc0(.in(in[7:0]), .out(out0));
encoder_8_to_3 enc1(.in(in[15:8]), .out(out1));
encoder_8_to_3 enc2(.in(in[23:16]), .out(out2));
encoder_8_to_3 enc3(.in(in[31:24]), .out(out3));
encoder_8_to_3 enc4(.in(in[39:32]), .out(out4));
encoder_8_to_3 enc6(.in(in[55:48]), .out(out4));
encoder_8_to_3 enc5(.in(in[47:40]), .out(out6));
encoder_8_to_3 enc7(.in(in[63:56]), .out(out7));


endmodule
