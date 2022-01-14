/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Dimitry Maizik <dima@dmaizik.ca>
 */


 public class MyApp : Gtk.Application {
    public MyApp() {
      Object (
        application_id: "com.github.dimamzk.gtk3-minesweeper",
          flags: ApplicationFlags.FLAGS_NONE
      );
    }

    protected bool[,] generate_board(int height, int width, int mine_count, int[] context_coord, bool mines_on_corners) {
      // TODO: We should not continue if we want -1 mines, or height*width mines or more
      var mines_left_to_generate = mine_count;
      var mine_coords = new bool[width, height];
      for (int i = 0; i < width; i++){
        for (int j = 0; j < height; j++){
          mine_coords[i, j] = false; // just in case :)
        }
      }
      while (mines_left_to_generate > 0) {
        var col = GLib.Random.int_range(0, width);
        var row = GLib.Random.int_range(0, height);
        if (!mine_coords[col, row]){
          var mine = true;
          if(!mines_on_corners){
            if((col == 0 && row == 0) ||
               (col == 0 && row == height) ||
               (col == width && row == 0) ||
               (col == width && row == height)) {
                  mine = false;
                }
          }
          if (col == context_coord[0] && row == context_coord[1]){
            mine = false;
          }
          if (mine){
            mine_coords[col, row] = true;
            mines_left_to_generate--;
          }
        }
      }
      return mine_coords;
    }

    protected bool[,] init_game(Gtk.Button[,] button_arr, int height, int width, int mine_count, int[] context_coord, bool mines_on_corners) {
      var mine_coords = generate_board(height, width, mine_count, context_coord, mines_on_corners);
      for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
          button_arr[i, j].set_label("  "); // Empty the board as we go // TODO: This wont be needed when finished
          if (mine_coords[i, j]){
            button_arr[i, j].set_label(" *");
          }
        }
      }
      return mine_coords;
    }
    
    protected void clear_board(Gtk.Button[,] button_arr, int height, int width) {
      for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
          button_arr[i, j].set_label("  "); // Empty the board as we go // TODO: This wont be needed when finished
        }
      }
    }

    protected override void activate () {
      var main_window = new Gtk.ApplicationWindow (this) {
        default_height = 500,
        default_width = 500,
        /// TRANSLATORS: Main Top Bar Title
        title = _("Mines")
      };

      // CONSTANTS TO DETERMINE GAME RULES
      // TODO: These need to be user speciafiable
      const int BOARD_HEIGHT        = 10;
      const int BOARD_WIDTH         = 10;
      const int MINES               = 25;
      const bool CORNERS_HAVE_MINES = true;

      // we want grid of button BOARD_HEIGHT tall, BOARD_WIDTH wide :check:
      // we want to randomly specify mine locations

      var mine_board = new Gtk.Grid () {
        column_spacing = 6,
        row_spacing = 6
      };

      var mines_left_to_generate = 25;
      var mine_coords = new bool[BOARD_WIDTH, BOARD_HEIGHT];


      var buttons = new Gtk.Button[BOARD_WIDTH, BOARD_HEIGHT];
      var label = new Gtk.Label("A Label");
      var start_game_button = new Gtk.Button.with_label ("Start New Game");
      start_game_button.clicked.connect(() => {
          clear_board(buttons, 10, 10);
      });
      mine_board.attach(label, 0, BOARD_HEIGHT, BOARD_WIDTH);
      mine_board.attach(start_game_button, 0, BOARD_HEIGHT + 1, BOARD_WIDTH);
      for (int i = 0; i < BOARD_WIDTH; i++){
        for (int j = 0; j < BOARD_HEIGHT; j++){
          buttons[i, j] = new Gtk.Button.with_label("   ");
          var curr_col = i.to_string();
          var curr_row = j.to_string();
          int[] coords = {i, j};
          buttons[i, j].clicked.connect(() => {
            mine_coords = init_game(buttons, 10, 10, 25, coords, false);
          });
          mine_board.attach(buttons[i, j], i, j);
        }
      }

      main_window.add(mine_board);
      main_window.show_all();
    }

    public static int main(string[] args) {
      return new MyApp().run (args);
    }
  }

