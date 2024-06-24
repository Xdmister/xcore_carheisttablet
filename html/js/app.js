// Import Fetch API
const fetchNUI = async (cbname, data, rscname = rscnamevar) => {
  const options = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: JSON.stringify(data)
  };
  try {
    const resp = await fetch(`https://${rscname}/${cbname}`, options);
    if (resp.ok) {
      const response = await resp.json();
      console.log(response.message);
      return response;
    } else {
      console.error('Chyba při odesílání žádosti:', resp.status);
    }
  } catch (error) {

  }
};


var tablet = document.getElementById("tablet");
var offerList = document.getElementById('offer_list');
var lscreen = document.getElementById('lscreen');
var c_btn = document.getElementById("c_btn");
var panel_car = document.getElementById("car-panel");
var offer_list = document.getElementById("offer_list");
var img_element = document.getElementById("car-img");

var oldofferList = [];

// accepted data
window.addEventListener('message', function(event) {
  var eventData = event.data;
  if (eventData.type === 'open_menu') {
    var rcs = eventData.data.rcs;
    if(rcs == "tablet") {
      tablet.style.display = "flex";
    }
    rscnamevar = eventData.data.rscname;






  } else if (eventData.type === 'close_menu') {
    var rcs = eventData.data.rcs;
    if(rcs == "tablet") {
      if(eventData.data.start_offer != null) {
        display_contract();
      }
      lscreen.classList.remove("l_close");
      lscreen.style.display = "flex";
      tablet.style.display = "none";
    }










  } else if (eventData.type === "offer_list") {
    var offers = eventData.data.offers;

    if(offers.length != oldofferList.length) {
      offerList.innerHTML = "";
      offers.sort();
      offers.forEach(offer => {
        addOfferToOfferList(offer.vehicle_img, offer.name, "$" + offer.price, offer.category, offer.id);
      });
      oldofferList = offers;
    }
    
  } else if (eventData.type === "hide_cbtn") {
    c_btn.style.display = "none";
    panel_car.style.display = "none";
    offerList.style.display = "";
  } else if (eventData.type === "completed_mission") { 
    panel_car.style.display = "none";
    offerList.style.display = "";
  }
});





// html core
function changeTab(number) {
  let maxTab = 5;
  let tabName = number < 10 ? `tab0${number}` : `tab${maxTab}`;
  let currentTab = document.querySelector(`#${tabName}`);
  if (currentTab) {
    currentTab.style.display = '';

    for (let i = 1; i <= maxTab; i++) {
      let tab = document.querySelector(`#tab${i < 10 ? '0' + i : i}`);
      if (tab && tab !== currentTab) {
        tab.style.display = 'none';
      }
    }
  }
}





// keybind
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    const data = {
      menu: "tablet"
    }
    fetchNUI("close_menu", data);
  };
});



function addOfferToOfferList(carImgSrc, carName, carOffer, carCategory, id) {
  var offerList = document.getElementById('offer_list');

  var newOffer = document.createElement('div');
  newOffer.classList.add('offer');

  var vehiclePreview = document.createElement('div');
  vehiclePreview.classList.add('vehicle_preview');

  var carImage = document.createElement('img');
  carImage.src = carImgSrc;
  carImage.alt = '';

  vehiclePreview.appendChild(carImage);

  var offerInfo = document.createElement('div');
  offerInfo.classList.add('offer_info');

  var carNamePara = document.createElement('p');
  carNamePara.classList.add('car_name');
  carNamePara.textContent = carName;

  var carOfferPara = document.createElement('p');
  carOfferPara.classList.add('car_offer');
  carOfferPara.textContent = 'Offer ' + carOffer;

  var carCategoryPara = document.createElement('p');
  carCategoryPara.classList.add('car_category');
  carCategoryPara.textContent = 'Category ' + carCategory;

  offerInfo.appendChild(carNamePara);
  offerInfo.appendChild(carOfferPara);
  offerInfo.appendChild(carCategoryPara);

  var startOfferBtn = document.createElement('button');
  startOfferBtn.classList.add('stole_btn');
  startOfferBtn.textContent = getSLang(config.langue, "btn_stole");
  startOfferBtn.setAttribute('onclick', 'start_offer(' + id + ', "' + carImgSrc + '")');

  newOffer.appendChild(vehiclePreview);
  newOffer.appendChild(offerInfo);
  newOffer.appendChild(startOfferBtn);

  offerList.appendChild(newOffer);
}




function start_offer(id, img) {
  panel_car.style.display = "";
  offerList.style.display = "none";
  img_element.src = img
  const data = {
    offer_id: id
  }
  fetchNUI(rscnamevar + ":start_offer", data);
}





function updateDateTime() {
  var currentDate = new Date();
  var hours = currentDate.getHours();
  var minutes = currentDate.getMinutes();
  var seconds = currentDate.getSeconds();
  hours = hours < 10 ? '0' + hours : hours;
  minutes = minutes < 10 ? '0' + minutes : minutes;
  seconds = seconds < 10 ? '0' + seconds : seconds;
  var day = currentDate.getDate();
  var month = currentDate.getMonth() + 1; 
  var year = currentDate.getFullYear();
  day = day < 10 ? '0' + day : day;
  month = month < 10 ? '0' + month : month;
  document.getElementById('time').textContent = hours + ':' + minutes + ':' + seconds;
  document.getElementById('date').textContent = day + '.' + month + '.' + year;
}
setInterval(updateDateTime, 1000);
updateDateTime();



function cancel_contract() {
  fetchNUI(rscnamevar + ":cancel_offer", null);
  c_btn.style.display = "none";

  panel_car.style.display = "none";
  offerList.style.display = "";
}
function display_contract() {
  c_btn.style.display = "";
}