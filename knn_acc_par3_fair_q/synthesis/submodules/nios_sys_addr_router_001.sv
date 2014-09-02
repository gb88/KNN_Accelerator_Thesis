// (C) 2001-2012 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/12.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2012/08/12 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module nios_sys_addr_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 5,
               DEFAULT_DESTID = 5 
   )
  (output [92 - 88 : 0] default_destination_id,
   output [23-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[92 - 88 : 0];
  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1)
      assign default_src_channel = '0;
    else
      assign default_src_channel = 23'b1 << DEFAULT_CHANNEL;
  end
  endgenerate

endmodule


module nios_sys_addr_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [103-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [103-1    : 0] src_data,
    output reg [23-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 61;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 92;
    localparam PKT_DEST_ID_L = 88;
    localparam ST_DATA_W = 103;
    localparam ST_CHANNEL_W = 23;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 64;
    localparam PKT_TRANS_READ  = 65;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;




    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h2000000 - 64'h0);
    localparam PAD1 = log2ceil(64'h2008000 - 64'h2004000);
    localparam PAD2 = log2ceil(64'h2008080 - 64'h2008000);
    localparam PAD3 = log2ceil(64'h20080c0 - 64'h2008080);
    localparam PAD4 = log2ceil(64'h2008100 - 64'h20080e0);
    localparam PAD5 = log2ceil(64'h2008110 - 64'h2008100);
    localparam PAD6 = log2ceil(64'h2008120 - 64'h2008110);
    localparam PAD7 = log2ceil(64'h2008130 - 64'h2008120);
    localparam PAD8 = log2ceil(64'h2008140 - 64'h2008130);
    localparam PAD9 = log2ceil(64'h2008150 - 64'h2008140);
    localparam PAD10 = log2ceil(64'h2008160 - 64'h2008150);
    localparam PAD11 = log2ceil(64'h2008170 - 64'h2008160);
    localparam PAD12 = log2ceil(64'h2008180 - 64'h2008170);
    localparam PAD13 = log2ceil(64'h2008190 - 64'h2008180);
    localparam PAD14 = log2ceil(64'h20081a0 - 64'h2008190);
    localparam PAD15 = log2ceil(64'h20081b0 - 64'h20081a0);
    localparam PAD16 = log2ceil(64'h20081c0 - 64'h20081b0);
    localparam PAD17 = log2ceil(64'h20081d0 - 64'h20081c0);
    localparam PAD18 = log2ceil(64'h20081e0 - 64'h20081d0);
    localparam PAD19 = log2ceil(64'h20081f0 - 64'h20081e0);
    localparam PAD20 = log2ceil(64'h2008200 - 64'h20081f0);
    localparam PAD21 = log2ceil(64'h2008208 - 64'h2008200);
    localparam PAD22 = log2ceil(64'h2008210 - 64'h2008208);
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h2008210;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;
    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [23-1 : 0] default_src_channel;




    nios_sys_addr_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_src_channel (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;

        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;
        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

        // ( 0x0 .. 0x2000000 )
        if ( {address[RG:PAD0],{PAD0{1'b0}}} == 26'h0 ) begin
            src_channel = 23'b00000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
        end

        // ( 0x2004000 .. 0x2008000 )
        if ( {address[RG:PAD1],{PAD1{1'b0}}} == 26'h2004000 ) begin
            src_channel = 23'b00000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
        end

        // ( 0x2008000 .. 0x2008080 )
        if ( {address[RG:PAD2],{PAD2{1'b0}}} == 26'h2008000 ) begin
            src_channel = 23'b00001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
        end

        // ( 0x2008080 .. 0x20080c0 )
        if ( {address[RG:PAD3],{PAD3{1'b0}}} == 26'h2008080 ) begin
            src_channel = 23'b00000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
        end

        // ( 0x20080e0 .. 0x2008100 )
        if ( {address[RG:PAD4],{PAD4{1'b0}}} == 26'h20080e0 ) begin
            src_channel = 23'b00000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
        end

        // ( 0x2008100 .. 0x2008110 )
        if ( {address[RG:PAD5],{PAD5{1'b0}}} == 26'h2008100 ) begin
            src_channel = 23'b10000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
        end

        // ( 0x2008110 .. 0x2008120 )
        if ( {address[RG:PAD6],{PAD6{1'b0}}} == 26'h2008110 ) begin
            src_channel = 23'b01000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
        end

        // ( 0x2008120 .. 0x2008130 )
        if ( {address[RG:PAD7],{PAD7{1'b0}}} == 26'h2008120 ) begin
            src_channel = 23'b00100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
        end

        // ( 0x2008130 .. 0x2008140 )
        if ( {address[RG:PAD8],{PAD8{1'b0}}} == 26'h2008130 ) begin
            src_channel = 23'b00010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
        end

        // ( 0x2008140 .. 0x2008150 )
        if ( {address[RG:PAD9],{PAD9{1'b0}}} == 26'h2008140 ) begin
            src_channel = 23'b00000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
        end

        // ( 0x2008150 .. 0x2008160 )
        if ( {address[RG:PAD10],{PAD10{1'b0}}} == 26'h2008150 ) begin
            src_channel = 23'b00000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
        end

        // ( 0x2008160 .. 0x2008170 )
        if ( {address[RG:PAD11],{PAD11{1'b0}}} == 26'h2008160 ) begin
            src_channel = 23'b00000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
        end

        // ( 0x2008170 .. 0x2008180 )
        if ( {address[RG:PAD12],{PAD12{1'b0}}} == 26'h2008170 ) begin
            src_channel = 23'b00000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
        end

        // ( 0x2008180 .. 0x2008190 )
        if ( {address[RG:PAD13],{PAD13{1'b0}}} == 26'h2008180 ) begin
            src_channel = 23'b00000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
        end

        // ( 0x2008190 .. 0x20081a0 )
        if ( {address[RG:PAD14],{PAD14{1'b0}}} == 26'h2008190 ) begin
            src_channel = 23'b00000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
        end

        // ( 0x20081a0 .. 0x20081b0 )
        if ( {address[RG:PAD15],{PAD15{1'b0}}} == 26'h20081a0 ) begin
            src_channel = 23'b00000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
        end

        // ( 0x20081b0 .. 0x20081c0 )
        if ( {address[RG:PAD16],{PAD16{1'b0}}} == 26'h20081b0 ) begin
            src_channel = 23'b00000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
        end

        // ( 0x20081c0 .. 0x20081d0 )
        if ( {address[RG:PAD17],{PAD17{1'b0}}} == 26'h20081c0 ) begin
            src_channel = 23'b00000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
        end

        // ( 0x20081d0 .. 0x20081e0 )
        if ( {address[RG:PAD18],{PAD18{1'b0}}} == 26'h20081d0 ) begin
            src_channel = 23'b00000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
        end

        // ( 0x20081e0 .. 0x20081f0 )
        if ( {address[RG:PAD19],{PAD19{1'b0}}} == 26'h20081e0 ) begin
            src_channel = 23'b00000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
        end

        // ( 0x20081f0 .. 0x2008200 )
        if ( {address[RG:PAD20],{PAD20{1'b0}}} == 26'h20081f0 ) begin
            src_channel = 23'b00000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
        end

        // ( 0x2008200 .. 0x2008208 )
        if ( {address[RG:PAD21],{PAD21{1'b0}}} == 26'h2008200 ) begin
            src_channel = 23'b00000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
        end

        // ( 0x2008208 .. 0x2008210 )
        if ( {address[RG:PAD22],{PAD22{1'b0}}} == 26'h2008208 ) begin
            src_channel = 23'b00000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
        end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


