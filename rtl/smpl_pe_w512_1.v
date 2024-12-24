module smpl_pe_w512_1(
    input              [ 511: 0]        Req                        ,
    output             [ 511: 0]        Gnt                        ,
    output                              valid                       
);

  assign valid = |Req;
  wire [511:0]   pre_req;   
 
  assign pre_req[0] = 1'b0; 
  assign pre_req[511:1] = Req[510:0] | pre_req[510:0];
  assign Gnt = Req & ~pre_req;
 
endmodule

