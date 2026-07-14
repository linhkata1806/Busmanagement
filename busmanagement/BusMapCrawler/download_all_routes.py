import os
import json
import time

from busmap import BusMap

# ==========================
# CONFIG
# ==========================

REGION = "hn"

LIST_API = "/web/public/route/list"

SAVE_FOLDER = "routes"

# ==========================

os.makedirs(SAVE_FOLDER, exist_ok=True)

api = BusMap()

print("Đang lấy danh sách tuyến...")

routes = api.get(
    LIST_API,
    {
        "full": 1,
        "regionCode": REGION
    }
)

# Nếu API trả object chứa list
if isinstance(routes, dict):

    if "data" in routes:
        routes = routes["data"]

    elif "routes" in routes:
        routes = routes["routes"]

print(f"Tổng số tuyến: {len(routes)}")

success = 0
fail = 0

for route in routes:

    try:

        route_id = route["routeId"]

        print(f"[{success+fail+1}] Route {route_id}")

        detail = api.get(
            "/web/public/route/detail",
            {
                "routeId": route_id,
                "regionCode": REGION
            }
        )

        filename = os.path.join(
            SAVE_FOLDER,
            f"{route_id}.json"
        )

        with open(
            filename,
            "w",
            encoding="utf-8"
        ) as f:

            json.dump(
                detail,
                f,
                ensure_ascii=False,
                indent=4
            )

        success += 1

        time.sleep(0.15)

    except Exception as ex:

        print("Lỗi:", ex)

        fail += 1

print()

print("======================")

print("Hoàn thành")

print("Success:", success)

print("Fail:", fail)