module top (
    input sys_clk,
    input sys_reset,
    input [3:0] key,

    output [5:0] led,  

    // output signals
    output       tmds_clk_n_tx,
	output       tmds_clk_p_tx,
	output [2:0] tmds_d_n_tx,
	output [2:0] tmds_d_p_tx,

    
    output       tmds_clk_n_rx,
	output       tmds_clk_p_rx,
	output [2:0] tmds_d_n_rx,
	output [2:0] tmds_d_p_rx

);

led led_inst(
    .clk(sys_clk),
    .led(led),
    .rst_n(!sys_reset)
);

// HDMI domain clocks
logic[2:0] tmds_tx;
logic[2:0] tmds_rx;
wire clk_pixel_tx;
wire clk_pixel_rx;
wire clk_pixel_x5_tx;
wire clk_pixel_x5_rx;
wire clk_audio;
wire pll_lock;

//logic reset;

Gowin_PLL u_pll(
        .lock(pll_lock), //output lock
        .clkout0(), //output clkout1  1920*1080  5xpixelclock: 742.5 Mhz     pixelclock: 148.5 Mhz
        .clkout1(clk_pixel_x5_rx), //output clkout0  1280*720   5xpixelclock: 371.25 Mhz    pixelclock: 74.25 Mhz
        .clkout2(clk_pixel_x5_tx), //output clkout2  640*480    5xpixelclock: 125.875 Mhz   pixelclock: 25.175 Mhz
        .clkout6(clk_audio),       //output clkout6  100Mhz
        .clkin(sys_clk) //input clkin 50Mhz
    );


Gowin_CLKDIV u_div_5_tx(
        .clkout(clk_pixel_tx), //output clkout
        .hclkin(clk_pixel_x5_tx), //input hclkin
        .resetn(~sys_reset & pll_lock) //input resetn
    );


Gowin_CLKDIV u_div_5_rx(
        .clkout(clk_pixel_rx), //output clkout
        .hclkin(clk_pixel_x5_rx), //input hclkin
        .resetn(~sys_reset & pll_lock) //input resetn
    );


logic [15:0] audio_sample_word [1:0] = '{16'h1111, 16'haaaa};

//Audio Test Data
always @(posedge clk_audio)
 //audio_sample_word <= {16'haaaa,16'haaaa};
  audio_sample_word <= '{audio_sample_word[1] + 16'h1111, audio_sample_word[0] - 16'h1111};



logic [9:0] cx_tx, cy_tx, screen_start_x_tx, screen_start_y_tx, frame_width_tx, frame_height_tx, screen_width_tx, screen_height_tx;
logic [9:0] cx_rx, cy_rx, screen_start_x_rx, screen_start_y_rx, frame_width_rx, frame_height_rx, screen_width_rx, screen_height_rx;

//for game_boy
wire graph_on; 
wire [2:0] menu_rgb;       //颜色
wire [2:0] game_rgb;       //颜色
wire[1:0]btn ;//= 2'b11;   //按钮
wire[1:0]sw ;//= 2'b11;  //拨码开关
wire str  = 1'b1;       //游戏控制
wire game_start = 1'b1;             //GameUI flag 
game_process2 graph_unit(.clk(clk_pixel_tx), .enable(game_start),.reset(~sys_reset),.pix_x(cx_tx), .pix_y(cy_tx), .btn(btn),.sw(sw),.str(str),.graph_on(graph_on), .graph_rgb(game_rgb));
game_process2 graph_unit_rx(.clk(clk_pixel_rx), .enable(game_start),.reset(~sys_reset),.pix_x(cx_rx), .pix_y(cy_rx), .btn(btn),.sw(sw),.str(str),.graph_on(graph_on), .graph_rgb(menu_rgb));


logic [23:0] rgb_tx = 24'hffffff;   // R G B
logic [23:0] rgb_rx = 24'hff0000;   //24'hffffff;   // R G B

