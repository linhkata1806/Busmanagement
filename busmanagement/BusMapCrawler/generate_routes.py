import os
import json

ROUTES_FOLDER = "routes"
OUTPUT_FOLDER = "sql"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)


def sql_string(text):
    if text is None:
        return "NULL"

    text = str(text).strip()

    if text == "":
        return "NULL"

    text = text.replace("'", "''")

    return f"N'{text}'"


def get_text(data, *keys, default="Chưa cập nhật"):
    for key in keys:
        value = data.get(key)
        if value is not None and str(value).strip() != "":
            return str(value).strip()
    return default


def get_number(data, *keys, default=0):
    for key in keys:
        value = data.get(key)
        if value is None:
            continue

        try:
            return float(value)
        except:
            continue

    return default


route_id = 1

output = os.path.join(OUTPUT_FOLDER, "Routes.sql")

with open(output, "w", encoding="utf-8") as f:

    f.write("SET IDENTITY_INSERT Routes ON;\n\n")

    for file_name in sorted(os.listdir(ROUTES_FOLDER)):

        if not file_name.endswith(".json"):
            continue

        with open(os.path.join(ROUTES_FOLDER, file_name), encoding="utf-8") as file:

            data = json.load(file)

        route_number = get_text(data, "routeNo", default=str(route_id))
        route_name = get_text(data, "routeName")

        start_point = get_text(
            data,
            "startStop",
            "startStation",
            "startPoint"
        )

        end_point = get_text(
            data,
            "endStop",
            "endStation",
            "endPoint"
        )

        operating = get_text(
            data,
            "operationTime",
            "operationHours"
        )

        frequency = get_text(
            data,
            "headway",
            "frequency"
        )

        ticket = get_number(
            data,
            "normalTicket",
            "ticketPrice"
        )

        distance = get_number(
            data,
            "distance",
            "routeDistance"
        )

        duration = int(
            get_number(
                data,
                "estimateTime",
                "duration"
            )
        )

        f.write(
            "INSERT INTO Routes "
            "(RouteID,RouteNumber,RouteName,StartPoint,EndPoint,"
            "OperatingHours,Frequency,TicketPrice,TotalDistance,EstimatedDuration)"
            " VALUES "
            f"({route_id},"
            f"'{route_number}',"
            f"{sql_string(route_name)},"
            f"{sql_string(start_point)},"
            f"{sql_string(end_point)},"
            f"{sql_string(operating)},"
            f"{sql_string(frequency)},"
            f"{ticket},"
            f"{distance},"
            f"{duration}"
            ");\n"
        )

        route_id += 1

    f.write("\nSET IDENTITY_INSERT Routes OFF;\n")

print("=" * 50)
print("Done!")
print("Routes:", route_id - 1)
print("Output:", output)