module tb_fastest_finger_first;

  reg clk, rst, buzzer_user1, buzzer_user2;
  wire winner_user1, winner_user2;`

  // Instantiate the module
  fastest_finger_first uut (
    .clk(clk),
    .rst(rst),
    .buzzer_user1(buzzer_user1),
    .buzzer_user2(buzzer_user2),
    .winner_user1(winner_user1),
    .winner_user2(winner_user2)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial values
  initial begin
    clk = 0;
    rst = 1;
    buzzer_user1 = 0;
    buzzer_user2 = 0;

    // Apply reset
    #10 rst = 0;

    // Test case 1: User 1 wins and stays winner until reset
    #20 buzzer_user1 = 1;
    #25 buzzer_user1 = 0;
    #30 buzzer_user2 = 1;
    #35 buzzer_user2 = 0;
    #40 rst = 1; // Reset after User 1 wins
    #45 #10 rst = 0; // Reset before the next test case
    #50 buzzer_user2 = 1;
    #55 buzzer_user2 = 0;

    // Test case 2: User 2 wins and stays winner until reset
    #60 buzzer_user1 = 1;
    #65 buzzer_user1 = 0;
    #80 rst = 1; // Reset after User 1 wins
    #82 #10 rst = 0; // Reset before the next test case
    #70 buzzer_user2 = 1;
    #75 buzzer_user2 = 0;
    #80 rst = 1; // Reset after User 2 wins
    #85 #10 rst = 0; // Reset before the next test case
    #90 buzzer_user1 = 1;
    #95 buzzer_user1 = 0;

    // Test case 3: No winner (both press simultaneously)
    #100 buzzer_user1 = 1;
    #105 buzzer_user2 = 1;
    #110 buzzer_user1 = 0;
    #115 buzzer_user2 = 0;
    #120 rst = 1; // Reset after simultaneous press
    #125 #10 rst = 0; // Reset before the next test case
    #130 buzzer_user1 = 1;
    #135 buzzer_user1 = 0;

    // Test case 4: User 1 wins again and stays winner until reset
    #140 buzzer_user1 = 1;
    #145 buzzer_user1 = 0;
    #150 buzzer_user2 = 1;
    #155 buzzer_user2 = 0;
    #160 rst = 1; // Reset after User 1 wins again
    #165 #10 rst = 0; // Reset before the next test case
    #170 buzzer_user2 = 1;
    #175 buzzer_user2 = 0;

    // Add more test cases as needed

    #180 $stop; // Stop simulation
  end

endmodule
