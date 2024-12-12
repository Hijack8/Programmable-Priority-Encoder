module smpl_pe_w256(
    input              [ 255: 0]        Req                        ,
    output             [ 255: 0]        Gnt                        ,
    output                              valid                       
);
    assign Gnt = Req & (~Req + 1);
    assign valid = |Req;
                                                             
endmodule