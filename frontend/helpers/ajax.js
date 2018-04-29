import * as request from "superagent"
import * as env from "../env"

function getCookies () {
  const cookies = {}
  document.cookie.split(';').forEach(function (part) {
    const [k, v] = part.trim().split('=')
    cookies[k] = v
  })
  return cookies
}

export function getSSID () {
  return getCookies().gp_ssid
}

export function ajax (method, path, headers={}, body) {
  return new Promise(function (resolve, reject) {

    headers = headers == null ? {} : headers
    console.log('CALLING', method, path, headers, body)

    headers.SSID = getSSID()
    var call = request[method](`${env.base}${path}`)

    for (var k in headers) {
      call = call.set(k, headers[k])
    }

    if (body != null) {
      call = call.set('Content-Type', 'application/json')
      call.send(body)
    }

    return call.end(function (err, result) {
      if (err) {
        const message = err.response != null && err.response.body != null && err.response.body.error != null ? err.response.body.error : err.message
        return reject({ message, err, response: err.response })
      }

      if (result.body != null && result.body.ssid != null) {
        document.cookie = `gp_ssid=${result.body.ssid};max-age=31536000;domain=${env.domain}`
      }
      return resolve(result)
    })

  })
}
