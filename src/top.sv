module top (
    input sys_clk,
    input sys_reset,

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
//480p pixel clock: 25.175 Mhz
//5x 480p pixel clock: 125.875 Mhz
wire clk_pixel_tx;  // 720p pixel clock: 74.25 Mhz
wire clk_pixel_rx;  // 1080p pixel clock: 148.5 Mhz
wire clk_pixel_x5_tx;  // 5x 720p pixel clock: 371.25 Mhz
wire clk_pixel_x5_rx;  // 5x 1080p pixel clock: 742.5 Mhz
wire pll_lock;

//logic reset;

Gowin_PLL u_pll(
        .lock(pll_lock), //output lock
        .clkout0(clk_pixel_x5_tx), //output clkout0  720P
        .clkout1(clk_pixel_x5_rx), //output clkout1  1080P
        .clkin(sys_clk) //input clkin
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


/********************************Test CLK Start****************************************/
//reg [32:0] cnt_clk;              
//reg [32:0] cnt_pixel;  
//reg [32:0] cnt_pixel5 = 0;              

//assign led[0] = (cnt_clk < 26'd500) ? 1'b1 : 1'b0;
//assign led[1] = (cnt_pixel < 26'd500) ? 1'b1 : 1'b0;
//assign led[2] = (cnt_pixel5 < 26'd500) ? 1'b0 : 1'b1;


//always @ (posedge sys_clk or negedge sys_reset) begin
//    if(!sys_reset)                  
//        cnt_clk <=26'd0;
//    else if(cnt_clk < 26'd1000)
//        cnt_clk <= cnt_clk + 1'b1;    
//    else
//        cnt_clk <= 26'd0;     
//end

//always @ (posedge clk_pixel or negedge sys_reset) begin
//    if(!sys_reset)                  
//        cnt_pixel <=26'd0;
//    else if(cnt_pixel < 26'd1000)
//        cnt_pixel <= cnt_pixel + 1'b1;      
//    else
//        cnt_pixel <= 26'd0;           
//end


//always @ (posedge clk_pixel_x5) begin
//    if(cnt_pixel5 < 26'd1000)
//        cnt_pixel5 <= cnt_pixel5 + 1'b1;      
//    else
//        cnt_pixel5 <= 26'd0;
//end
/********************************Test CLK End****************************************/

// audio stuff
logic [10:0] audio_divider_rx;
logic [10:0] audio_divider_tx;
logic clk_audio_rx;
logic clk_audio_tx;

localparam AUDIO_RATE=48000;
localparam CLKFRQ = 74250;

always_ff@(posedge clk_pixel_tx) 
begin
    if (audio_divider_tx != CLKFRQ * 1000 / AUDIO_RATE / 2 - 11'd1) 
        audio_divider_tx++; //generated from clk_pixel 27.0000MHz/281=48042,70Hz ; 27.0000MHz/306=44117,64Hz
    else begin 
        clk_audio_tx <= ~clk_audio_tx; 
        audio_divider_tx <= 0; 
    end
end

always_ff@(posedge clk_pixel_rx) 
begin
    if (audio_divider_rx != 148500 * 1000 / AUDIO_RATE / 2 - 11'd1) 
        audio_divider_rx++; //generated from clk_pixel 27.0000MHz/281=48042,70Hz ; 27.0000MHz/306=44117,64Hz
    else begin 
        clk_audio_rx <= ~clk_audio_rx; 
        audio_divider_rx <= 0; 
    end
end


logic [15:0] audio_sample_word [1:0] = '{16'h1111, 16'haaaa};

//Audio Test Data
//always @(posedge clk_audio)
// audio_sample_word <= {16'haaaa,16'haaaa};
//  audio_sample_word <= '{audio_sample_word[1] + 16'h1111, audio_sample_word[0] - 16'h1111};


/********************************Test CLK Start****************************************/
//reg [32:0] cnt_audio_clk;  

//assign led[3] = (cnt_audio_clk == 26'd0) ? 1'b0 : 1'b1;


//always @ (posedge clk_audio or negedge sys_reset) begin
//    if(!sys_reset)                  
//        cnt_audio_clk <=26'd0;
//    else if(cnt_audio_clk == 26'd0)
//        cnt_audio_clk <= cnt_audio_clk + 1'b1;    
//    else
//        cnt_audio_clk <= 26'd0;     
//end
/********************************Test CLK End****************************************/

logic [9:0] cx_tx, cy_tx, screen_start_x_tx, screen_start_y_tx, frame_width_tx, frame_height_tx, screen_width_tx, screen_height_tx;
logic [9:0] cx_rx, cy_rx, screen_start_x_rx, screen_start_y_rx, frame_width_rx, frame_height_rx, screen_width_rx, screen_height_rx;

//for game_boy
wire[1:0]btn ;//= 2'b11;   //按钮
wire[1:0]sw ;//= 2'b11;  //拨码开关
wire str  = 1'b1;       //游戏控制
wire game_start = 1'b1;             //GameUI flag 
game_process2 graph_unit(.clk(clk_pixel_tx), .enable(game_start),.reset(~sys_reset),.pix_x(cx_tx), .pix_y(cy_tx), .btn(btn),.sw(sw),.str(str),.graph_on(graph_on), .graph_rgb(game_rgb));


logic [23:0] rgb_tx = 24'hff0000;   //24'hffffff;   // R G B

//Video Test Pattern
// Border test (left = red, top = green, right = blue, bottom = blue, fill = black)
always @(posedge clk_pixel_tx) begin
//  rgb_tx <= {cx == 0 ? ~8'd0 : 8'd0, cy_tx == 0 ? ~8'd0 : 8'd0, cx == screen_width - 1'd1 || cy_tx == screen_width - 1'd1 ? ~8'd0 : 8'd0};
//    if (cy_tx < 240 )
//       rgb_tx = 24'hff0000;
//    else if (cy_tx < 480 )
//       rgb_tx = 24'h00ff00;
//    else
//       rgb_tx = 24'h0000ff; 

  if(~game_start) begin
    if (cy_tx < 240 )
       rgb_tx = 24'hff0000;
    else if (cy_tx < 480 )
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

logic [23:0] rgb_rx = 24'hff0000;   //24'hffffff;   // R G B

always @(posedge clk_pixel_rx) begin
    if (cy_rx < 360 )
       rgb_rx = 24'hff0000;
    else if (cy_rx < 720 )
       rgb_rx = 24'h00ff00;
    else
       rgb_rx = 24'h0000ff; 
 end



// 1280x720@59.94Hz      4
// 1920x1080@60Hz       16
hdmi #(.VIDEO_ID_CODE(16), .VIDEO_REFRESH_RATE(59.94), .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16)) hdmi_rx(
  .clk_pixel_x5(clk_pixel_x5_rx),
  .clk_pixel(clk_pixel_rx),
  .clk_audio(clk_audio_rx),
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


hdmi #(.VIDEO_ID_CODE(4), .VIDEO_REFRESH_RATE(59.94), .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16)) hdmi_tx(
  .clk_pixel_x5(clk_pixel_x5_tx),
  .clk_pixel(clk_pixel_tx),
  .clk_audio(clk_audio_tx),
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
