import numpy as np
from shapely.geometry import Point
from shapely.geometry.polygon import Polygon as Poly
from rtree import index
import heapq

# Polygon data structure
class Room:
    # Constructor
    def __init__(self, id, label, polygon):
        self.id = id
        self.label = label
        self.polygon = polygon

# Vertices data structure
class Vertex:
    # Constructor
    def __init__(self, id, coordinates, connected):
        self.id = id
        self.coordinates = coordinates
        self.connected = np.array(connected)
        self.cost = 0

    # Less Than Operator (used in heap)
    def __lt__(self, other):
        return self.cost < other.cost

# Graph data structure
class Floor:
    # Constructor
    def __init__(self, rooms, vertex):
        self.rooms = np.array(rooms)
        self.vertex = np.array(vertex)

# Algorithm to check if vertex is inside polygon
def vertex_in_room(vertex, room):
    point = Point(vertex.coordinates.x, vertex.coordinates.y)
    poly_repr = room.polygon
    return poly_repr.contains(point)

# Create dictionary for polygons and vertices inside them given a graph
def create_dict(graph):
    graph_dict = {}
    duplicate_vertices = list(graph.vertex)
    duplicate_rooms = list(graph.rooms)
    for room in duplicate_rooms:
        temp_vertices = []
        for vertex in duplicate_vertices:
            if vertex_in_room(vertex, room):
                temp_vertices.append(vertex)
                duplicate_vertices.remove(vertex)
        graph_dict[room.label] = temp_vertices
    return graph_dict

#Given a dictionary and a room, return vertices inside the room
def point_in_room(dict, room1):
    return dict.get(room1)

# Cost function for A* algorithm
# Calculate Euclidean distance between 2 given points
def cost(p1, p2):
    point1 = np.array([p1.x, p1.y])
    point2 = np.array([p2.x, p2.y])
    return np.linalg.norm(point1 - point2)

# A* pathfinding algorithm
def a_star(start, goal, graph):
    queue = [(0, start)]
    current_path = {}
    current_cost = {start.id : 0}
    while queue:
        _, current = heapq.heappop(queue)
        if current == goal:
            break
        for child_id in current.connected:
            child = graph.vertex[child_id]
            new_cost = current_cost[current.id] + cost(current.coordinates, child.coordinates)
            child.cost = new_cost
            if child_id not in current_cost or new_cost < current_cost[child_id]:
                current_cost[child.id] = new_cost
                priority = new_cost + cost(child.coordinates, goal.coordinates)
                heapq.heappush(queue, (priority, child))
                current_path[child] = current

    # Path backtracking
    path = []
    current = goal
    while current != start:
        path.append(current)
        current = current_path[current]
    path.append(start)
    path.reverse()

    return path

