import main
import read_file
import numpy as np

file_name = 'Resources/0500BR01.txt'
rooms = read_file.read_file_polygon(file_name)

file_name = "Resources/0500BR01_graph-2.txt"
vertices = read_file.read_file_vertice(file_name)

def test_a_star():
    floor = main.Floor(rooms, vertices)
    # Test for a path between a combination of 500 rooms
    for x in range(500):
        start = np.random.choice(floor.vertex)
        goal = np.random.choice(floor.vertex)
        path = main.a_star(start, goal, floor)
        if len(path) == 0:
            print(f"No path exists between {start.id} and {goal.id}")
        else:
            print(f"Path between {start.id} and {goal.id}:", [vertex.id for vertex in path])
        print(x)

test_a_star()