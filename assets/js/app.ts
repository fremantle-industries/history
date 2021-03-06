import "../css/app.css"
import "phoenix_html"
import { Socket } from "phoenix"
import * as NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import Alpine from 'alpinejs'
import { hooks } from "./hooks"

window.Alpine = Alpine

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket(
  "/live",
  Socket,
  {
    params: { _csrf_token: csrfToken },
    dom: {
      onBeforeElUpdated(from, to) {
        if (from._x_dataStack) {
          window.Alpine.clone(from, to)
        }

        return true
      }
    },
    hooks: hooks,
  },
)

Alpine.start()

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", _ => NProgress.start())
window.addEventListener("phx:page-loading-stop", _ => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// window.liveSocket = liveSocket
