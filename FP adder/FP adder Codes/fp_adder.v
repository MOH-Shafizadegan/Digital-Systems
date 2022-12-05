`timescale 1ns/1ns
module fp_adder (
    input [31:0] a,
    input [31:0] b,
    output [31:0] s
);

//---------------   declaring wires     -----------------------
wire [7:0] exp_a;
wire [24:0] frac_a;
wire [25:0] mantiss_a;
wire [7:0] exp_b;
wire [24:0] frac_b;
wire [25:0] mantiss_b;
wire [25:0] mantissa_bigger, mantissa_smaller;
wire [7:0] exponent_bigger;
wire c_out, borrow;
wire [7:0] exp_sub;
wire [7:0] exp_diff;
wire [28:0] adder_in_left;
wire [28:0] adder_in_right;
wire [27:0] adder_output;
wire [27:0] adder_output_2;
wire [28:0] adder_sum;
wire [4:0] point_move;
wire [23:0] mantissa_1, mantissa_2;
wire [27:0] temp_1, temp_2;
wire [7:0] E;
wire [22:0] F;
wire sign;
wire [25:0] shift_reg_1, shift_reg_2;
wire [7:0] exponent_1, exponent_2;
wire [26:0] num_1, num_2;
wire sticky;
wire sign_bigger, sign_smaller;


//-------------------------------------------------------------

//---------------   assigning exponents     -------------------
assign exp_a = (a[30:23]==0) ? 8'h01 : a[30:23];
assign exp_b = (b[30:23]==0) ? 8'h01 : b[30:23];

//---------------   assigning Mantissa     -------------------
assign frac_a = {a[22:0], {2{1'b0}}};
assign frac_b = {b[22:0], {2{1'b0}}};
assign mantiss_a = (a[30:23]==0) ? {1'b0, frac_a} : {1'b1, frac_a};
assign mantiss_b = (b[30:23]==0) ? {1'b0, frac_b} : {1'b1, frac_b};

//--------------    expA ? expB     ---------------------------
assign {borrow, exp_diff} = exp_a + ~exp_b + 1;
assign exp_sub = borrow ? ~exp_diff + 1 : exp_diff;

//--------------    assigning Big adder inputs      ------------        

assign exponent_bigger = borrow ? exp_b : exp_a;
assign mantissa_bigger = borrow ? mantiss_b : mantiss_a;
assign mantissa_smaller = borrow ? mantiss_a : mantiss_b;

assign sign_bigger = borrow ? b[31] : a[31];
assign sign_smaller = borrow ? a[31] : b[31];

wire [51:0] ex_1, ex_2;
assign ex_1 = {mantissa_smaller, 26'b0000_0000_0000_0000_0000_0000_00};
assign ex_2 = !exp_sub ? ex_1 : ex_1 >> exp_sub;
assign shift_reg_1 = ex_2[51:26];
assign shift_reg_2 = ex_2[25:0];
assign sticky = (!exp_sub) ? 1'b0 : 
                (exp_sub < 26) ? |shift_reg_2 : |mantissa_smaller; // num_shift <= 26

assign num_1 = {mantissa_bigger, 1'b0};
assign num_2 = {shift_reg_1, sticky};

assign temp_1 = sign_bigger ? -{1'b0, num_1} : {1'b0, num_1};
assign temp_2 = sign_smaller ? -{1'b0, num_2} : {1'b0, num_2};

assign adder_in_left = {temp_1[27], temp_1};       // sign extension
assign adder_in_right = {temp_2[27], temp_2};

//--------------    assigning big adder output      ------------
assign adder_sum = adder_in_left + adder_in_right;
assign sign = adder_sum[28];

//--------------    extracting result parameters    ------------
assign adder_output = adder_sum[28] ? ~adder_sum[27:0] + 1 : adder_sum[27:0];

//-------------     Leading one detection   -------------------
assign point_move = adder_output[27] ? 27 :
                    adder_output[26] ? 26 :
                    adder_output[25] ? 25 :
                    adder_output[24] ? 24 :
                    adder_output[23] ? 23 :
                    adder_output[22] ? 22 :
                    adder_output[21] ? 21 :
                    adder_output[20] ? 20 :
                    adder_output[19] ? 19 :
                    adder_output[18] ? 18 :
                    adder_output[17] ? 17 :
                    adder_output[16] ? 16 :
                    adder_output[15] ? 15 :
                    adder_output[14] ? 14 :
                    adder_output[13] ? 13 :
                    adder_output[12] ? 12 :
                    adder_output[11] ? 11 :
                    adder_output[10] ? 10 :
                    adder_output[9]  ? 9 :
                    adder_output[8]  ? 8 :
                    adder_output[7]  ? 7 :
                    adder_output[6]  ? 6 :
                    adder_output[5]  ? 5 :
                    adder_output[4]  ? 4 :
                    adder_output[3]  ? 3 :
                    adder_output[2]  ? 2 :
                    adder_output[1]  ? 1 : 0;

//--------------     Normalizing result     -----------------
assign adder_output_2 = (point_move == 27) ? adder_output :
                                            (27-point_move < exponent_bigger) ? adder_output << (8'd27 - point_move) :
                                                                                    adder_output << exponent_bigger;
assign exponent_1 = (point_move==27) ? exponent_bigger+1 : 
       (27-point_move < exponent_bigger) ? exponent_bigger+point_move-26 : 1'b1;

wire st;
assign st = |adder_output_2[2:0]; 

assign mantissa_1 = !adder_output_2[3] ? adder_output_2[27:4] : 
                    st ? adder_output_2[27:4]+1 : 
                    adder_output_2[4] ? adder_output_2[27:4]+1 : adder_output_2[27:4];

// detect double rounding
assign mantissa_2 = (mantissa_1==0 && adder_output_2[3]) ? {1'b1, {23{1'b0}}} : mantissa_1;
assign exponent_2 = (mantissa_1==0 && adder_output_2[3]) ? exponent_1+1 : exponent_1;

assign E = mantissa_2[23] ? exponent_2 : 8'b0000_0000;
assign F = mantissa_2[22:0];

assign s = {sign, E, F};

endmodule