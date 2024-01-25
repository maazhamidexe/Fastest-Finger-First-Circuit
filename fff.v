module fastest_finger_first (
  input wire clk,
  input wire rst,
  input wire buzzer_user1,
  input wire buzzer_user2,
  output wire winner_user1,
  output wire winner_user2
);

  reg [1:0] state_user1, state_user2;
  reg winner_hold_user1, winner_hold_user2;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state_user1 <= 2'b00;
      state_user2 <= 2'b00;
      winner_hold_user1 <= 1'b0;
      winner_hold_user2 <= 1'b0;
    end else begin
      // State machine for User 1
      case (state_user1)
        2'b00: if (buzzer_user1) state_user1 <= 2'b01;
        2'b01: if (!buzzer_user1 && !winner_user2) state_user1 <= 2'b10;
        2'b10: begin
                state_user1 <= (winner_user1) ? 2'b11 : 2'b00; // New state for disabled game
                winner_hold_user1 <= (winner_user1) ? 1'b1 : (state_user2 == 2'b11) ? 1'b1 : 1'b0; // Hold the winner signal, disable if User 2 won
              end
        2'b11: state_user1 <= (winner_hold_user1 && !rst) ? 2'b11 : 2'b00; // Stay in the disabled state until reset

      endcase

      // State machine for User 2
      case (state_user2)
        2'b00: if (buzzer_user2) state_user2 <= 2'b01;
        2'b01: if (!buzzer_user2 && !winner_user1) state_user2 <= 2'b10;
        2'b10: begin
                state_user2 <= (winner_user2) ? 2'b11 : 2'b00; // New state for disabled game
                winner_hold_user2 <= (winner_user2) ? 1'b1 : (state_user1 == 2'b11) ? 1'b1 : 1'b0; // Hold the winner signal, disable if User 1 won
              end
        2'b11: state_user2 <= (winner_hold_user2 && !rst) ? 2'b11 : 2'b00; // Stay in the disabled state until reset

      endcase
    end
  end


  // Determine the winner based on the fastest buzzer press
  assign winner_user1 = (state_user1 == 2'b10) ? 1'b1 : winner_hold_user1;
  assign winner_user2 = (state_user2 == 2'b10) ? 1'b1 : winner_hold_user2;

endmodule
