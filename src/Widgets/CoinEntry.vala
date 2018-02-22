namespace Cryptonian {

    public class CoinEntry : Gtk.Grid {

        Gtk.Label symbol_label;

        Gtk.Label price_label;

        Gtk.Image coin_icon;

        Coin coin;

        ulong coin_change_handler_id;

        construct {
            column_spacing = 12;
            margin = 12;
            margin_start = 24;
            margin_end = 24;

            this.symbol_label = new Gtk.Label ("");
            this.symbol_label.set_xalign (0f);
            this.symbol_label.get_style_context ().add_class ("symbol_label");
            this.price_label = new Gtk.Label ("");
            this.price_label.get_style_context ().add_class ("price_label");
            this.coin_icon = new Gtk.Image ();

            this.attach (this.coin_icon, 0, 0, 1, 2);
            this.attach (this.symbol_label, 1, 0, 1, 1);
            this.attach (this.price_label, 1, 1, 1, 1);
        }

        public void set_coin (Coin coin) {
            if (this.coin != null) {
                this.coin.disconnect (this.coin_change_handler_id);
            }
            this.coin = coin;
            this.symbol_label.set_label (this.coin.symbol);
            this.update_price ();
            this.coin_icon.set_from_icon_name (this.coin.symbol.down (), Gtk.IconSize.LARGE_TOOLBAR);
            this.coin_change_handler_id = this.coin.notify.connect (this.on_coin_changed);
        }

        private void on_coin_changed(ParamSpec pspec) {
            if (pspec.get_name () == "symbol") {
                this.symbol_label.set_label (this.coin.symbol);
            }
            if (pspec.get_name () == "price") {
                this.update_price ();
            }
        }

        private void update_price () {
            this.price_label.set_label ("$%g".printf(this.coin.price));
        }

    }

}