//Video Test Pattern
// Border test (left = red, top = green, right = blue, bottom = blue, fill = black)
always @(posedge clk_pixel_tx) begin
//  rgb_tx <= {cx_tx == 0 ? ~8'd0 : 8'd0, cy_tx == 0 ? ~8'd0 : 8'd0, cx_tx == screen_width_tx - 1'd1 || cy_tx == screen_width_tx - 1'd1 ? ~8'd0 : 8'd0};

  if(~game_start) begin
    if (cy_tx < screen_height_tx/3 )
       rgb_tx = 24'hff0000;
    else if (cy_tx < screen_height_tx/3*2 )
       rgb_tx = 24'h00ff00;
    else
       rgb_tx = 24'h0000ff; 
  end else begin 
    case(game_rgb)
        3'b111:
            rgb_tx = 24'hffffff;
        3'b110:
            rgb_tx = 24'hffff00;
        3'b101:
            rgb_tx = 24'hff00ff;
        3'b100:
            rgb_tx = 24'hff0000;
        3'b011:
            rgb_tx = 24'h00ffff;
        3'b010:
            rgb_tx = 24'h00ff00;
        3'b001:
            rgb_tx = 24'h0000ff;
        3'b000:
            rgb_tx = 24'h000000;
    endcase
  end
end



always @(posedge clk_pixel_rx) begin

    if(~game_start) begin
        if (cy_rx < screen_height_rx/3 )
           rgb_rx = 24'hff0000;
        else if (cy_rx < screen_height_rx/3*2 )
           rgb_rx = 24'h00ff00;
        else
           rgb_rx = 24'h0000ff; 
    end else begin 
        case(menu_rgb)
            3'b111:
                rgb_rx = 24'hffffff;
            3'b110:
                rgb_rx = 24'hffff00;
            3'b101:
                rgb_rx = 24'hff00ff;
            3'b100:
                rgb_rx = 24'hff0000;
            3'b011:
                rgb_rx = 24'h00ffff;
            3'b010:
                rgb_rx = 24'h00ff00;
            3'b001:
                rgb_rx = 24'h0000ff;
            3'b000:
                rgb_rx = 24'h000000;
        endcase
  end
 end


// 640x480@59.94Hz       1
// 1280x720@59.94Hz      4
// 1920x1080@60Hz       16
// 3840x2160@60Hz       97


//6'b000_000          None
//6'b000_001          ALLM
//6'b000_010          DV
//6'b000_100          DVGame
//6'b001_000          VRR
//6'b010_000          Freesync
//6'b100_000          HDR10
hdmi #(.VIDEO_ID_CODE(1), .VIDEO_REFRESH_RATE(59.94), .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16), .HDMI_PKT(6'b111111)) hdmi_tx(
  .clk_pixel_x5(clk_pixel_x5_tx),
  .clk_pixel(clk_pixel_tx),
  .clk_audio(clk_audio),
  .reset(sys_reset),
  .rgb(rgb_tx),
  .audio_sample_word(audio_sample_word),
  .tmds(tmds_tx),
  .tmds_clock(tmds_clock_tx),
  .cx(cx_tx),
  .cy(cy_tx),
  .frame_width(frame_width_tx),
  .frame_height(frame_height_tx),
  .screen_width(screen_width_tx),
  .screen_height(screen_height_tx)
);

hdmi #(.VIDEO_ID_CODE(4), .VIDEO_REFRESH_RATE(59.94), .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16)) hdmi_rx(
  .clk_pixel_x5(clk_pixel_x5_rx),
  .clk_pixel(clk_pixel_rx),
  .clk_audio(clk_audio),
  .reset(sys_reset),
  .rgb(rgb_rx),
  .audio_sample_word(audio_sample_word),
  .tmds(tmds_rx),
  .tmds_clock(tmds_clock_rx),
  .cx(cx_rx),
  .cy(cy_rx),
  .frame_width(frame_width_rx),
  .frame_height(frame_height_rx),
  .screen_width(screen_width_rx),
  .screen_height(screen_height_rx)
);





