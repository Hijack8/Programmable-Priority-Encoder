module thermometer_w512(
    input              [8:0]           enc                        ,
    output             [511:0]          thermo                       // 修改为 512 位
);

    // implement a 10 to 512 bit thermometer encoder
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_loop
            assign thermo[i] = (i < enc) ? 1'b1 : 1'b0;
        end
    endgenerate                                                          
                                                                   
endmodule