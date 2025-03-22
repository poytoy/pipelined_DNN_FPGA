`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: © 2019, Chris Larsen
// Engineer: Chris Larsen
// 
// Create Date: 07/26/2019 07:05:10 PM
// Design Name: Half Precision Floating Point Multiplier
// Module Name: hp_mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module hp_class(f, fExp, fSig, isSnan, isQnan, isInfinity, isZero, isSubnormal,
isNormal);
input [15:0] f;
output signed [6:0] fExp;
reg signed [6:0] fExp;
output [10:0] fSig;
reg [10:0] fSig;
output isSnan, isQnan, isInfinity, isZero, isSubnormal, isNormal;

wire expOnes, expZeroes, sigZeroes;

assign expOnes   =  &f[14:10];
assign expZeroes = ~|f[14:10];
assign sigZeroes = ~|f[9:0];

assign isSnan      =  expOnes   & ~sigZeroes & ~f[9];
assign isQnan      =  expOnes                &  f[9];
assign isInfinity  =  expOnes   &  sigZeroes;
assign isZero      =  expZeroes &  sigZeroes;
assign isSubnormal =  expZeroes & ~sigZeroes;
assign isNormal    = ~expOnes   & ~expZeroes;

reg [10:0] mask = ~0;
reg [3:0] sa;

integer i;

always @(*)
begin
// Use actual exponent/significand values for sNaNs, qNaNs,
// infinities, and zeroes.
fExp = f[14:10];
fSig = f[9:0];

sa = 0;

if (isNormal)
{fExp, fSig} = {f[14:10] - 5'd15, 1'b1, f[9:0]};
else if (isSubnormal)
begin
// Shift the most significant bit into the position
// of the Normal's implied 1. Keep track of how many
// places were needed to shift the most significant
// set bit so we can adjust the exponent when we're
// done.
for (i = 8; i > 0; i = i >> 1)
begin
if ((fSig & (mask << (11 - i))) == 0)
begin
 fSig = fSig << i;
 sa = sa | i;
end
end

fExp = -14 - sa; // "-14" is the smallest Normal exponent
          // as a signed value.
end
end

endmodule
module hp_mul(a, b, p);
  input [15:0] a, b;
  output [15:0] p;
  reg snan, qnan, infinity, zero, subnormal, normal;
    
  wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal;
  wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal;

  wire signed [6:0] aExp, bExp;
  reg signed [6:0] pExp, t1Exp, t2Exp;
  wire [10:0] aSig, bSig;
  reg [10:0] pSig, tSig;

  reg [15:0] pTmp;
  
  wire [21:0] rawSignificand;
  
  reg pSign;
  
  hp_class aClass(a, aExp, aSig, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal);
  hp_class bClass(b, bExp, bSig, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal);
  
  assign rawSignificand = aSig * bSig;

  always @(*)
  begin
    // IEEE 754-2019, section 6.3 requires that when "[w]hen
    // neither the inputs nor result are NaN, the sign of a product
    // ... is the exclusive OR of the operands' signs".
    pSign = a[15] ^ b[15];
    pTmp = {pSign, {5{1'b1}}, 1'b0, {9{1'b1}}};  // Initialize p to be an sNaN.
    {snan, qnan, infinity, zero, subnormal, normal} = 6'b000000;
    
    if ((aSnan | bSnan) == 1'b1)
      begin
        pTmp = aSnan == 1'b1 ? a : b;
        snan = 1;
      end
    else if ((aQnan | bQnan) == 1'b1)
      begin
        pTmp = aQnan == 1'b1 ? a : b;
        qnan = 1;
      end
    else if ((aInfinity | bInfinity) == 1'b1)
      begin
        if ((aZero | bZero) == 1'b1)
          begin
            pTmp = {pSign, {5{1'b1}}, 1'b1, 9'h2A}; // qNaN
            qnan = 1;
          end
        else
          begin
            pTmp = {pSign, {5{1'b1}}, {10{1'b0}}};
            infinity = 1;
          end
      end
    else if ((aZero | bZero) == 1'b1 ||
             (aSubnormal & bSubnormal) == 1'b1)
      begin
        pTmp = {pSign, {15{1'b0}}};
        zero = 1;
      end
    else    // At least one of the operands is Normal.
      begin // The other may be Subnormal or Normal.
        t1Exp = aExp + bExp;

        if (rawSignificand[21] == 1'b1)
          begin
            tSig = rawSignificand[21:11];
            t2Exp = t1Exp + 1;
          end
        else
          begin
            tSig = rawSignificand[20:10];
            t2Exp = t1Exp;
          end

        if (t2Exp < -24) // Too small to even be represented as
          begin          // a Subnormal; round down to Zero.
            pTmp = {pSign, {15{1'b0}}};
            zero = 1;
          end
        else if (t2Exp < -14) // Subnormal
          begin
            pSig = tSig >> (-14 - t2Exp);
            // Remember that we can only store 10 bits
            pTmp = {pSign, {5{1'b0}}, pSig[9:0]};
            subnormal = 1;
          end 
        else if (t2Exp > 15) // Infinity
          begin
            pTmp = {pSign, {5{1'b1}}, {10{1'b0}}};
            infinity = 1;
          end
        else // Normal
          begin
            pExp = t2Exp + 15;
            pSig = tSig;
            // Remember that for Normals we always assume the most
            // significant bit is 1 so we only store the least
            // significant 10 bits in the significand.
            pTmp = {pSign, pExp[4:0], pSig[9:0]};
            normal = 1;
          end
      end //
  end
  
  assign p = pTmp;
    
endmodule