//SerDes_Top your_instance_name(
//    .Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o(Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o_o), //output Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o
//    .Customized_PHY_Top_q0_ln0_rx_data_o(Customized_PHY_Top_q0_ln0_rx_data_o_o), //output [87:0] Customized_PHY_Top_q0_ln0_rx_data_o
//    .Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o(Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o_o), //output [4:0] Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o
//    .Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o(Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o_o), //output Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o
//    .Customized_PHY_Top_q0_ln0_rx_fifo_empty_o(Customized_PHY_Top_q0_ln0_rx_fifo_empty_o_o), //output Customized_PHY_Top_q0_ln0_rx_fifo_empty_o
//    .Customized_PHY_Top_q0_ln0_rx_valid_o(Customized_PHY_Top_q0_ln0_rx_valid_o_o), //output Customized_PHY_Top_q0_ln0_rx_valid_o
//    .Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o(Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o_o), //output Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o
//    .Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o(Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o_o), //output [4:0] Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o
//    .Customized_PHY_Top_q0_ln0_tx_fifo_afull_o(Customized_PHY_Top_q0_ln0_tx_fifo_afull_o_o), //output Customized_PHY_Top_q0_ln0_tx_fifo_afull_o
//    .Customized_PHY_Top_q0_ln0_tx_fifo_full_o(Customized_PHY_Top_q0_ln0_tx_fifo_full_o_o), //output Customized_PHY_Top_q0_ln0_tx_fifo_full_o
//    .Customized_PHY_Top_q0_ln0_refclk_o(Customized_PHY_Top_q0_ln0_refclk_o_o), //output Customized_PHY_Top_q0_ln0_refclk_o
//    .Customized_PHY_Top_q0_ln0_signal_detect_o(Customized_PHY_Top_q0_ln0_signal_detect_o_o), //output Customized_PHY_Top_q0_ln0_signal_detect_o
//    .Customized_PHY_Top_q0_ln0_rx_cdr_lock_o(Customized_PHY_Top_q0_ln0_rx_cdr_lock_o_o), //output Customized_PHY_Top_q0_ln0_rx_cdr_lock_o
//    .Customized_PHY_Top_q0_ln0_pll_lock_o(Customized_PHY_Top_q0_ln0_pll_lock_o_o), //output Customized_PHY_Top_q0_ln0_pll_lock_o
//    .Customized_PHY_Top_q0_ln0_rx_clk_i(Customized_PHY_Top_q0_ln0_rx_clk_i_i), //input Customized_PHY_Top_q0_ln0_rx_clk_i
//    .Customized_PHY_Top_q0_ln0_rx_fifo_rden_i(Customized_PHY_Top_q0_ln0_rx_fifo_rden_i_i), //input Customized_PHY_Top_q0_ln0_rx_fifo_rden_i
//    .Customized_PHY_Top_q0_ln0_tx_clk_i(Customized_PHY_Top_q0_ln0_tx_clk_i_i), //input Customized_PHY_Top_q0_ln0_tx_clk_i
//    .Customized_PHY_Top_q0_ln0_tx_data_i(Customized_PHY_Top_q0_ln0_tx_data_i_i), //input [79:0] Customized_PHY_Top_q0_ln0_tx_data_i
//    .Customized_PHY_Top_q0_ln0_tx_fifo_wren_i(Customized_PHY_Top_q0_ln0_tx_fifo_wren_i_i), //input Customized_PHY_Top_q0_ln0_tx_fifo_wren_i
//    .Customized_PHY_Top_q0_ln0_pma_rstn_i(Customized_PHY_Top_q0_ln0_pma_rstn_i_i), //input Customized_PHY_Top_q0_ln0_pma_rstn_i
//    .Customized_PHY_Top_q0_ln0_pcs_rx_rst_i(Customized_PHY_Top_q0_ln0_pcs_rx_rst_i_i), //input Customized_PHY_Top_q0_ln0_pcs_rx_rst_i
//    .Customized_PHY_Top_q0_ln0_pcs_tx_rst_i(Customized_PHY_Top_q0_ln0_pcs_tx_rst_i_i) //input Customized_PHY_Top_q0_ln0_pcs_tx_rst_i
//);


////     Gowin LVDS output buffer
    ELVDS_OBUF tmds_bufds_tx [3:0] (
        .I({clk_pixel_tx, tmds_tx}),
        .O({tmds_clk_p_tx, tmds_d_p_tx}),
        .OB({tmds_clk_n_tx, tmds_d_n_tx})
    );

   ELVDS_OBUF tmds_bufds_rx [3:0] (
        .I({clk_pixel_rx, tmds_rx}),
        .O({tmds_clk_p_rx, tmds_d_p_rx}),
        .OB({tmds_clk_n_rx, tmds_d_n_rx})
    );

endmodule
