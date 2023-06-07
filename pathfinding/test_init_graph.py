import main
import read_file

file_name = 'Resources/0500BR01.txt'
rooms = read_file.read_file_polygon(file_name)

file_name = "Resources/0500BR01_graph-2.txt"
vertices = read_file.read_file_vertice(file_name)

graph = main.Floor(rooms, vertices)
test = main.create_dict(graph)
for polygon in test.keys():
    print(f"Polygon : {polygon}")
    for vertex in test.get(polygon):
        print(f"({vertex.coordinates.x}, {vertex.coordinates.y})")

