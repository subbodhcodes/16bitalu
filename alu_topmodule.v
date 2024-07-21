module ALU_top_module (
    input [15:0] DIN,
    input clk, rstn, run,
    output reg done,
    output reg [15:0] G
);
    reg [15:0] IR, R0, R1;
    reg [7:0] A;
    reg [1:0] ns, cs;
    reg IRin, G_in, and_en, or_en, nand_en, xor_en, xnor_en, nor_en, not_en, left_shift_en, right_shift_en, incrementer_enable, decrementer_enable, adder_en, subtracter_en, multiplier_en, division_en;

    wire [15:0] G0, G1, G2, G3, G4, G5, G6, G7, G8, G9, G10, G11, G12, G13, G14;

    parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b11;
    parameter I0 = 4'd0, I1 = 4'd1, I2 = 4'd2, I3 = 4'd3, I4 = 4'd4, I5 = 4'd5, I6 = 4'd6, I7 = 4'd7, I8 = 4'd8, I9 = 4'd9, I10 = 4'd10, I11 = 4'd11, I12 = 4'd12, I13 = 4'd13, I14= 4'd14, I15 = 4'd15;
    //parameter K0 = 3'd0, K1 = 3'd1, K2 = 3'd2, K3 = 3'd3, K4  = 3'd4, K5  = 3'd5, K6 = 3'd6, K7 = 3'd7;

    wire [3:0] IIII;
    wire Rx;
    wire [7:0] Dy;
    wire [2:0]mov_inter;

    assign IIII = IR[15:12];
    assign Rx = IR[8];
    assign Dy = IR[7:0];
    assign mov_inter = IR[11:9];
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ns <= 0;
            cs <= 0;
            IR <= 0;
            R0 <= 0;
            R1 <= 0;
            IRin <= 0;
            and_en <=0;
            or_en <=0;
            nand_en <=0; 
            xor_en <=0; 
            xnor_en <=0; 
            nor_en <=0;
            not_en <=0;
            left_shift_en <=0;
            right_shift_en <= 0;
            incrementer_enable <= 0;
            decrementer_enable <= 0;
            adder_en <= 0;
            subtracter_en <= 0;
            division_en <= 0;
            multiplier_en <= 0;
            done <= 0;
            
        end
        else begin
            cs <= ns;
        end
    end

    always @(*) begin
        case (cs)
            T0: begin
                and_en <=0;
                or_en <=0;
                nand_en <=0; 
                xor_en <=0; 
                xnor_en <=0; 
                nor_en <=0;
                not_en <=0;
                left_shift_en <= 0;
                right_shift_en <= 0;
                incrementer_enable <=0;
                decrementer_enable <= 0;
                adder_en <= 0;
                subtracter_en <= 0;
                multiplier_en <= 0;
                division_en <= 0;
                G_in = 0;
                if (!run) begin
                    ns = T0;
                end
                else begin
                    IRin = 1;
                    ns = T1;
                end
            end
            T1: begin
                if (IIII == I0) begin
                    case (Rx)
                        0: R0 = Dy;
                        1: R1 = Dy;
                        default: ;
                    endcase
                    ns = T0;
                    done = 1;
                end
                else begin
                    case (Rx)
                        0: A = R0;
                        1: A = R1;
                    endcase
                    ns = T2;
                end
            end
            T2: begin
                case (IIII)
                    I1: and_en = 1;
                    I2: or_en = 1;
                    I3: nand_en = 1;
                    I4: xor_en = 1;
                    I5: xnor_en = 1;
                    I6: nor_en = 1;
                    I7: not_en = 1;
                    I8: left_shift_en = 1;
                    I9: right_shift_en = 1;
                    I10: incrementer_enable = 1;
                    I11: decrementer_enable = 1;
                    I12: adder_en = 1;
                    I13: subtracter_en = 1;
                    I14: multiplier_en = 1;
                    I15: division_en = 1;
                    default: ;
                endcase
                ns = T0;
                G_in = 1;
            end
        endcase
    end

    always @(posedge clk) begin
        if (IRin) begin
            IR <= DIN;
        end
        if (G_in) begin
            //G <= G0 | G1 | G2 | G3 | G4 | G5 | G6 | G7 | G8 | G9 | G10 | G11 | G12 | G13 | G14;
            if (cs == T2 & multiplier_en==1)
            G = G13;
            if (cs == T2 & division_en==1)
            G = G14; 
            if (cs == T2 & adder_en==1)
            G = G11;
            if (cs == T2 & subtracter_en==1)
            G = G12;
            if (cs == T2 & and_en==1)
            G = G0;
            if (cs == T2 & or_en==1)
            G = G1;  
            if (cs == T2 & nand_en==1)
            G = G2;
            if (cs == T2 & xor_en==1)
            G = G3;
            if (cs == T2 & xnor_en==1)
            G = G4;
            if (cs == T2 & nor_en==1)
            G = G5;
            if (cs == T2 & not_en==1)
            G = G6;
            if (cs == T2 & left_shift_en==1)
            G = G7;
            if (cs == T2 & right_shift_en==1)
            G = G8;
            if (cs == T2 & incrementer_enable==1)
            G = G9;
            if (cs == T2 & decrementer_enable==1)
            G = G10;
        end
    end

    and_gate a1 (.a(A), .b(Dy), .enable(and_en), .out(G0));
    or_gate a2 (.a(A), .b(Dy), .enable(or_en), .out(G1));
    nand_gate a3 (.a(A), .b(Dy), .enable(nand_en), .out(G2));
    xor_gate a4 (.a(A), .b(Dy), .enable(xor_en), .out(G3));
    xnor_gate a5 (.a(A), .b(Dy), .enable(xnor_en), .out(G4));
    nor_gate a6 (.a(A), .b(Dy), .enable(nor_en), .out(G5));
    not_gate a7 (.b(A), .a(Dy), .enable(not_en), .out(G6));
    left_shift a8(.b(A),.a(Dy), .enable(left_shift_en), .shift_amount(mov_inter) ,.out(G7));
    right_shift a9(.b(A),.a(Dy),.enable(right_shift_en),.shift_amount(mov_inter),.out(G8));
    incrementer a10(.a(A),.b(Dy),.enable(incrementer_enable),.out(G9));
    decrementer a11(.a(A),.b(Dy),.enable(decrementer_enable),.out(G10));
    adder a12(.a(A),.b(Dy),.enable(adder_en),.out(G11));
    subtracter a13(.a(A),.b(Dy),.enable(subtracter_en),.out(G12));
    booth_new a14(.A(A),.B(Dy),.enable(multiplier_en),.Z(G13));
    division a15 (.a(A),.b(Dy),.enable(division_en),.out(G14));
