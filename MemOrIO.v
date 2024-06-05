module MemOrIO(
input mRead, // read memory, from Controller
input mWrite, // write memory, from Controller
input ioRead, // read IO, from Controller
input ioWrite, // write IO, from Controller
input[31:0] addr_in, // from alu_result in ALU
output[31:0] addr_out, // address to Data-Memory
input[31:0] m_rdata, // data read from Data-Memory
input[15:0] io_rdata, // data read from IO,16 bits
output[31:0] r_wdata, // data to Decoder(register file)
input[31:0] r_rdata, // data read from Decoder(register file)
output reg[31:0] write_data, // data to memory or I/O???¨¬m_wdata, io_wdata??
output LEDCtrl, // LED Chip Select
output SwitchCtrl, // Switch Chip Select
output TubeCtrl,
output ButtonCtrl1,
output ButtonCtrl2,
input isUnsigned
);
assign addr_out= addr_in;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of r_wdata. 
wire [31:0]temp_io_rdata;
assign temp_io_rdata = (isUnsigned == 1'b1)?{16'h0000,io_rdata}:{{16{io_rdata[15]}},io_rdata};
assign r_wdata = (mRead == 1'b1)? m_rdata:temp_io_rdata;
// Chip select signal of Led and Switch are all active high;
//led 0xFFFFFC60
//switch 0xFFFFFC70
//tube 0xFFFFFC80
assign LEDCtrl = (ioWrite == 1'b1&& addr_in[7:4]==4'b0110) ? 1'b1 : 1'b0;
assign SwitchCtrl = (ioRead == 1'b1 && addr_in[7:4]==4'b0111) ? 1'b1 : 1'b0;
assign TubeCtrl = (ioWrite == 1'b1 && addr_in[7:4]==4'b1000) ? 1'b1 : 1'b0;
assign ButtonCtrl1 = (ioRead == 1'b1 && addr_in[7:0]==4'b0101_0000) ? 1'b1 : 1'b0;
assign ButtonCtrl2 = (ioRead == 1'b1 && addr_in[7:0]==4'b0101_0010) ? 1'b1 : 1'b0;
always @* begin
if((mWrite==1)||(ioWrite==1))
//wirte_data could go to either memory or IO. where is it from?
write_data = r_rdata;
else
write_data = write_data;
end
endmodule
