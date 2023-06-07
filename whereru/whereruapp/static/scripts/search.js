
var room_ids = [
    'HG 00.820', 'HG 00.822', 'HG 00.823', 'HG 00.825', 'HG 00.827', 'HG 00.829', 'HG 00.830', 'HG 00.831', 'HG 00.833', 'HG 00.836', 'HG 00.835', 'HG 00.086', 'HG 00.710', 'HG 00.712', 'HG 00.714', 'HG 00.716', 'HG 00.718', 'HG 00.720', 'HG 00.719', 'HG 00.722', 'HG 00.726', 'HG 00.732', 'HG 00.750', 'HG 00.737', 'HG 00.739', 'HG 00.703', 'HG 00.702', 'HG 00.809', 'HG 00.807', 'HG 00.810', 'HG 00.810A', 'HG 00.811', 'HG 00.812A', 'HG 00.812', 'HG 00.813', 'HG 00.814A', 'HG 00.814', 'HG 00.815', 'HG 00.816', 'HG 00.817', 'HG 00.818', 'HG 00.068', 'HG 00.065', 'HG 00.062', 'HG 00.071', 'HG 00.075', 'HG 00.058', 'HG 00.633', 'HG 00.625', 'HG 00.622', 'HG 00.616', 'HG 00.612', 'HG 00.640', 'HG 00.643', 'HG 00.506', 'HG 00.507', 'HG 00.508', 'HG 00.509', 'HG 00.510', 'HG 00.511', 'HG 00.514', 'HG 00.520', 'HG 00.533', 'HG 00.539', 'HG 00.544', 'HG 00.543', 'HG 00.545', 'HG 00.051', 'HG 00.303', 'HG 00.304', 'HG 00.307', 'HG 00.308', 'HG 00.310'
];
var rooms = room_ids.map(function(room) {
    var roomNumber = room.match(/([\d.]+)/)[0]; // Extract room number using regex
    return {
      code: room,
      number: roomNumber,
      url: 'huygensgebouw/' + roomNumber
    };
  });

// TODO: implement a function (similar to parseRooms), which returns an array of rooms numbers from all files, to be used in the search

// General function to bind a search input to a dropdown
bindSearchInput = (input_id, dropdown_id, items) => {
    var search = document.getElementById(input_id);
    if (search == null) {
        return;
    }
    var dropdown = document.getElementById(dropdown_id);
    search.addEventListener('input', function() {
        var value = search.value;
        //first delete all children of dropdown
        while (dropdown.firstChild) {
            dropdown.removeChild(dropdown.firstChild);
        }
        //then add all matching rooms
        for (var i = 0; i < items.length; i++) {
            if (items[i].code.toLowerCase().includes(value.toLowerCase())) {
                var a = document.createElement('a');
                a.classList.add('dropdown-item');
                a.href = '/building/' + encodeURI(items[i].url);
                a.innerHTML = items[i].code;
                dropdown.appendChild(a);
            }
        }
        //Append class `is-active` to the dropdown first child
        if (dropdown.firstChild && value.length > 0) {
            dropdown.firstChild.classList.add('is-active');
            dropdown.style.display = 'block';
        } else {
            dropdown.style.display = 'none';
        }
    }
    );
    //if the user clicks outside the search bar, hide the dropdown
    window.onclick = function(event) {
        if (!event.target.matches('#' + input_id)) {
            dropdown.style.display = 'none';
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    bindSearchInput('main-search', 'main-dropdown', rooms);
    bindSearchInput('navbar-search', 'navbar-dropdown', rooms);
});