endmodule








//And Gate
module and_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
input enable;
reg [15:0]out;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, a & b};
    end
end
endmodule


//Or gate
module or_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, a | b};
    end
end
endmodule


//Nand gate
module nand_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, ~(a & b)};
    end
end
endmodule


//Xor gate
module xor_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, a ^ b};
    end
end
endmodule


//Xnor Gate
module xnor_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, ~(a ^ b)};
    end
end
endmodule


//Nor Gate
module nor_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out <= {8'b0, ~(a | b)};
    end
end
endmodule


//Not gate
module not_gate(a,b,enable,out);
input [7:0]a,b;
output [15:0]out;
reg [15:0]out;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out = ~a;
        //b = 8'b0;
    end
end
endmodule


module left_shift(a,b,enable,out,shift_amount);
input [7:0]a,b;
output [15:0]out;
input enable;
input [2:0]shift_amount;
reg [15:0]out;
reg [7:0]int_out1, int_out2;
integer i = 0;
always @(*)begin
    if(enable)begin
        for(i=0;i<shift_amount+1;i=i+1) begin
            int_out1 = a << i;
            int_out2 = b << i;
        end
        out = {int_out1, int_out2};
    end
    else begin
        out = 16'b0;
    end
end
endmodule

module right_shift(a,b,enable,out,shift_amount);
input [7:0]a,b;
output [15:0]out;
input enable;
input [2:0]shift_amount;
reg [15:0]out;
reg [7:0]int_out1,int_out2;
integer i = 0;
always @(*)begin
    if(enable)begin
        for(i=0;i<shift_amount+1;i=i+1) begin
            int_out1 = a >> i;
            int_out2 = b >> i;
        end
        out = {int_out1, int_out2};
    end
    else begin
        out = 16'b0;
    end
end
endmodule

module incrementer(a,b,enable,out);
input [7:0]a,b;
output reg [15:0]out;
reg [7:0]out1;
reg [7:0]out2;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out1 = a + 1;
        out2 = b + 1;
        out = {out1, out2};
    end
end
endmodule

module decrementer(a,b,enable,out);
input [7:0]a,b;
output reg [15:0]out;
reg [7:0]out1;
reg [7:0]out2;
input enable;
initial out = 16'b0;
always @(*)begin
    if(enable)begin
        out1 = a - 1;
        out2 = b - 1;
        out = {out1, out2};
    end
end
endmodule


module adder(a,b,enable,out);
input [7:0]a,b;
input enable;
output [15:0]out;
reg [15:0]out;
initial out = 16'b0;
always@(*)begin
    if(enable) begin
        out = {8'b0, a + b};
    end
end
endmodule


module subtracter(a,b,enable,out);
input [7:0]a,b;
input enable;
output [15:0]out;
reg [15:0]out;
initial out = 16'b0;
always@(*)begin
    if(enable) begin
        out = {8'b0, a - b};
    end
end
endmodule


module booth_new(
    input signed [7:0] A,  
    input signed [7:0] B,   
    input enable, 
    output reg signed [15:0] Z    
);

reg signed [16:0] P;
reg signed [8:0] M, M_neg;
reg [8:0] Q; 
integer i;
initial Z = 16'b0;
    always @(*) begin
        if(enable)begin
            M = {A[7], A};
            M_neg = -M; 
            Q = {B, 1'b0}; 
            P = 17'b0;
            for (i = 0; i < 8; i = i + 1) begin
                case (Q[1:0])
                    2'b10: P = P + {M_neg, 8'b0};
                    2'b01: P = P + {M, 8'b0}; 
                endcase
                P = P >>> 1; 
                Q = Q >> 1;
            end
        end
        Z = P[15:0]; 
    end
endmodule


module division(a,b,enable,out);
input [7:0]a,b;
input enable;
output [15:0]out;
reg [15:0]out;
initial out = 16'b0;
always@(*)begin
    if(enable) begin
        out = {8'b0, a / b};
    end
end
endmodule


