import shapely

import main
import numpy as np
from shapely.geometry import Point
from shapely.geometry.polygon import Polygon as Poly

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
                corner = shapely.Point(x, y)
                corners.append(corner)
            cur = main.Room(polygon_id, label, Poly(corners))
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
                cur = shapely.Point(int(parts[0]), int(parts[1]))
                coordinates.append(cur)
        for line in file:
            line = line.strip()
            parts = line.split(':')
            vert_id = int(parts[0])
            connected_verts = parts[1].split(',')
            connected = []
            for vert in connected_verts:
                connected.append(int(vert))
            cur = main.Vertex(vert_id, coordinates[vert_id], connected)
            vertices.append(cur)
    return vertices
