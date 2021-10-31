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

    protected override void activate () {
      var main_window = new Gtk.ApplicationWindow (this) {
        default_height = 500,
        default_width = 500,
        /// TRANSLATORS: Main Top Bar Title
        title = _("Mines")
      };

      // CONSTANTS TO DETERMINE GAME RULES
      // TODO: These need to be user speciafiable
      const int BOARD_HEIGHT       = 10;
      const int BOARD_WIDTH        = 10;
      const int MINES              = 25;
      const bool CORNERS_HAVE_MINES = true;

      // we want grid of button BOARD_HEIGHT tall, BOARD_WIDTH wide

      var mine_board = new Gtk.Grid () {
        column_spacing = 6,
        row_spacing = 6
      };

      var buttons = new Gtk.Button[BOARD_WIDTH, BOARD_HEIGHT];
      var label = new Gtk.Label("A Label");
      mine_board.attach(label, 0, BOARD_HEIGHT, BOARD_WIDTH);
      for (int i = 0; i < BOARD_WIDTH; i++){
        for (int j = 0; j < BOARD_HEIGHT; j++){
          buttons[i, j] = new Gtk.Button.with_label(j.to_string() + " - " + i.to_string());
          var curr_col = i.to_string();
          var curr_row = j.to_string();
          buttons[i, j].clicked.connect(() => {
            label.label = (curr_row + " - " + curr_col);
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

