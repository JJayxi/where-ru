let map;
let markers = [];
const buildings = [{
    position: {
        lat: 51.82398443256712,
        lng: 5.8687030797282755,
    },
    title: "Huygensgebouw",
    url: "/huygensgebouw/",
}, {
    position: {
        lat: 51.822690301600424,
        lng: 5.8685910099065905,
    },
    title: "Linnaeusgebouw",
    url: "/linnaeusgebouw/",
}, {
    position: {
        lat: 51.81914002167248,
        lng: 5.867595985094993,
    },
    title: "Elinor Ostromgebouw",
    url: "/elinor-ostromgebouw/",
}, {
    position: {
        lat: 51.818492828149694,
        lng: 5.867567143392216,
    },
    title: "Radboud Sports Centre",
    url: "/radboud-sports-centre/",
}, {
    position: {
        lat: 51.819609934194304,
        lng: 5.860067035940363,
    },
    title: "Spinozagebouw",
    url: "/spinozagebouw/",
}, {
    position: {
        lat: 51.8190761954929,
        lng: 5.86595610138141,
    },
    title: "Erasmusgebouw",
    url: "/erasmusgebouw/",
}, {
    position: {
        lat: 51.81890907596025,
        lng: 5.863889122596422,
    },
    title: "Thomas van Aquinostraat",
    url: "/thomas-van-aquinostraat/",
}, {
    position: {
        lat: 51.81933439317513,
        lng: 5.8643686753735516,
    },
    title: "Collegezalencomplex",
    url: "/collegezalencomplex/",
}, {
    position: {
        lat: 51.819707312212365,
        lng: 5.865357967755583,
    },
    title: "Central Library",
    url: "/central-library/",
}, {
    position: {
        lat: 51.81910756183138,
        lng: 5.8583435082680095,
    },
    title: "Grotiusgebouw",
    url: "/grotiusgebouw/",
}, {
    position: {
        lat: 51.8191155593847,
        lng: 5.861848357256142,
    },
    title: "Maria Montessorigebouw",
    url: "/maria-montessorigebouw/",
},
{
    position: {
        lat: 51.8254353810976,
        lng: 5.8687269217261795,
    },
    title: "Mercator 1",
    url: "/mercator-1/",
}];

const intersectionObserver = new IntersectionObserver((entries) => {
    for (const entry of entries) {
        if (entry.isIntersecting) {
            entry.target.classList.add('drop');
            intersectionObserver.unobserve(entry.target);
        }
    }
});


async function createMarker(building) {
    const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
    const advancedMarker = new AdvancedMarkerElement({
        map,
        position: building.position,
        title: building.title,
        content: new PinElement({
            glyphColor: "#FFF",
            background: "#333",
            borderColor: "#333",
        }).element,
    });
    advancedMarker.addListener("click", () => {
        const infoWindowContent = document.createElement("div");
        const infoText = document.createElement("p");
        infoText.textContent = building.title;
        infoWindowContent.appendChild(infoText);
        infoWindowContent.addEventListener("click", () => {
            window.location.href = '/building' + building.url;
        });

        const infoWindow = new google.maps.InfoWindow({
            content: infoWindowContent,
        });

        infoWindow.open(map, advancedMarker);
    });


    const element = advancedMarker.content;// as HTMLElement;
    element.style.opacity = '0';
    element.addEventListener('animationend', (event) => {
        element.classList.remove('drop');
        element.style.opacity = '1';
    });
    const time = 0.6 + Math.random(); // 2s delay for easy to see the animation
    element.style.setProperty('--delay-time', time + 's');
    intersectionObserver.observe(element);
    markers.push(advancedMarker);
}


async function initMap() {
    //Lat is for N/S, Long is for E/W
    const position = { lat: 51.822900, lng: 5.862480 };
    // Request needed libraries.
    // @ts-ignore
    const { Map } = await google.maps.importLibrary("maps");

    map = new Map(document.getElementById("map"), {
        zoom: 15,
        center: position,
        mapId: 'b740dc8692941f9d',
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: false,
        zoomControl: false,
    });

    buildings.forEach((building) => createMarker(building));

    // Add zoom controls if they are present on the page.
    var zoomInButton = document.getElementById('zoomIn');
    var zoomOutButton = document.getElementById('zoomOut');
    if (zoomInButton && zoomOutButton) {    
    
        zoomInButton.addEventListener('click', function() {
          map.setZoom(map.getZoom() + 0.5); 
        });
      
        zoomOutButton.addEventListener('click', function() {
          map.setZoom(map.getZoom() - 0.5); 
        });
    }
}

initMap();