namespace CryptoWatcher {

    class DataService : Object {

        const string API_BASE_URL = "https://min-api.cryptocompare.com/data";

        const string[] ALL_SYMBOLS = {"BTC", "ETH", "LTC", "XRP", "DASH", "XLM"};

        const string[] HIGHLIGH_SYMBOLS = {"BTC", "ETH", "LTC", "XRP"};

        private Gee.HashMap<string, Coin> coins;

        private bool polling;

        public signal void coins_loaded ();

        public signal void coin_loaded (Coin coin);

        public signal void coin_updated (Coin coin);

        public void start_fetching_data () {
            if (!this.polling) {
                this.polling = true;
                this.coins = new Gee.HashMap<string, Coin> ();
                this.fetch_data ();
                GLib.Timeout.add_seconds(10, this.fetch_data);
                this.coins_loaded ();
            }
        }

        private bool fetch_data () {
            if (this.polling) {
                var coins = this.get_coin_data ();
                this.handle_coin_update (coins);
            }
            return this.polling;
        }

        public void stop_fetching_data () {
            this.polling = false;
        }

        public int get_highlight_coins_count () {
            return HIGHLIGH_SYMBOLS.length;
        }

        public Coin get_highlight_coin (int index) {
            return this.coins.@get (HIGHLIGH_SYMBOLS[index]);
        }

        private void handle_coin_update (Array<CoinData?> coins_data) {
            for (int i = 0; i < coins_data.length ; i++) {
                var coin_data = coins_data.index (i);
                if (this.coins.has_key (coin_data.symbol)) {
                    var coin = this.coins.@get (coin_data.symbol);
                    coin.symbol = coin_data.symbol;
                    coin.price = coin_data.price;
                    this.coin_updated (coin);
                } else {
                    var coin = new Coin (coin_data);
                    this.coins.@set (coin.symbol, coin);
                    this.coin_loaded (coin);
                }
            }
        }

        private Array<CoinData?> get_coin_data () {
            var from_symbols = string.joinv (",", ALL_SYMBOLS);
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", API_BASE_URL + "/pricemulti?fsyms=%s&tsyms=USD".printf(from_symbols));
            session.send_message (message);
            var obj = parse_json_object ((string) message.response_body.flatten ().data);
            var array = new Array<CoinData?> ();
            obj.foreach_member ((obj, name, node) => {
                var symbol = name;
                var coin_obj = obj.get_object_member (name);
                double price = coin_obj.get_double_member ("USD");
                var coin = CoinData (symbol, price);
                array.append_val (coin);
            });
            return array;
        }

        private Json.Object? parse_json_object (string body) {
            try {
                var parser = new Json.Parser ();
                parser.load_from_data (body, -1);
                return parser.get_root ().get_object ();
            } catch (Error e) {
                return null;
            }
        }

    }



}
