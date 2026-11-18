/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mux4to1 (
    input  wire [7:0] ui_in,    // 전용 입력 핀 (d0~d3 데이터 입력)
    output wire [7:0] uo_out,   // 전용 출력 핀 (out 결과 출력)
    input  wire [7:0] uio_in,   // 양방향 입력 핀 (addr0, addr1 선택 신호)
    output wire [7:0] uio_out,  // 양방향 출력 핀 (미사용)
    output wire [7:0] uio_oe,   // 양방향 핀 방향 설정 (0: 입력, 1: 출력)
    input  wire       ena,      // 활성화 신호
    input  wire       clk,      // 클럭 (조합회로라 미사용)
    input  wire       rst_n     // 리셋 (조합회로라 미사용)
);

    wire [1:0] mux_out;

    // 작성하신 2비트 4:1 MUX 모듈 연결
    top my_mux (
        .d0(ui_in[1:0]),
        .d1(ui_in[3:2]),
        .d2(ui_in[5:4]),
        .d3(ui_in[7:6]),
        .addr0(uio_in[0]),
        .addr1(uio_in[1]),
        .out(mux_out)
    );

    // 출력 및 미사용 핀 처리
    assign uo_out  = {6'b000000, mux_out};
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000; // uio 핀 전체를 입력 모드로 설정

    // 미사용 입력 핀 경고 방지용 처리
    wire _unused = &{ena, clk, rst_n, uio_in[7:2], 1'b0};

endmodule

// 원본 2비트 4:1 MUX 모듈
module top(d0, d1, d2, d3, addr0, addr1, out);
    
    // Module arguments
    input wire  [1:0] d0;
    input wire  [1:0] d1;
    input wire  [1:0] d2;
    input wire  [1:0] d3;
    input wire  addr0;
    input wire  addr1;
    output reg  [1:0] out;
    
    // Local signals
    reg  [1:0] mux0;
    reg  [1:0] mux1;
    
    // Update code
    always @(*) begin
        if (addr0 == 1'b1) begin
            mux0 = d1;
            mux1 = d3;
        end
        else begin
            mux0 = d0;
            mux1 = d2;
        end
        if (addr1 == 1'b1) begin
            out = mux1;
        end
        else begin
            out = mux0;
        end
    end
    
endmodule
