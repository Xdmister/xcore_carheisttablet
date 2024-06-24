var lang = {
    "eng": {
        "btn_stole": "STOLE",
        "click_to_open": "Click to unlock",
        "cance_co": "CANCEL<br>CONTRACT",
        "dialog_1": "The car I have to steal"
    },
    "cz": {
        "btn_stole": "UKRÁST",
        "click_to_open": "Klikněte pro odemknutí",
        "cance_co": "ZRUŠIT<br>KONTRAKT",
        "dialog_1": "Auto, které musím ukrást"
    },
    "pl": {
        "btn_stole": "UKRAŚĆ",
        "click_to_open": "Kliknij, aby odblokować",
        "cance_co": "ANULUJ<br>KONTRAKT",
        "dialog_1": "Samochód, który muszę ukraść"
    },
    "de": {
        "btn_stole": "STEHLEN",
        "click_to_open": "Klicken zum Entsperren",
        "cance_co": "VERTRAG<br>STORNIEREN",
        "dialog_1": "Das Auto, das ich stehlen muss"
    },
    "sk": {
        "btn_stole": "UKRADNÚŤ",
        "click_to_open": "Kliknite pre odomknutie",
        "cance_co": "ZRUŠIŤ<br>KONTRAKT",
        "dialog_1": "Auto, ktoré musím ukradnúť"
    }
};





function getLang(lg, rc) {
    var x = lang[lg];
    if (x && x[rc]) {
        document.write(x[rc]);
    } else {
        document.write("NO LANG STRING");
    }
}

function getSLang(lg, rc) {
    var x = lang[lg];
    if (x && x[rc]) {
        return x[rc];
    } else {
        return "NO LANG STRING";
    }
}