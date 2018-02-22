namespace CryptoWatcher {

    class MainWindow : Gtk.Window {

        DataService data_service;

        GLib.ListStore coin_list_model;

        // Gtk.ListStore coin_list_model;

        // Gtk.TreeView coin_list;

        Gtk.ListBox coin_list;

        AppIndicator.Indicator indicator;

        int highlight_count;

        int current_highlight_count = -1;

        public MainWindow (Gtk.Application application) {
            Object (
                application: application,
                height_request: 480,
                icon_name: "com.github.flore2003.crypto-watcher",
                resizable: true,
                title: _("Crypto Watcher"),
                width_request: 600
            );
        }

        construct {
            this.data_service = new DataService ();
            this.build_ui ();
            this.data_service.coin_loaded.connect (this.on_coin_loaded);
            // this.data_service.coin_updated.connect (this.on_coin_updated);
            this.data_service.coins_loaded.connect (this.on_coins_loaded);

            this.data_service.start_fetching_data ();
        }

        private void build_ui () {
            var headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;
            headerbar.title = _("Crypto Watcher");
            this.set_titlebar (headerbar);

            var grid = new Gtk.Grid ();
            this.add (grid);

            this.coin_list_model = new GLib.ListStore (typeof (Coin));
            this.coin_list = new Gtk.ListBox ();
            this.coin_list.set_selection_mode (Gtk.SelectionMode.NONE);
            this.coin_list.get_style_context ().add_class ("coin_list");
            grid.attach (this.coin_list, 0, 0 , 1, 1);
            this.coin_list.set_hexpand (true);
            this.coin_list.set_vexpand (true);

            this.coin_list.bind_model (this.coin_list_model, (c) => {
                Coin coin = (Coin) c;
                stdout.printf ("%s %g\n", coin.symbol, coin.price);
                var entry = new CoinEntry ();
                entry.set_coin(coin);
                return entry;
            });

            // this.coin_list_model = new Gtk.ListStore (2, typeof (string), typeof (string));
            // this.coin_list = new Gtk.TreeView.with_model (coin_list_model);
            // this.coin_list.set_reorderable (true);
            // var selection = this.coin_list.get_selection ();
            // selection.set_mode (Gtk.SelectionMode.NONE);
            // grid.attach (this.coin_list, 0, 1 , 1, 1);
            // this.coin_list.set_hexpand (true);
            // this.coin_list.set_vexpand (true);

            // Gtk.CellRendererText regular_cell = new Gtk.CellRendererText ();
            // var col = new Gtk.TreeViewColumn.with_attributes ("Symbol", regular_cell, "text", 0);
            // col.set_expand (true);
            // this.coin_list.append_column (col);


            // Gtk.CellRendererText right_aligned_cell = new Gtk.CellRendererText ();
            // right_aligned_cell.set_alignment(1f, 0f);
            // col = new Gtk.TreeViewColumn.with_attributes ("Price", right_aligned_cell, "text", 1);
            // col.set_alignment(1f);
            // this.coin_list.append_column (col);




            this.indicator = new AppIndicator.Indicator("Test", "btc",
                                      AppIndicator.IndicatorCategory.APPLICATION_STATUS);

            this.indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);
            this.indicator.set_attention_icon("window-maximize");

            var menu = new Gtk.Menu();

            var item = new Gtk.MenuItem.with_label("Foo");
            item.activate.connect(() => {
                indicator.set_status(AppIndicator.IndicatorStatus.ATTENTION);
            });
            item.show();
            menu.append(item);

            var bar = item = new Gtk.MenuItem.with_label("Bar");
            item.show();
            item.activate.connect(() => {
                indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);
            });
            menu.append(item);

            this.indicator.set_menu(menu);
            this.indicator.set_secondary_activate_target(bar);
        }

        private bool rotate_highlight_coin () {
            this.current_highlight_count = (this.current_highlight_count + 1) % this.highlight_count;
            var coin = this.data_service.get_highlight_coin (this.current_highlight_count);
            this.indicator.set_label ("%s: $%g".printf (coin.symbol, coin.price), "XXXX: $99999.99");
            return true;
        }

        private void on_coins_loaded () {
            // TODO: Start the indicator rotation
            this.highlight_count = this.data_service.get_highlight_coins_count ();
            this.rotate_highlight_coin ();
            GLib.Timeout.add_seconds(3, this.rotate_highlight_coin);
        }

        private void on_coin_loaded (Coin coin) {
            this.coin_list_model.append (coin);
        }

        // private void on_coin_updated (Coin coin) {
        //     this.indicator.set_label ("%g".printf (coin.price), "");
        // }

    }

}