import strformat
import strutils
import re
import os

import jester
import json
import asyncnet
import asyncdispatch
import nwt

var templates = newNwt("templates/*.html") 

settings:
  port = 8000.Port
  staticDir = "static"
  appName = "" 
  bindAddr = "0.0.0.0"
  reusePort = false

routes:
  get "/":
    resp templates.renderTemplate("index.html")
  
  get re"^\/(.*)\.(?:html|txt|css|js|min\.js|jpg|png|bmp|svg|gif)$":
    if "templates" notin request.path:
      sendFile(request.path.strip(chars={'/'}, leading=true))
  
  get "/explicitJSON":
    const data = $(%*{"message": "Hello, World!"})
    resp data, "application/json"
  
  get "/explicitJsonFromSeq":
    let test = @[
      %*{
        "message": "Hello, World!"
      },
      %*{
        "message2": @[
          %*{
            "nested": "works",
          }
        ]
      },
    ] 
    resp ($test).strip(chars={'@'}, leading=true), "application/json"
  
  get "/implicitJSON":
    resp %*{
      "string": "string",
      "number": 1,
      "float": 1.33
    }
  
  # get re"^\/(.*)\.txt$":
  #   resp request.matches[0]