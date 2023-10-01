//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-5
//Part Number: GW5AST-LV138FPG676AC1/I0
//Device: GW5AST-138
//Device Version: B
//Created Time: Sun Oct 01 15:51:40 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Customized_PHY_Top your_instance_name(
		.Q0_LANE0_PCS_RX_O_FABRIC_CLK(Q0_LANE0_PCS_RX_O_FABRIC_CLK_i), //input Q0_LANE0_PCS_RX_O_FABRIC_CLK
		.Q0_LANE0_FABRIC_RX_CLK(Q0_LANE0_FABRIC_RX_CLK_o), //output Q0_LANE0_FABRIC_RX_CLK
		.Q0_FABRIC_LN0_RXDATA_O(Q0_FABRIC_LN0_RXDATA_O_i), //input [87:0] Q0_FABRIC_LN0_RXDATA_O
		.Q0_LANE0_RX_IF_FIFO_RDEN(Q0_LANE0_RX_IF_FIFO_RDEN_o), //output Q0_LANE0_RX_IF_FIFO_RDEN
		.Q0_LANE0_RX_IF_FIFO_RDUSEWD(Q0_LANE0_RX_IF_FIFO_RDUSEWD_i), //input [4:0] Q0_LANE0_RX_IF_FIFO_RDUSEWD
		.Q0_LANE0_RX_IF_FIFO_AEMPTY(Q0_LANE0_RX_IF_FIFO_AEMPTY_i), //input Q0_LANE0_RX_IF_FIFO_AEMPTY
		.Q0_LANE0_RX_IF_FIFO_EMPTY(Q0_LANE0_RX_IF_FIFO_EMPTY_i), //input Q0_LANE0_RX_IF_FIFO_EMPTY
		.Q0_FABRIC_LN0_RX_VLD_OUT(Q0_FABRIC_LN0_RX_VLD_OUT_i), //input Q0_FABRIC_LN0_RX_VLD_OUT
		.Q0_LANE0_PCS_TX_O_FABRIC_CLK(Q0_LANE0_PCS_TX_O_FABRIC_CLK_i), //input Q0_LANE0_PCS_TX_O_FABRIC_CLK
		.Q0_LANE0_FABRIC_TX_CLK(Q0_LANE0_FABRIC_TX_CLK_o), //output Q0_LANE0_FABRIC_TX_CLK
		.Q0_FABRIC_LN0_TXDATA_I(Q0_FABRIC_LN0_TXDATA_I_o), //output [79:0] Q0_FABRIC_LN0_TXDATA_I
		.Q0_FABRIC_LN0_TX_VLD_IN(Q0_FABRIC_LN0_TX_VLD_IN_o), //output Q0_FABRIC_LN0_TX_VLD_IN
		.Q0_LANE0_TX_IF_FIFO_WRUSEWD(Q0_LANE0_TX_IF_FIFO_WRUSEWD_i), //input [4:0] Q0_LANE0_TX_IF_FIFO_WRUSEWD
		.Q0_LANE0_TX_IF_FIFO_AFULL(Q0_LANE0_TX_IF_FIFO_AFULL_i), //input Q0_LANE0_TX_IF_FIFO_AFULL
		.Q0_LANE0_TX_IF_FIFO_FULL(Q0_LANE0_TX_IF_FIFO_FULL_i), //input Q0_LANE0_TX_IF_FIFO_FULL
		.Q0_LANE0_FABRIC_C2I_CLK(Q0_LANE0_FABRIC_C2I_CLK_o), //output Q0_LANE0_FABRIC_C2I_CLK
		.Q0_LANE0_CHBOND_START(Q0_LANE0_CHBOND_START_o), //output Q0_LANE0_CHBOND_START
		.Q0_FABRIC_LN0_RSTN_I(Q0_FABRIC_LN0_RSTN_I_o), //output Q0_FABRIC_LN0_RSTN_I
		.Q0_LANE0_PCS_RX_RST(Q0_LANE0_PCS_RX_RST_o), //output Q0_LANE0_PCS_RX_RST
		.Q0_LANE0_PCS_TX_RST(Q0_LANE0_PCS_TX_RST_o), //output Q0_LANE0_PCS_TX_RST
		.Q0_FABRIC_LANE0_CMU_CK_REF_O(Q0_FABRIC_LANE0_CMU_CK_REF_O_i), //input Q0_FABRIC_LANE0_CMU_CK_REF_O
		.Q0_FABRIC_LN0_ASTAT_O(Q0_FABRIC_LN0_ASTAT_O_i), //input [5:0] Q0_FABRIC_LN0_ASTAT_O
		.Q0_FABRIC_LN0_PMA_RX_LOCK_O(Q0_FABRIC_LN0_PMA_RX_LOCK_O_i), //input Q0_FABRIC_LN0_PMA_RX_LOCK_O
		.Q0_LANE0_ALIGN_LINK(Q0_LANE0_ALIGN_LINK_i), //input Q0_LANE0_ALIGN_LINK
		.Q0_LANE0_K_LOCK(Q0_LANE0_K_LOCK_i), //input Q0_LANE0_K_LOCK
		.Q0_FABRIC_LANE0_CMU_OK_O(Q0_FABRIC_LANE0_CMU_OK_O_i), //input Q0_FABRIC_LANE0_CMU_OK_O
		.q0_ln0_rx_pcs_clkout_o(q0_ln0_rx_pcs_clkout_o_o), //output q0_ln0_rx_pcs_clkout_o
		.q0_ln0_rx_clk_i(q0_ln0_rx_clk_i_i), //input q0_ln0_rx_clk_i
		.q0_ln0_rx_data_o(q0_ln0_rx_data_o_o), //output [87:0] q0_ln0_rx_data_o
		.q0_ln0_rx_fifo_rden_i(q0_ln0_rx_fifo_rden_i_i), //input q0_ln0_rx_fifo_rden_i
		.q0_ln0_rx_fifo_rdusewd_o(q0_ln0_rx_fifo_rdusewd_o_o), //output [4:0] q0_ln0_rx_fifo_rdusewd_o
		.q0_ln0_rx_fifo_aempty_o(q0_ln0_rx_fifo_aempty_o_o), //output q0_ln0_rx_fifo_aempty_o
		.q0_ln0_rx_fifo_empty_o(q0_ln0_rx_fifo_empty_o_o), //output q0_ln0_rx_fifo_empty_o
		.q0_ln0_rx_valid_o(q0_ln0_rx_valid_o_o), //output q0_ln0_rx_valid_o
		.q0_ln0_tx_pcs_clkout_o(q0_ln0_tx_pcs_clkout_o_o), //output q0_ln0_tx_pcs_clkout_o
		.q0_ln0_tx_clk_i(q0_ln0_tx_clk_i_i), //input q0_ln0_tx_clk_i
		.q0_ln0_tx_data_i(q0_ln0_tx_data_i_i), //input [79:0] q0_ln0_tx_data_i
		.q0_ln0_tx_fifo_wren_i(q0_ln0_tx_fifo_wren_i_i), //input q0_ln0_tx_fifo_wren_i
		.q0_ln0_tx_fifo_wrusewd_o(q0_ln0_tx_fifo_wrusewd_o_o), //output [4:0] q0_ln0_tx_fifo_wrusewd_o
		.q0_ln0_tx_fifo_afull_o(q0_ln0_tx_fifo_afull_o_o), //output q0_ln0_tx_fifo_afull_o
		.q0_ln0_tx_fifo_full_o(q0_ln0_tx_fifo_full_o_o), //output q0_ln0_tx_fifo_full_o
		.q0_ln0_pma_rstn_i(q0_ln0_pma_rstn_i_i), //input q0_ln0_pma_rstn_i
		.q0_ln0_pcs_rx_rst_i(q0_ln0_pcs_rx_rst_i_i), //input q0_ln0_pcs_rx_rst_i
		.q0_ln0_pcs_tx_rst_i(q0_ln0_pcs_tx_rst_i_i), //input q0_ln0_pcs_tx_rst_i
		.q0_ln0_refclk_o(q0_ln0_refclk_o_o), //output q0_ln0_refclk_o
		.q0_ln0_signal_detect_o(q0_ln0_signal_detect_o_o), //output q0_ln0_signal_detect_o
		.q0_ln0_rx_cdr_lock_o(q0_ln0_rx_cdr_lock_o_o), //output q0_ln0_rx_cdr_lock_o
		.q0_ln0_pll_lock_o(q0_ln0_pll_lock_o_o), //output q0_ln0_pll_lock_o
		.Q0_FABRIC_CMU_CK_REF_O(Q0_FABRIC_CMU_CK_REF_O_i), //input Q0_FABRIC_CMU_CK_REF_O
		.Q0_FABRIC_CMU1_CK_REF_O(Q0_FABRIC_CMU1_CK_REF_O_i), //input Q0_FABRIC_CMU1_CK_REF_O
		.Q0_FABRIC_CMU1_OK_O(Q0_FABRIC_CMU1_OK_O_i), //input Q0_FABRIC_CMU1_OK_O
		.Q0_FABRIC_CMU_OK_O(Q0_FABRIC_CMU_OK_O_i), //input Q0_FABRIC_CMU_OK_O
		.Q1_FABRIC_CMU_CK_REF_O(Q1_FABRIC_CMU_CK_REF_O_i), //input Q1_FABRIC_CMU_CK_REF_O
		.Q1_FABRIC_CMU1_CK_REF_O(Q1_FABRIC_CMU1_CK_REF_O_i), //input Q1_FABRIC_CMU1_CK_REF_O
		.Q1_FABRIC_CMU1_OK_O(Q1_FABRIC_CMU1_OK_O_i), //input Q1_FABRIC_CMU1_OK_O
		.Q1_FABRIC_CMU_OK_O(Q1_FABRIC_CMU_OK_O_i) //input Q1_FABRIC_CMU_OK_O
	);

//--------Copy end-------------------
