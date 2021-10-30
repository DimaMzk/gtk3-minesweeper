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
        default_height = 300,
        default_width = 300,
        title = _("Hello World!")
      };

      var hello_button = new Gtk.Button.with_label(("Say Hello"));
      var hello_label = new Gtk.Label(null);

      var rotate_button = new Gtk.Button.with_label(_("Rotate"));
      var rotate_label = new Gtk.Label(_("Horizontal"));

      var grid = new Gtk.Grid() {
        column_spacing = 6,
        row_spacing = 6
      };

      // Add First row of Widgets
      grid.attach(hello_button, 0, 0, 1, 1);
      grid.attach_next_to(hello_label, hello_button, Gtk.PositionType.RIGHT, 1, 1);

      // Add second row of widgets
      grid.attach(rotate_button, 0, 1);
      grid.attach_next_to(rotate_label, rotate_button, Gtk.PositionType.RIGHT, 1, 1);

      hello_button.clicked.connect (() => {
        hello_label.label = _("Hello World!");
        hello_button.sensitive = false;
      });

      rotate_button.clicked.connect (() => {
        rotate_label.angle = 90;
        rotate_label.label = _("Vertical");
        rotate_button.sensitive = false;
      });

      main_window.add(grid);

      main_window.show_all();
    }

    public static int main(string[] args) {
      return new MyApp().run (args);
    }
  }

