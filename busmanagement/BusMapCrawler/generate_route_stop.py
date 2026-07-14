import os
import json
import math

ROUTES_FOLDER = "routes"
OUTPUT_FOLDER = "sql"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# -----------------------------
# Đọc Stops theo đúng thứ tự đã tạo
# -----------------------------
stop_map = {}
next_stop_id = 1

for file_name in sorted(os.listdir(ROUTES_FOLDER)):
    if not file_name.endswith(".json"):
        continue

    with open(os.path.join(ROUTES_FOLDER, file_name), "r", encoding="utf-8") as f:
        data = json.load(f)

    for station in data.get("stations", []):

        name = station.get("stationName", "").strip()

        lat = float(station.get("lat", 0))
        lng = float(station.get("lng", 0))

        key = (
            name.lower(),
            round(lat, 7),
            round(lng, 7)
        )

        if key not in stop_map:
            stop_map[key] = next_stop_id
            next_stop_id += 1


# -----------------------------
# Hàm tính khoảng cách GPS
# -----------------------------
def haversine(lat1, lon1, lat2, lon2):

    R = 6371.0

    lat1 = math.radians(lat1)
    lon1 = math.radians(lon1)
    lat2 = math.radians(lat2)
    lon2 = math.radians(lon2)

    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(lat1)
        * math.cos(lat2)
        * math.sin(dlon / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c


# -----------------------------
# Sinh Route_Stop.sql
# -----------------------------
route_id = 1

output = os.path.join(OUTPUT_FOLDER, "Route_Stop.sql")

with open(output, "w", encoding="utf-8") as out:

    for file_name in sorted(os.listdir(ROUTES_FOLDER)):

        if not file_name.endswith(".json"):
            continue

        with open(os.path.join(ROUTES_FOLDER, file_name), "r", encoding="utf-8") as f:
            data = json.load(f)

        stations = data.get("stations", [])

        total_distance = 0.0

        prev_lat = None
        prev_lng = None

        stop_order = 1

        for station in stations:

            name = station.get("stationName", "").strip()

            lat = float(station.get("lat", 0))
            lng = float(station.get("lng", 0))

            key = (
                name.lower(),
                round(lat, 7),
                round(lng, 7)
            )

            if key not in stop_map:
                continue

            stop_id = stop_map[key]

            if prev_lat is not None:

                total_distance += haversine(
                    prev_lat,
                    prev_lng,
                    lat,
                    lng
                )

            out.write(
                "INSERT INTO Route_Stop "
                "(RouteID, StopID, StopOrder, DistanceFromStart) "
                f"VALUES ({route_id}, {stop_id}, {stop_order}, {round(total_distance,2)});\n"
            )

            prev_lat = lat
            prev_lng = lng

            stop_order += 1

        route_id += 1

print("=" * 50)
print("Done!")
print("Output:", output)