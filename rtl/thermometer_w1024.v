module thermometer_w1024(
    input              [   9: 0]        enc                        ,
    output             [1023: 0]        thermo                      
);
    // implement a 10 to 1024 bit thermometer encoder
    genvar i;
    generate
        for (i = 0; i < 1024; i = i + 1) begin : gen_loop
            assign thermo[i] = (i < enc) ? 1'b1 : 1'b0;
        end
    endgenerate                                                          
                                                                   
endmodule