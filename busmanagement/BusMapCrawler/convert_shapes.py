import json
import os

INPUT_DIR = "routes"
OUTPUT_DIR = "assets/shapes"

os.makedirs(OUTPUT_DIR, exist_ok=True)


def parse_path(path):
    points = []

    if not path:
        return points

    for item in path.strip().split():

        try:
            lng, lat = item.split(",")

            points.append([
                round(float(lat),7),
                round(float(lng),7)
            ])
        except:
            pass

    return points


for filename in os.listdir(INPUT_DIR):

    if not filename.endswith(".json"):
        continue

    filepath = os.path.join(INPUT_DIR, filename)

    with open(filepath, "r", encoding="utf-8") as f:
        route = json.load(f)

    route_no = route["routeNo"]

    direction0 = []
    direction1 = []

    for station in route["stations"]:

        pts = parse_path(
            station.get("pathPoints","")
        )

        if station["stationDirection"] == 0:
            direction0.extend(pts)
        else:
            direction1.extend(pts)

    # bỏ trùng
    def unique(arr):

        new = []
        seen = set()

        for p in arr:

            key = (p[0],p[1])

            if key not in seen:
                seen.add(key)
                new.append(p)

        return new

    direction0 = unique(direction0)
    direction1 = unique(direction1)

    with open(
        os.path.join(
            OUTPUT_DIR,
            f"{route_no}_0.json"
        ),
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(direction0,f)

    with open(
        os.path.join(
            OUTPUT_DIR,
            f"{route_no}_1.json"
        ),
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(direction1,f)

    print(route_no,"OK")

print("DONE")