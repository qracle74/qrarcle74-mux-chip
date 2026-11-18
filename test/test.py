import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_mux(dut):
    dut._log.info("Start 4:1 MUX test")

    # 데이터 입력 설정: d0=00(0), d1=01(1), d2=10(2), d3=11(3) -> 8'b11_10_01_00 = 0xE4
    dut.ui_in.value = 0xE4
    dut.ena.value = 1
    dut.clk.value = 0
    dut.rst_n.value = 1

    # addr = 00 -> d0 (00) 출력 확인
    dut.uio_in.value = 0
    await Timer(10, units="ns")
    assert (dut.uo_out.value & 0x03) == 0

    # addr = 01 -> d1 (01) 출력 확인
    dut.uio_in.value = 1
    await Timer(10, units="ns")
    assert (dut.uo_out.value & 0x03) == 1

    # addr = 10 -> d2 (10) 출력 확인
    dut.uio_in.value = 2
    await Timer(10, units="ns")
    assert (dut.uo_out.value & 0x03) == 2

    # addr = 11 -> d3 (11) 출력 확인
    dut.uio_in.value = 3
    await Timer(10, units="ns")
    assert (dut.uo_out.value & 0x03) == 3

    dut._log.info("All MUX tests passed!")
