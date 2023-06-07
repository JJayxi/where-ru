import main
import read_file

file_name = 'Resources/0500BR01.txt'
polygons = read_file.read_file_polygon(file_name)

file_name = "Resources/0500BR01_graph-2.txt"
vertices = read_file.read_file_vertice(file_name)

# Print the vertices for verification
for vertex in vertices:
    print(f"Vertex ID: {vertex.id}")
    print(f"Coordinates: ({vertex.coordinates.x}, {vertex.coordinates.y})")
    print(f"Connected Vertices: {vertex.connected}")
    print("-----")

graph = main.Floor(polygons, vertices)



