var selectedChar = null;
MultiChar = {}

$(document).ready(function (){
    window.addEventListener('message', function (event) {
        var data = event.data;

        if (data.action == "ui") {
            if (data.toggle) {
                $('.character-list').fadeIn(1000);
                $('.character-list-buttons').hide();

                $.post('http://mbl-multicharacterv2/setupCharacters');
                $.post('http://mbl-multicharacterv2/removeBlur');

            } else {
                $('.character-list').fadeOut(250);
            }
        }
        if (data.time == "aksam") {
            console.log("32131231")
        } else if (data.time == "sabah") {
            console.log("asabababa")
        }
        if (data.action == "setupCharacters") {
            setupCharacters(event.data.characters)
        }
    });
});

function setupCharacters(characters) {
    $.each(characters, function(index, char){
        $('#char-'+char.cid).html("");
        $('#char-'+char.cid).data("citizenid", char.citizenid);

        $('#char-'+char.cid).html('<div class="character-icon"><i class="fas fa-id-badge"></i></div><p>'+char.charinfo.firstname+' '+char.charinfo.lastname+'<p>');
        $('#char-'+char.cid).data('cData', char)
        $('#char-'+char.cid).data('cid', char.cid)
    })
}

$(document).on('click', '.character-box', function(e) {
    var cDataPed = $(this).data('cData');
    e.preventDefault();
    if (selectedChar === null) {
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("selected");
            $('.character-list-buttons').css({"display":"block"});
            $('#create').css({"display":"block"});
            $('#play').css({"display":"none"});
            $('#delete').css({"display":"none"});
            $.post('http://mbl-multicharacterv2/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("selected");
            $('.character-list-buttons').css({"display":"block"});
            $('#create').css({"display":"none"});
            $('#play').css({"display":"block"});
            $('#delete').css({"display":"block"});
            $.post('http://mbl-multicharacterv2/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    } else if ($(selectedChar).attr('id') !== $(this).attr('id')) {
        $(selectedChar).removeClass("selected");
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("selected");
            $('.character-list-buttons').css({"display":"block"});
            $('#create').css({"display":"block"});
            $('#play').css({"display":"none"});
            $('#delete').css({"display":"none"});
            $.post('http://mbl-multicharacterv2/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("selected");
            $('.character-list-buttons').css({"display":"block"});
            $('#create').css({"display":"none"});
            $('#play').css({"display":"block"});
            $('#delete').css({"display":"block"});
            $.post('http://mbl-multicharacterv2/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    }
});


$(document).on('click', '#create-user', function(e){
    e.preventDefault();
    $.post('http://mbl-multicharacterv2/createNewCharacter', JSON.stringify({
        firstname: $('#first_name').val(),
        lastname: $('#last_name').val(),
        nationality: $('#nationality').val(),
        birthdate: $('#birthdate').val(),
        gender: $('select[name=gender]').val(),
        cid: $(selectedChar).attr('id').replace('char-', ''),
    }));
    refreshCharacters()
});

$(document).on('click', '#accept-delete', function(e){
    $.post('http://mbl-multicharacterv2/removeCharacter', JSON.stringify({
        citizenid: $(selectedChar).data("citizenid"),
    }));
    $('.character-delete').fadeOut(150);
    refreshCharacters()
});

function refreshCharacters() {
    $('.character-list-block').html('<div class="character-box" id="char-1" data-cid=""><div class="character-icon"><i class="fas fa-plus"></i></div><div class="character-box" id="char-2" data-cid=""><div class="character-icon"><i class="fas fa-plus"></i></div><div class="character-box" id="char-3" data-cid=""><div class="character-icon"><i class="fas fa-plus"></i></div><div class="character-box" id="char-4" data-cid=""><div class="character-icon"><i class="fas fa-plus"></i></div><div class="character-box" id="char-5" data-cid=""><div class="character-icon"><i class="fas fa-plus"></i></div><div class="character-list-buttons"><div class="char-button" id="create">Yeni karakter oluştur</div><div class="char-button" id="play">Seçilen karakterle oynayın</div><div class="char-button" id="delete">Seçili karakteri sil</div></div>')

    $(selectedChar).removeClass("selected");
    selectedChar = null;
    $.post('http://mbl-multicharacterv2/setupCharacters');
    $('.character-list-buttons').css({"display":"none"});
    $('#create').css({"display":"none"});
    $('#play').css({"display":"none"});
    $('#delete').css({"display":"none"});
}


$("#close-reg").click(function (e) {
    e.preventDefault();
    $(".character-list-container").fadeIn(1000);
    $('.character-creation').css({"display":"none"});
})

$("#close-del").click(function (e) {
    e.preventDefault();
    $('.character-delete').css({"display":"none"});
})

$(document).on('click', '#play', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $.post('http://mbl-multicharacterv2/selectCharacter', JSON.stringify({
                cData: $(selectedChar).data('cData')
            }));
            $(selectedChar).removeClass("selected");
        }
    }
});

$(document).on('click', '#delete', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $('.character-delete').fadeIn(250);
        }
    }
});

$(document).on('click', '#create', function(e) {
    console.log("yedi")
    $(".character-list-container").fadeOut(500);
    $(".character-list-buttons").fadeOut(500);
    setTimeout(function() {
        $('#hidden').fadeIn(750);
    }, 1000)

});



window.onload = function(e) {
    $(".character-list").hide();
}