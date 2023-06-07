from os import getcwdb
import numpy as np
from shapely.geometry import Point
from shapely.geometry.polygon import Polygon as Poly
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
def create_graph_dict(graph):
    graph_dict = {}
    duplicate_vertices = list(graph.vertex)
    duplicate_rooms = list(graph.rooms)
    for room in duplicate_rooms:
        temp_vertices = []
        for vertex in duplicate_vertices:
            if vertex_in_room(vertex, room):
                temp_vertices.append(vertex)
        graph_dict[room.label] = temp_vertices

    return graph_dict

# Given a graph, return a dictionary with room labels as the value and the rooms as the keys
def create_label_to_room_dict(floor):
    room_dict = {}
    duplicate_rooms = list(floor.rooms)
    for room in duplicate_rooms:
        room_dict[room.label] = Room(room.id, room.label, room.polygon)
    return room_dict

# Given a graph dictionary and a room, return vertices inside the room
def point_in_room(dict, room):
    return dict.get(room, [])  # Return an empty list if the room is not found

# Cost function for A* algorithm
# Calculate Euclidean distance between 2 given points
def cost(p1, p2):
    return np.linalg.norm(np.array([p1.x, p1.y]) - np.array([p2.x, p2.y]))

# A* pathfinding algorithm
def a_star(start, goal, graph):
    if start == None or goal == None:
        return []
    
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

# Given 2 room IDs, return the path between these rooms
def room_pathfind(graph, floor_dictionary, start_room, goal_room):
    # Pick start and goal vertices :
    min = 9999
    start_vertex = None
    goal_vertex = None

    # check that the room exist
    if start_room not in floor_dictionary or goal_room not in floor_dictionary:
        return []

    # Iterate over all start and goal vertices to find a combination with the least distance
    for s_vertex in floor_dictionary[start_room]:
        for g_vertex in floor_dictionary[goal_room]:
            v_cost = cost(s_vertex.coordinates, g_vertex.coordinates)
            if v_cost < min:
                min = v_cost
                start_vertex = s_vertex
                goal_vertex = g_vertex

    # Return path
    return a_star(start_vertex, goal_vertex, graph)

########################
# File reading methods #
########################

# Read polygon from file into data structure
def read_file_polygon(file_name):
    polygons = []
    with open(file_name, 'r') as file:
        for line in file:
            line = line.strip()
            parts = line.split(':')
            polygon_id = int(parts[1])
            label = parts[0]
            coordinates = parts[2].split(';')
            corners = []
            for coord in coordinates:
                x, y = map(int, coord.split())
                corner = Point(x, y)
                corners.append(corner)
            cur = Room(polygon_id, label, Poly(corners))
            polygons.append(cur)
    return polygons

# Read vertices from file into data structure
def read_file_vertice(file_name):
    vertices = []
    coordinates = []
    separator = '-------'
    with open(file_name, 'r') as file:
        for line in file:
            if separator in line:
                break
            else:
                line = line.strip()
                parts = line.split(',')
                cur = Point(int(parts[0]), int(parts[1]))
                coordinates.append(cur)
        for line in file:
            line = line.strip()
            parts = line.split(':')
            vert_id = int(parts[0])
            connected_verts = parts[1].split(',')
            connected = []
            for vert in connected_verts:
                connected.append(int(vert))
            cur = Vertex(vert_id, coordinates[vert_id], connected)
            vertices.append(cur)
    return vertices

######################
# Main pathfinding   #
######################


# floor, floor_dictionary, label_to_room
floor_data = [None, None, None]

def init():
    file_name = 'whereruapp/static/mapdata/huygens/floor1/rooms.txt'
    polygons = read_file_polygon(file_name)

    file_name = 'whereruapp/static/mapdata/huygens/floor1/paths.txt'
    vertices = read_file_vertice(file_name)

    floor_data[0] = Floor(polygons, vertices)
    floor_data[1] = create_graph_dict(floor_data[0])
    floor_data[2] = create_label_to_room_dict(floor_data[0])

def findPath(start_room, end_room):
    path_vertices = room_pathfind(floor_data[0], floor_data[1], start_room, end_room)
    print(path_vertices)
    return [vertex.id for vertex in path_vertices]
