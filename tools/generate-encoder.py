def generate_encoder_code(input_width=512):
    # Verilog 模块头
    verilog_code = '''module encoder_512_to_9 (
    input              [{}:0]   in,  // {} 位输入信号
    output             [8:0]    out  // 9 位输出信号
);

    // 计算第一个为 1 的位的索引并输出到 out
    assign out = \n'''.format(input_width-1, input_width)

    # 生成连续赋值逻辑
    for i in range(input_width):
        verilog_code += "        (in[{}]) ? 9'd{}  :\n".format(i, i)
    
    # 最后加上默认值（如果所有位都为 0）
    verilog_code += "        9'b0;  // 默认值，防止所有位为 0\n"
    
    # 模块结束
    verilog_code += "endmodule\n"

    return verilog_code


# 生成 512 位输入的编码器代码
verilog_output = generate_encoder_code(input_width=512)

# 打印生成的 Verilog 代码
print(verilog_output)
