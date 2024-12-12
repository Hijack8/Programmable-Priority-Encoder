module smpl_pe_w512(
    input              [ 511: 0]        Req                        ,
    output             [ 511: 0]        Gnt                        ,
    output                              valid                       
);
    assign Gnt = Req & (~Req + 1);
    assign valid = |Req;
                                                                   
endmodule