// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
// import "../css/app.css"
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"


let Hooks = {}
Hooks.SelectCategories = {
    mounted() {
        let hook = this,
            $select = jQuery(hook.el).find("select");

        $select.select2({
            multiple: true, tags: true,
            createTag(params) {
                var term = jQuery.trim(params.term);

                // Empty or only a number
                if (term === '' || /^\d+$/.test(term)) {
                    return null;
                }

                return {
                    id: term,
                    text: term
                }
            }
        })
            .on("select2:select", (e) => hook.selected(hook, e))

        return $select;
    },

    selected(hook, event) {
        let id = event.params.data.id;
        console.log(id)
        //hook.pushEvent("country_selected", { country: id })
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

