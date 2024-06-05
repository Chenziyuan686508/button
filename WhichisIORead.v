module WhichisIORead(
input Button1, Button2,//这两个button直接用顶层的借入，不需要检测上升沿和消抖了
input [15:0] SwitchData,
input ButtonCtrl1,
input ButtonCtrl2,
input SwitchCtrl
output reg [15:0] ioread_data
);
always @* begin
if(Button1 == 1'b1 && ButtonCtrl1) begin
ioread_data = 0000_0000_0000_0001;
end
else if(Button2 == 1'b1 && ButtonCtrl2) begin
ioread_data = 0000_0000_0000_0001;
end
else if(SwitchCtrl) begin
ioread_data = SwitchData;
end
else begin
ioread_data = ioread_data;
end
