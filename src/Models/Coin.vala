namespace Cryptonian {

    public struct CoinData {
        public string symbol;

        public double price;

        public CoinData (string symbol, double price) {
            this.symbol = symbol;
            this.price = price;
        }
    }

    public class Coin : Object {

        public string symbol { get; set; }

        public double price { get; set; }

        public Coin(CoinData data) {
            this.symbol = data.symbol;
            this.price = data.price;
        }

        public string get_display_price () {
            int precision = 6;
            if (this.price >= 10 ) {
                precision = 2;
            } else if (this.price >= 1) {
                precision = 3;
            } else if (this.price >= 0.1) {
                precision = 4;
            } else if (this.price >= 0.01) {
                precision = 5;
            }
            return "$%'.*f".printf(precision, this.price);
        }

    }

}