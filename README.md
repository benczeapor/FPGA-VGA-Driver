The code for a VGA Display Driver implemented on a Basys-3 FPGA board.


This code, when uploaded to a Basys-3 board can display a selection of 4 shapes at 4 different colors. The shape and the color can be selected with the first 4 switches on the board and the position of the shape can be changed with the direction buttons.

Additionally, the last switch activates the so-called ```Snake Mode```. In this mode, the shapes disappear and the user is presented with a game of snake. To control the snake, the user can use the four direction buttons on the board. The game is fully functional: fruits will spawn at random locations, the snake gets longer if it eats said fruits, and it dies if it collides with the walls or itself.

To try this, you will need to:
  1. Create a new project in Vivado
  2. Import the code downloaded from here
  3. Go trough the steps to generate the Bitstream(or simply click on the ```Generate Bitstream``` button)
  4. Connect the board to your computer
  5. When the Bitstream generation finishes, upload it to your device and enjoy!
