module encoder_512_to_9_reg(
    input              [ 511: 0]        in                         ,
    output reg         [   8: 0]        out
);

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            if (in[i]) begin
                out <= i[8:0];
            end
        end
    end

endmodule