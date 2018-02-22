namespace CryptoWatcher {

    public class Application : Gtk.Application {

        public Application () {
            Object (
                application_id: "com.github.flore2003.crypto-watcher",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        protected override void activate () {
            if (get_windows ().length () > 0) {
                get_windows ().data.present ();
                return;
            }

            var app_window = new MainWindow (this);
            app_window.show_all ();

            // Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;

            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path ("/com/github/flore2003/crypto-watcher/");

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("com/github/flore2003/crypto-watcher/style.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        }

        public static int main (string [] args) {
            var app = new Application ();
            return app.run (args);
        }

    }

}
