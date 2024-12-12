module encoder_512_to_9 (
    input       [511:0]    in,   // 512 位输入信号
    output [8:0]            out   // 9 位输出信号
);

// 内部信号
wire [7:0] group_valid;          // 每组是否有有效信号
wire [5:0] group_encoded [7:0];  // 每组的 6 位编码

// 分组优先编码，每组 64 位
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : group_encode
        wire [63:0] group_in = in[i*64 +: 64];
        assign group_valid[i] = |group_in;

        // 使用连续赋值实现优先编码
        assign group_encoded[i] = 
            group_in[0]  ? 6'd0  :
            group_in[1]  ? 6'd1  :
            group_in[2]  ? 6'd2  :
            group_in[3]  ? 6'd3  :
            group_in[4]  ? 6'd4  :
            group_in[5]  ? 6'd5  :
            group_in[6]  ? 6'd6  :
            group_in[7]  ? 6'd7  :
            group_in[8]  ? 6'd8  :
            group_in[9]  ? 6'd9  :
            group_in[10] ? 6'd10 :
            group_in[11] ? 6'd11 :
            group_in[12] ? 6'd12 :
            group_in[13] ? 6'd13 :
            group_in[14] ? 6'd14 :
            group_in[15] ? 6'd15 :
            group_in[16] ? 6'd16 :
            group_in[17] ? 6'd17 :
            group_in[18] ? 6'd18 :
            group_in[19] ? 6'd19 :
            group_in[20] ? 6'd20 :
            group_in[21] ? 6'd21 :
            group_in[22] ? 6'd22 :
            group_in[23] ? 6'd23 :
            group_in[24] ? 6'd24 :
            group_in[25] ? 6'd25 :
            group_in[26] ? 6'd26 :
            group_in[27] ? 6'd27 :
            group_in[28] ? 6'd28 :
            group_in[29] ? 6'd29 :
            group_in[30] ? 6'd30 :
            group_in[31] ? 6'd31 :
            group_in[32] ? 6'd32 :
            group_in[33] ? 6'd33 :
            group_in[34] ? 6'd34 :
            group_in[35] ? 6'd35 :
            group_in[36] ? 6'd36 :
            group_in[37] ? 6'd37 :
            group_in[38] ? 6'd38 :
            group_in[39] ? 6'd39 :
            group_in[40] ? 6'd40 :
            group_in[41] ? 6'd41 :
            group_in[42] ? 6'd42 :
            group_in[43] ? 6'd43 :
            group_in[44] ? 6'd44 :
            group_in[45] ? 6'd45 :
            group_in[46] ? 6'd46 :
            group_in[47] ? 6'd47 :
            group_in[48] ? 6'd48 :
            group_in[49] ? 6'd49 :
            group_in[50] ? 6'd50 :
            group_in[51] ? 6'd51 :
            group_in[52] ? 6'd52 :
            group_in[53] ? 6'd53 :
            group_in[54] ? 6'd54 :
            group_in[55] ? 6'd55 :
            group_in[56] ? 6'd56 :
            group_in[57] ? 6'd57 :
            group_in[58] ? 6'd58 :
            group_in[59] ? 6'd59 :
            group_in[60] ? 6'd60 :
            group_in[61] ? 6'd61 :
            group_in[62] ? 6'd62 :
            group_in[63] ? 6'd63 :
            6'd0; // 默认值
    end
endgenerate

// 组优先编码，找到第一个有有效信号的组
wire [2:0] first_group =
    group_valid[0] ? 3'd0 :
    group_valid[1] ? 3'd1 :
    group_valid[2] ? 3'd2 :
    group_valid[3] ? 3'd3 :
    group_valid[4] ? 3'd4 :
    group_valid[5] ? 3'd5 :
    group_valid[6] ? 3'd6 :
    group_valid[7] ? 3'd7 :
    3'd0; // 默认值

// 获取第一个有效组的编码
wire [5:0] first_group_encoded =
    group_valid[0] ? group_encoded[0] :
    group_valid[1] ? group_encoded[1] :
    group_valid[2] ? group_encoded[2] :
    group_valid[3] ? group_encoded[3] :
    group_valid[4] ? group_encoded[4] :
    group_valid[5] ? group_encoded[5] :
    group_valid[6] ? group_encoded[6] :
    group_valid[7] ? group_encoded[7] :
    6'd0; // 默认值

// 最终输出编码
assign out = {first_group, first_group_encoded};

endmodule
