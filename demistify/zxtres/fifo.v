module fifo (
    input         aclr,
    input  [15:0] data,
    input         rdclk,
    input         rdreq,
    input         wrclk,
    input         wrreq,
    output reg [31:0] q,
    output [8:0]  wrusedw
);

    reg [31:0] fifo_mem [0:511];
    reg [8:0] wr_ptr, rd_ptr;

    always @(posedge wrclk or negedge aclr) begin
        if (~aclr) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else if (wrreq) begin
            fifo_mem[wr_ptr] <= data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    always @(posedge rdclk or negedge aclr) begin
        if (~aclr) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else if (rdreq) begin
            q <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    assign wrusedw = wr_ptr;

endmodule
