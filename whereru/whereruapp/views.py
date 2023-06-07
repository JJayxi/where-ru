from django.shortcuts import render
import whereruapp.pathfinder.pathfinder_model as pathfinder_model
from django.http import JsonResponse

# Global things
buildings = [
    {
        "position": {
            "lat": 51.82398443256712,
            "lng": 5.8687030797282755
        },
        "title": "Huygensgebouw",
        "url": "/huygensgebouw/"
    },
    {
        "position": {
            "lat": 51.822690301600424,
            "lng": 5.8685910099065905
        },
        "title": "Linnaeusgebouw",
        "url": "/linnaeusgebouw/"
    },
    {
        "position": {
            "lat": 51.81914002167248,
            "lng": 5.867595985094993
        },
        "title": "Elinor Ostromgebouw",
        "url": "/elinor-ostromgebouw/"
    },
    {
        "position": {
            "lat": 51.818492828149694,
            "lng": 5.867567143392216
        },
        "title": "Radboud Sports Centre",
        "url": "/radboud-sports-centre/"
    },
    {
        "position": {
            "lat": 51.819609934194304,
            "lng": 5.860067035940363
        },
        "title": "Spinozagebouw",
        "url": "/spinozagebouw/"
    },
    {
        "position": {
            "lat": 51.8190761954929,
            "lng": 5.86595610138141
        },
        "title": "Erasmusgebouw",
        "url": "/erasmusgebouw/"
    },
    {
        "position": {
            "lat": 51.81890907596025,
            "lng": 5.863889122596422
        },
        "title": "Thomas van Aquinostraat",
        "url": "/thomas-van-aquinostraat/"
    },
    {
        "position": {
            "lat": 51.81933439317513,
            "lng": 5.8643686753735516
        },
        "title": "Collegezalencomplex",
        "url": "/collegezalencomplex/"
    },
    {
        "position": {
            "lat": 51.819707312212365,
            "lng": 5.865357967755583
        },
        "title": "Central Library",
        "url": "/central-library/"
    },
    {
        "position": {
            "lat": 51.81910756183138,
            "lng": 5.8583435082680095
        },
        "title": "Grotiusgebouw",
        "url": "/grotiusgebouw/"
    },
    {
        "position": {
            "lat": 51.8191155593847,
            "lng": 5.861848357256142
        },
        "title": "Maria Montessorigebouw",
        "url": "/maria-montessorigebouw/"
    },
    {
        "position": {
            "lat": 51.8254353810976,
            "lng": 5.8687269217261795
        },
        "title": "Mercator 1",
        "url": "/mercator-1/"
    }
]
# Helper functions
def find_building(id):
    for building in buildings:
        if building['url'] == "/" + id + "/":
            return building
    return None

context = {
    'buildings': buildings,
    'building_urls': [f"/building{building['url']}" for building in buildings]
}

# Create your views here.
def getpath(request):
    # if request.method != 'POST':
    #     return JsonResponse({'start_room': '', 'end_room': '', 'path_vertex_ids': []})
    start_room = request.GET.get('start_room', '')
    end_room = request.GET.get('end_room', '')
    if start_room == '' or end_room == '':
        return JsonResponse({'start_room': '', 'end_room': '', 'path_vertex_ids': []})
    path_vertex_ids = pathfinder_model.findPath(start_room, end_room)
    if path_vertex_ids == None or len(path_vertex_ids) == 0:
        path_vertex_ids = [-1]
    return JsonResponse({'start_room': start_room, 'end_room': end_room, 'path_vertex_ids': path_vertex_ids })

def home(request):
    return render(request, 'home.html', context)

def map(request):
    return render(request, "./map.html", context)

def building(request, id, room_id=0):
    # If the id is not in the list of buildings, return 404
    if ("/building/" + id + "/") not in context["building_urls"]:
        return render(request, "./404.html", context)
    # TODO: check whether the room_id is in the building
    # variable coming_soon equals True if the building is not yet implemented 
    # If the building = huygensgebouw, then coming_soon = False
    coming_soon = True
    if id == "huygensgebouw":
        coming_soon = False
    return render(request, "./building.html", { "room_id": room_id, "building" : find_building(id), "coming_soon": coming_soon, "buildings": context["buildings"] })
