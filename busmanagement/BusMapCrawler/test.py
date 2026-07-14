from busmap import BusMap

api = BusMap()

route = api.get(
    "/web/public/route/detail",
    {
        "routeId":74,
        "regionCode":"hn"
    }
)

print(route["routeName"])
print(route["routeNo"])

print(len(route["stations"]))