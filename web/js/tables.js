//filtro de tablas
$(document).bind("contextmenu", function (e) {
    e.preventDefault();
});
//filtro de las tablas
$(document).ready(function () {

    (function ($) {

        $('#f1').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable tr').hide();
            $('.searchable tr').filter(function () {
                return rex.test($(this).text());
            }).show();
        });
    }(jQuery));

});

$(document).ready(function () {
    (function ($) {

        $('#f2').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable1 tr').hide();
            $('.searchable1 tr').filter(function () {
                return rex.test($(this).text());
            }).show();

        });
    }(jQuery));
});

$(document).ready(function () {
    (function ($) {

        $('#f3').keyup(function () {

            var rex = new RegExp($(this).val(), 'i');
            $('.searchable2 tr').hide();
            $('.searchable2 tr').filter(function () {
                return rex.test($(this).text());
            }).show();
        });
    }(jQuery));
});




