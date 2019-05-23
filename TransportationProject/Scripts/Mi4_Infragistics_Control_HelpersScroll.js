function rebindComboBoxOnGrid(gridname, newOpts, columnKey) {
    var cbox = $(gridname).igGridUpdating("editorForKey", columnKey);
    if (cbox) {
        cbox.igCombo("option", "dataSource", newOpts);
        cbox.igCombo("dataBind");
    }

}

//-------------------------------------------------------------------
//showProgress()
//Show div containing progress circle
//-------------------------------------------------------------------

function showProgress() {
    document.getElementById("progressBackgroundFilter").style.display = "block";
    document.getElementById("processMessage").style.display = "block";
}

//-------------------------------------------------------------------
//hideProgress()
//Hide div containing progress circle
//-------------------------------------------------------------------
function hideProgress(){ 
    document.getElementById("progressBackgroundFilter").style.display = "none";
    document.getElementById("processMessage").style.display = "none";
}

function sendtoErrorPage(message) {
    top.window.location.href = "ErrorPage.aspx?ErrorClientMsg=" + message;
}

function getNewTime(oldTime) {
    var newTime;

    var hours = oldTime.getHours();
    if (hours < 10) { hours = "0" + hours; }

    var minutes = oldTime.getMinutes();
    if (minutes < 10) { minutes = "0" + minutes; }

    var seconds = oldTime.getSeconds();
    if (seconds < 10) { seconds = "0" + seconds; }

    newTime = hours + ":" + minutes + ":" + seconds;
    return newTime;
}

function formatterPercentageUpdate(val) {
    return val * 100;
}

function formatterPercentageRender(val) {
    return val / 100;
}

function scrollUp() {
    var url = window.location.href;
    var myPageName = url.substring(url.lastIndexOf('/') + 1).substring(0, 5);

    if (myPageName == 'Admin') {
        //window.parent.parent.scrollTo(0, 0);
        //$("#MainContent_iframeContent").contents().scrollTop();
        //$('html, body').animate({
        //    scrollTop: $("#iframeContent").offset().top
        //}, 600);

       // $("#iframeContent").scrollTo(0, 0);

        //$()._scrollable().scrollTop();
        $("#ContentPlaceHolder1").animate({
            scrollTop: 0
        }, 600);
        //$('#iframeContent').scrollTop()
        return false;
    }
    else {
        $("html, body").animate({
            scrollTop: 0
        }, 600);
        return false;
    }
}
function checkNullOrUndefined(val) {
    var strVal = String(val);

    // if (typeof (val) === 'undefined' || typeof (val) === 'object' || val === null) {
    if (typeof (val) === 'undefined' || val === null) {
        return true;
    }
    else if (strVal.trim().replace(/&nbsp;/g, '') === "") {
        return true;
    }
    else {
        return false;
    }

}
/************************************
Function returnItemFromArray
Returns: an item from the inputted itemcolumn, given a columnKey and columnVal to search on 
Parameters: 
    Array[] array
    String columnKey
    (DataType declared for columnKey) columnVal 
    String itemcolumn
************************************/
function returnItemFromArray(array, columnKey, columnVal, itemcolumn)
{
    for (var i = 0; i < array.length; i++) {
        if (array[i][columnKey] === columnVal) {
            return array[i][itemcolumn];
        }
    }
}

//checks to see if product is apart of data set for combo box (used in Admin_Patterns & Admin_CustomerVendorProducts)
function searchArrayForProductExistence(array, product) {
    for (var i = 0; i < array.length; i++) {
        if (array[i].PRODUCT.trim() === product.trim()) {// trim recently added - 2/16/16
            return true;
        }
    }
    return false;
}

//for log window -  placement and make draggable 
function placeLogWindowAndMakeDraggable() {
    $(".logWindow").draggable(); //xxx
    var p = $("#body").position();
    $(".logWindow").css("top", (p.top + 20) + 'px');
    //var UA = navigator.userAgent.indexOf("MSIE ");
    //if (UA >= 0) {
    //    $(".logWindow").css('right', '8px');
    //}
}

function isOnMobile() {
    var isMobile = false;
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){ isMobile = true };
    var width = $(window).width();
    if (isMobile === false && width <= 850) {
        isMobile = true;
    }

    if (isMobile == true) {
        $('.logWindow').hide();
        $('#dvRejected').parent().attr('style', '');
        $('#lblRejectTime').before('<br>');
    }
    else {
        placeLogWindowAndMakeDraggable();
        var tLogDisplayPref = sessionStorage.getItem('tLogDisplayPref');
        if (tLogDisplayPref == 'hide') {;
            $("#tLogMax").show();
            $("#tLogMini").hide();
            $("#logTableWrapper").slideToggle();
        }
    }
    return isMobile;
}

