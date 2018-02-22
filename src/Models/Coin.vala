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

    }

}