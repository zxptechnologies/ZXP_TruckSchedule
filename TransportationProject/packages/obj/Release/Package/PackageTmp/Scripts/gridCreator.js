

/*----------------------------------------------------------------------
Function: createScheduleGrid
Return: html table
Description: create an html table of the schedule for the date selected 
        given the size of the table, header data, grid data
Parameters: 
        int rowCount 
        int colCount
        array [object] columnHeaderData 
        array [object] gridData
        bool overwritable - choose if scheduled cell can be overwritten
------------------------------------------------------------------------*/


function createScheduleGrid(colCount, columnHeaderData, gridData, overwritable) {
    

    //Create hourColumnData
    var rowCount = 48; //Adjust depending on increment used in createHourColumnValues; 48 rows [0-47] needed for 30min intervals
    var hourColData = createHourColumnValues();
    //Create a HTML Table element.
    var table = $("<table />");
    table.attr('id', 'tblSchedGrid');
    table[0].border = "1";
 
    //Add the header row.
    var row = $(table[0].insertRow(-1));
    for (var i = 0; i < colCount; i++) {
        var headerCell = $("<th />");
        headerCell.html(columnHeaderData[i][1]);
        //headerCell.html("COL" + i.toString());
        row.append(headerCell);
    }
 
    //Add the data rows.
    for (var rc = 0; rc < rowCount; rc++) {
        row = $(table[0].insertRow(-1));
        for (var cc= 0; cc < colCount; cc++) {
            var cell = $("<td />");
            if (0 === cc) {
                cell.html(hourColData[rc].TIMECOL);
            }
            else {
                //cell.html("CELL =" + rc.toString() + ", " + cc.toString());
                cell.attr("data-hour", hourColData[rc].TIMECOL);
                cell.attr("data-spotid", columnHeaderData[cc][0]);
                cell = prepareCell(cell, gridData, overwritable)
            }
            row.append(cell);
        }
    }
 
    return table
}

/*----------------------------------------------------------------------
Function: createScheduleGridHeader
Return: html table
Description: create the header section of the schedule for the date selected 
        given the size of the table, header data, grid data
Parameters: 
        int rowCount 
        int colCount
        array [object] columnHeaderData 
        array [object] gridData
------------------------------------------------------------------------*/
function createScheduleGridHeader(colCount, columnHeaderData, gridData) {


    //Create hourColumnData
    var rowCount = 48; //Adjust depending on increment used in createHourColumnValues; 48 rows [0-47] needed for 30min intervals
    var hourColData = createHourColumnValues();
    //Create a HTML Table element.
    var table = $("<table />");
    table.attr('id', 'tblSchedGridHeader');
    table[0].border = "1";

    //Add the header row.
    var row = $(table[0].insertRow(-1));
    for (var i = 0; i < colCount; i++) {
        var headerCell = $("<th />");
        headerCell.html(columnHeaderData[i][1]);
        //headerCell.html("COL" + i.toString());
        row.append(headerCell);
    }

    row = $(table[0].insertRow(-1));
    //Add blank row
    for (var cc = 0; cc < colCount; cc++) {
        var cell = $("<td />");
        row.append(cell);
    }
    
    return table
}


/*----------------------------------------------------------------------
Function: createHourColumnValues
Return: 
Description: 
Parameters: 
------------------------------------------------------------------------*/
function createHourColumnValues() {
    var timeVal = [];
    var id = 0;
    for(var i = 0; i < 24; i++){ //hour count
        for (var j = 0; j < 60; j = j+30) { //min count; change increment as needed for time blocks
            var newtime = ("00" + i).slice(-2) + ":" + ("00" + j).slice(-2);
            timeVal.push({"ID": id, "TIMECOL": newtime});
            id++; 
        }
    } 

    return timeVal;
}

/*----------------------------------------------------------------------
Function: 
Return: 
Description: 
Parameters: 
------------------------------------------------------------------------*/
function prepareCell(cell, gridData , overwritable) {
   var hr =  cell.attr("data-hour");
   var spot = cell.attr("data-spotid");
   if (hr && spot) {
       var isOpen = checkcellisOpenAndSetBlock(hr, parseInt(spot), gridData, cell);
       var isAppt = checkcellisAppointmentAndSetData(hr, parseInt(spot), gridData, cell);
       cell = setCellColor(cell, parseInt(spot), isOpen, isAppt, overwritable);
       

   }
   return cell;
}

