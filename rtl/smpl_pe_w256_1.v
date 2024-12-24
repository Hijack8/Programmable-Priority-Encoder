module smpl_pe_w256_1(
    input              [ 255: 0]        Req                        ,
    output             [ 255: 0]        Gnt                        ,
    output                              valid                       
);
    assign valid = |Req;
    wire [255:0]   pre_req;   
 
    assign pre_req[0] = 1'b0; 
    assign pre_req[255:1] = Req[254:0] | pre_req[254:0];
    assign Gnt = Req & ~pre_req;
endmodule
