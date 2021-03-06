package modules.market_service;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.market.Market;
import beluga.module.account.Account;

// BelugaDemo
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class MarketService implements MetadataReader {
    public var beluga(default, null) : Beluga;
    public var market(default, null) : Market;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.market = beluga.getModuleInstance(Market);
    }

    @bTrigger("beluga_market_add_product_to_cart_success",
             "beluga_market_add_product_to_cart_fail")
    public static function _doMarketPage() {
       new MarketService(Beluga.getInstance()).doMarketPage();
    }

    public function doMarketPage() {
        var marketWidget = this.market.getWidget("display");
        marketWidget.context = this.market.getDisplayContext();

        var html = Renderer.renderDefault("page_market_widget", "The market", {
            marketWidget: marketWidget.render(),
        });
        Sys.print(html);
    }

    @bTrigger("beluga_market_remove_product_in_cart_fail",
             "beluga_market_remove_product_in_cart_success",
             "beluga_market_checkout_cart_fail")
    public static function _doCartPage() {
       new MarketService(Beluga.getInstance()).doCartPage();
    }

    public function doCartPage() {
        var marketCartWidget = this.market.getWidget("cart");
        marketCartWidget.context = this.market.getCartContext();

        var html = Renderer.renderDefault("page_market_widget", "Your Cart", {
            marketWidget: marketCartWidget.render(),
        });
        Sys.print(html);
    }

    public function doAdminPage() {
        var marketAdminWidget = this.market.getWidget("admin");
        marketAdminWidget.context = this.market.getAdminContext();

        var html = Renderer.renderDefault("page_market_admin_widget", "Market administration", {
            marketAdminWidget: marketAdminWidget.render(),
        });
        Sys.print(html);
    }

    @bTrigger("beluga_market_checkout_cart_success")
    public static function _doCheckoutSuccess() {
        new MarketService(Beluga.getInstance()).doCartPage();
    }

    public function doDefault(d : Dispatch) { MarketService._doMarketPage(); }
}