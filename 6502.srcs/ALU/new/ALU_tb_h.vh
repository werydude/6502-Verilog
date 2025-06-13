reg [7:0] data_a, data_b, addr_b;
wire [7:0] bus_a_data, bus_b_data, bus_b_datab, bus_b_addr, out;
wire [7:0] bus_out_a, bus_out_b;

assign bus_a_data = data_a;
assign bus_b_data = data_b;
assign bus_b_datab = ~data_b;
assign bus_b_addr = addr_b;



wire V, C, load_out;
reg cin = 1'b0;
reg load_out_data = 1'b0;
reg load_a_data, load_a_zero, load_b_data, load_b_datab, load_b_addr;
reg sums, ands, eors, ors/*, srs */;

assign load_out = load_out_data;