function getWidthForTextAreaForMobilePopUp() {
    var windowWidth = $(window).width();
    var textAreaWidth = (windowWidth - (windowWidth / 3)) + "px";
    return textAreaWidth;
}

function addZero(n) {
    return n < 10 ? '0' + n : '' + n;
}

//Formats d to MM/dd/yyyy HH:mm:ss format
function formatDate(d) {
    return addZero(d.getMonth() + 1) + "/" + addZero(d.getDate()) + "/" + d.getFullYear() + " " +
           addZero(d.getHours()) + ":" + addZero(d.getMinutes()) + ":" + addZero(d.getMinutes());
}


//checks to see if product is apart of data set for combo box (used in Admin_Patterns & Admin_CustomerVendorProducts)
function searchArrayForValueBasedOnID(array, searchValue) {
    for (var i = 0; i < array.length; i++) {
        if (array[i].ID === searchValue) {
            return array[i].LABEL;
        }
    }
    return false;
}


function formatBoolAsYesOrNO(value) {
    var newValue;
    if (value == true) {
        newValue = 'Yes';
    }
    else {
        newValue = 'No';
    }
    return newValue;
}

function formatValueToValueOrNA(value) {
    var newValue;
    if (checkNullOrUndefined(value) == true) {
        newValue = "(N/A)";
    }
    else {
        newValue = value;
    }
    return newValue;
}

function formatNegativeOneMSIDToNA(value) {
    var newValue;
    if (value == -1) {
        newValue = "(N/A)";
    }
    else {
        newValue = value;
    }
    return newValue;
}

function formatValueToValueOrNone(value) {
    var newValue;
    if (checkNullOrUndefined(value) == true) {
        newValue = "None";
    }
    else {
        newValue = value;
    }
    return newValue;
}

function formatValueToValueOrNoneWithParenthesis(value) {
    var newValue;
    if (checkNullOrUndefined(value) == true) {
        newValue = "(NONE)";
    }
    else {
        newValue = value;
    }
    return newValue;
}

function formatValueToValueOrNone(value) {
    var newValue;
    if (checkNullOrUndefined(value) == true) {
        newValue = "None";
    }
    else {
        newValue = value;
    }
    return newValue;
}

function truckLog_MiniMaxAndRemember(logDisplay) {
    if (logDisplay == "block") {
        $("#tLogMax").show();
        $("#tLogMini").hide();
        sessionStorage.setItem('tLogDisplayPref', 'hide');
    }
    else {
        $("#tLogMax").hide();
        $("#tLogMini").show();
        sessionStorage.setItem('tLogDisplayPref', 'show');
    }
    $("#logTableWrapper").slideToggle();
}



function truckLog_OnSuccess_Render(returnData, MSID) {
    if (returnData.length > 0) {
        //clears Div incase this is not the first table render
        $("#tableLog").empty(); //formally logTableWrapper
        //gets div
        var logDiv = document.getElementById("tableLog");
        //creates table and table body and sets attributes for table
        var tbl = document.createElement('table');
        tbl.style.width = '100%';
        tbl.setAttribute('border', '1');
        var tblBody = document.createElement("tbody");


        for (var i = 0; i < returnData.length; i++) {
            //creates row and both cells (one for event time and another for event details
            var row = document.createElement('tr');
            var cellTS = document.createElement("td");
            var cellET = document.createElement("td");
            var cellFN = document.createElement("td");

            //format time of event
            var newDateTime = formatDate(returnData[i][0]);

            //sets cell text
            var cellTSText = document.createTextNode(newDateTime);
            var cellETText = document.createTextNode(returnData[i][1]);
            var cellFNText = document.createTextNode(returnData[i][2]);

            //sets cell text to each cell & append cell to row
            cellTS.appendChild(cellTSText);
            row.appendChild(cellTS);

            cellET.appendChild(cellETText);
            row.appendChild(cellET);

            cellFN.appendChild(cellFNText);
            row.appendChild(cellFN);
            //appends row to table body
            tblBody.appendChild(row);
        }
        //appends table body to table
        tbl.appendChild(tblBody);

        //appends table to log div
        logDiv.appendChild(tbl);
        $("#cboxLogTruckList").igCombo("value", MSID);

    }
}
function comboPOAndTrailer(PO, Trailer) {
    var POTrailerCombo;
    if (!checkNullOrUndefined(Trailer)) {
        POTrailerCombo = PO + " - " + Trailer;
    }
    else {
        POTrailerCombo = PO + " ";
    }
    return POTrailerCombo;
}

function getNowDateTime() {
    var today = new Date();
    var now = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
    return now;
}

$("a[href='#top']").click(function () {
    $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
});

function fadeInOutToTopButton() {
    $(window).scroll(function () {
        if ($(this).scrollTop() > 10) {
            $('.scrollup').fadeIn();
        } else {
            $('.scrollup').fadeOut();
        }
    });
}