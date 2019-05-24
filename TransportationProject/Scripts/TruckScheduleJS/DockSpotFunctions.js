
function getGridDates() {

    var startTimes = [];
    var endTimes = [];
    var timelabels = [];

    for (hr = 0; hr <= 23; hr++) {
        var min = 0;
        while (min < 60) {

            var startText = (hr < 10 ? '0' : '') + hr + ":" + (min < 10 ? '0' : '') + min;
            var endText = (hr < 10 ? '0' : '') + hr + ":" + (min + 29);
            startTimes.push(startText);
            endTimes.push(endText);
            timelabels.push(startText + "-" + endText);

            min = min + 30;
        }
    }
    var openDockTimes = { "StartTimes": startTimes, "EndTimes": endTimes, "TimeLabels": timelabels };
    return openDockTimes;
}

function getDockTimesHTMLRows(someArray) {
    var htmlText = "";
    someArray.forEach(function (element) {
        var htmlColumns = "";
        for (dayCount = 0; dayCount < 7; dayCount++) {
            htmlColumns = htmlColumns + "<td>" + element + "</td>";

        }
        htmlText = htmlText + "<tr>" + htmlColumns + "</tr>";
    });
    return htmlText;
}

$('button').on('click', function () {
    var dockTimes = getGridDates();
    var tableHtml = getDockTimesHTMLRows(dockTimes["TimeLabels"]);
    document.getElementById("dockTimes").innerHTML = tableHtml;


    $("td").on("click", function () {
        var date = new Date();
        var timestamp = date.getTime();
        //$(this).css('backgroundColor', 'green');
        $(this).toggleClass("timeslot-disabled");
        console.log("clicked" + timestamp);
    });
});






function onClickPopulateTable() {
    var dockTimes = getGridDates();
    var tableHtml = getDockTimesHTMLRows(dockTimes["StartTimes"]);
    document.getElementById("dockTimes").innerHTML = tableHtml;
}