/*----------------------------------------------------------------------
Function: setCellColor
Return: 
Description: 
Parameters: 
------------------------------------------------------------------------*/
function setCellColor(cell, spot, isOpen, isAppt, overwritable) {
    if (spot === -999) {//make cell available where spotID = -999 or as set in query
        cell.addClass("cell_Available");
        cell.addClass("cell_Other");
    }
    else if (isAppt && !overwritable) { //spot has truck appointment assigned or is not Open

        cell.addClass("cell_notAvailable");
        //cell.attr("data-Available", 0);
    }
    else if (isAppt && overwritable) { //spot has truck appointment assigned or is not Open

        cell.addClass("cell_Available cell_ScheduledButOverWritable");
        //cell.attr("data-Available", 0);
    }
    else if (!isOpen) { //spot is off hours and should be unavailable
        cell.addClass("cell_notAvailable cell_offHours");
        //cell.attr("data-Available", 0);
        }
    else if (isOpen){ //isOpen == true
        cell.addClass("cell_Available");
        //cell.attr("data-Available", 1);
    }
    return cell
}


/*----------------------------------------------------------------------
Function: checkcellisAppointmentAndSetData
Return: 
Description: 
Parameters: 
------------------------------------------------------------------------*/
function checkcellisAppointmentAndSetData(spotTime, spot, gridData, cell) {
    
    var result = false;
    var splitHr = spotTime.split(":");
    var hr = splitHr[0];
    var min = splitHr[1];

    var cellDateTime = new Date(1900, 0, 1, hr, min, 0);

    for (i = 0; i < gridData.length; i++) {
        var fromDateTime = new Date(1900, 0, 1, gridData[i].FROMTIME.getHours(), gridData[i].FROMTIME.getMinutes(), 0);
        var toDateTime;
        if (gridData[i].TOTIME) {
            toDateTime = new Date(1900, 0, 1, gridData[i].TOTIME.getHours(), gridData[i].TOTIME.getMinutes(), 0);
        }
        else {
            toDateTime = fromDateTime;
        }

        var resultTemp = false;
        if (cellDateTime >= fromDateTime && cellDateTime <= toDateTime && spot === gridData[i].SPOTID) {
            
            resultTemp = gridData[i].ISAPPT;
            //TODO: revisit, ponumber not populating is this still necessary?
            if (1 == resultTemp) {  //this makes sure that the cell doesn't get overwritten by other enclosing ranges
                var ponumber = cell.data("ponumber")
                cell.attr("data-ponumber", ponumber + gridData[i].PONUM + ", ");
                var cellText = cell.html();
                cell.html(cellText + gridData[i].PONUM + ", </br>" );
                result = resultTemp; 
            }
        }
    }
    return result;
}

/*----------------------------------------------------------------------
Function: checkcellisOpenAndSetBlock
Return: 
Description: 
Parameters: 
------------------------------------------------------------------------*/
function checkcellisOpenAndSetBlock(spotTime, spot, gridData, cell) {

    var result = false;
    var splitHr = spotTime.split(":");
    var hr = splitHr[0];
    var min = splitHr[1];

    var cellDateTime = new Date(1900, 0, 1, hr, min, 0);
    
    for (i = 0; i < gridData.length; i++) {
        var fromDateTime = new Date(1900, 0, 1, gridData[i].FROMTIME.getHours(), gridData[i].FROMTIME.getMinutes(), 0);
        var toDateTime;
        if (gridData[i].TOTIME) {
            toDateTime = new Date(1900, 0, 1, gridData[i].TOTIME.getHours(), gridData[i].TOTIME.getMinutes(), 0);
        }
        else {
            toDateTime = fromDateTime;
        }
        var resultTemp = false;
        if (cellDateTime >= fromDateTime && cellDateTime <= toDateTime && spot === gridData[i].SPOTID) {
            resultTemp = gridData[i].ISOPEN;
            if (1 == resultTemp) { //this makes sure that the cell doesn't get overwritten by other enclosing ranges
             
                cell.attr("data-timeblock", gridData[i].HRSBLOCK);
                result = resultTemp; 
            }
        }
    }
    return result;
}