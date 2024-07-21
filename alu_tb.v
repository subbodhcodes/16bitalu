module ALU_top_module_tb;
    reg [15:0] DIN;
    reg clk, rstn, run;
    wire done;
    wire [15:0]G;

    always #10 clk = ~clk;

    ALU_top_module uut(.DIN(DIN), .clk(clk), .rstn(rstn), .run(run), .done(done),.G(G));

    initial begin
        clk = 0;
        rstn = 0;
        #20 rstn = 1; run = 1; DIN = 16'b0000000100000001;
        #20 run = 0;
        #20 ;
        #20 ;
        #20 run = 1; DIN = 16'b1110011100110011;
        #20 run = 0;
        #20 ;
        #20 ;
        #20 run = 1; DIN = 16'b1000000110000000;
        #20 run = 0;
        #20 ;
        #20 ;
        #20 run = 1; DIN = 16'b1100000101000000;
        #20 run = 0;
        #20 ;
        #20 ;
        #20 run = 1; DIN = 16'b0100000100000001;
        #20 run = 0;
        #20 ;
        #20 ;
        #20 run = 1; DIN = 16'b0010000100000011;
        #20 run = 0;
        #20 ;
        #20 ;
    end
endmodule 
