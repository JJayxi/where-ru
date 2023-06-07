# Where RU

‘Where RU’ is a web application built to facilitate navigation inside the Radboud University campus. It does this by providing a comprehensive overview of all the buildings and rooms in the campus, and by providing tools such as pathfinder and travel time calculator between locations.

Currently, navigating to a room consists in first finding the name of the building by looking up the abbreviation, locating the building on the campus map, using a navigation tool like google maps to find the direction to that building and inside the building, look at the floor plans to finally locate the room.

Unlike this multi-step process, our application provides a user-friendly unified solution, enabling students, employees as well as guests to quickly and efficiently navigate to their desired location.

Although tools like Maze Map exist which provide navigation inside buildings, none contain information about the Radboud University campus. In addition, our application focuses on the Radboud University campus and provides a more comprehensive solution.

While the exact details of the final implementation are subject to change, the goal remains to create a comprehensive user-friendly map application for the Radboud University campus.

This project is build as part of the **R&D course** in 2023. More details on the project can be found on the associated google drive folder: https://drive.google.com/drive/folders/1NjeGLPr5BT2QNjzpb2qpH89K0gRYyBde?usp=sharing

The **figma** project used for prototyping can be found here: https://www.figma.com/file/Unj3Aw1F9OVqijZZElSw6A/Where-RU-Prototype?node-id=0%3A1&t=MdvFvaqkBG5gwyUo-1


## Running the app

To run the Where RU app you need to have **Python** and **Django** installed. To see what versions are compatible follow [this link](https://docs.djangoproject.com/en/4.0/faq/install/#what-python-version-can-i-use-with-django). You can either install Django on you global environment (default) or use a python virtual environment. 

Instructions on how to set up the **python virtual environment** can be found [here](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/development_environment#using_django_inside_a_python_virtual_environment). Some useful commands for usage:
-   `deactivate`  — Exit out of the current Python virtual environment
-   `workon`  — List available virtual environments
-   `workon name_of_environment`  — Activate the specified Python virtual environment
-   `rmvirtualenv name_of_environment`  — Remove the specified environment.

When Django is installed run the app with:
```
python manage.py runserver
```
and navigate to the specified local host which by default is http://127.0.0.1:8000/.


## Annotator Program

To use the annotator program, modify the file name that you want to load in the `annotate.pde` file. Use `z` to undo, `s` to save and load the file that is called the save except with .txt extension. Use space to submit the polygon you have to the list of rooms. Remember, you can use undo to remove it. And you can remove the polygon from the txt file manually if you want to delete a specific one.