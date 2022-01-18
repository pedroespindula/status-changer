import json

from os import environ
from flask import Flask, request, Response

from datetime import datetime

DEFAULT_STATUS = environ.get("STATUS_INICIAL") or 200

port = environ.get("PORT") or 80


app = Flask(__name__)

start_time = str(datetime.now())


@app.route("/", methods=["GET", "POST"])
def status():
    status_code = DEFAULT_STATUS

    if request.method == "POST":
        status_code = request.json["status_code"] or DEFAULT_STATUS

    body = {
        "servico": "status_changer",
        "timestamp": str(datetime.now()),
        "status_code": int(status_code),
        "iniciado_em": start_time
    }

    return Response(
        json.dumps(body),
        status=status_code,
        mimetype="application/json"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=port, debug=True)
