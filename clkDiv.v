module clkDiv(
    input clk100mhz,
    output clk190hz,
    output clk6hz,
    output clk1mhz
);
reg [26:0] count=0;
assign clk190hz=count[18];
assign clk6hz = count[23];
assign clk1mhz = count[3];
always @(posedge clk100mhz)
    count<=count+1;
endmodule