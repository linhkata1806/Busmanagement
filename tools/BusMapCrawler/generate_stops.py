import os
import json

ROUTES_FOLDER = "routes"
OUTPUT_FOLDER = "sql"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

stops = {}
next_stop_id = 1


def sql_string(text):
    if text is None:
        return "NULL"

    text = str(text).replace("'", "''")
    return f"N'{text}'"


# Đọc tất cả file json
for file_name in sorted(os.listdir(ROUTES_FOLDER)):
    if not file_name.endswith(".json"):
        continue

    file_path = os.path.join(ROUTES_FOLDER, file_name)

    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    if "stations" not in data:
        continue

    for station in data["stations"]:

        stop_name = station.get("stationName", "").strip()

        latitude = station.get("lat", 0)
        longitude = station.get("lng", 0)

        address = station.get("address", "")

        key = (
            stop_name.lower(),
            round(float(latitude), 7),
            round(float(longitude), 7)
        )

        if key in stops:
            continue

        stops[key] = {
            "StopID": next_stop_id,
            "StopName": stop_name,
            "Address": address,
            "Latitude": latitude,
            "Longitude": longitude
        }

        next_stop_id += 1


output = os.path.join(OUTPUT_FOLDER, "Stops.sql")

with open(output, "w", encoding="utf-8") as f:

    f.write("SET IDENTITY_INSERT Stops ON;\n\n")

    for stop in stops.values():

        address = sql_string(stop["Address"])

        if address == "N''":
            address = "NULL"

        f.write(
            "INSERT INTO Stops "
            "(StopID, StopName, Address, Latitude, Longitude, IsActive) VALUES "
            f"({stop['StopID']}, "
            f"{sql_string(stop['StopName'])}, "
            f"{address}, "
            f"{stop['Latitude']}, "
            f"{stop['Longitude']}, "
            "1);\n"
        )

    f.write("\nSET IDENTITY_INSERT Stops OFF;\n")

print("=" * 50)
print("Done!")
print("Total Stops:", len(stops))
print("Output:", output)