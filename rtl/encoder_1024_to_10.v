module encoder_1024_to_10(
    input              [ 1023: 0]        in                         ,
    output reg         [   9: 0]        out
);

    integer                             i                          ;
    always @(*) begin
        for (i = 0; i < 1024; i = i + 1) begin
            if (in[i]) begin
                out = i[9:0];
            end
        end
    end

endmodule