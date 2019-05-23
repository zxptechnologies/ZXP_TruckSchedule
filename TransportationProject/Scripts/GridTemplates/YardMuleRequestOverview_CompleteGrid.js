function init_yardmuleRequestOverviewGrid_CompleteGridMobile() {

     // <% --will change edit mode when in width is equal to or less than 850px. (for mobile)--%>
    $("#completedGrid").igGrid({
        dataSource: GLOBAL_COMPLETE_DATA,
        width: "100%",
        virtualization: false,
        autoGenerateColumns: false,
        renderCheckboxes: true,
        primaryKey: "REQID",
        autofitLastColumn: true,
        columns:
            [
                {
                    headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "10%", template: "{{if(${REJECT})}}" +
                        "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                },
                { headerText: "Is open in CMS", key: "isOpenInCMS", hidden: true, width: "0%" },
                { headerText: "", key: "REQID", dataType: "number", width: "0%", hidden: true },
                {
                    headerText: "MSID", key: "MSID", dataType: "string", width: "0%", template: "{{if(${MSID} == -1)}}" +
                        "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                },
                { headerText: "PO", key: "PO", dataType: "string", width: "16%" },
                { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "16%" },
                { headerText: "New Spot", key: "NEWSPOT", dataType: "string", width: "12%" },
                { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "0%", hidden: true },
                { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "0%", hidden: true },
                { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0%" },
                { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "16%" },
                { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "29%" },
            ],
        features: [
            {
                name: 'Paging'
            },
            {
                name: 'Resizing'
            },
            {
                name: 'Updating',
                enableAddRow: false,
                editMode: "row",
                enableDeleteRow: false,
                showReadonlyEditors: false,
                enableDataDirtyException: false,
                autoCommit: false,
                editRowStarting: function (evt, ui) {
                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                    if (row.MSID != '(N/A)') {
                        // PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);
                    }
                    else {
                        $("#tableLog").empty();
                        $("#cboxLogTruckList").igCombo("value", null);
                    }
                    var isStartEndBtnClicked = $("#yardmulegrid").data("data-STARTENDClick");
                    if (isStartEndBtnClicked) {
                        $("#yardmulegrid").data("data-STARTENDClick", false); 

                                  return false;
                    }
                },
                editRowEnding: function (evt, ui) {
                    if (!ui.rowAdding) {
                        var origEvent = evt.originalEvent;
                        if (typeof origEvent === "undefined") {
                            ui.keepEditing = true;
                            return false;
                        }
                        if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                            //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);
                            var row = ui.owner.grid.findRecordByKey(ui.rowID);
                            PageMethods.updateRequest(row.REQID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                        }
                        else {
                            return false;
                        }

                    }
                },
                columnSettings:
                    [
                        { columnKey: "isOpenInCMS", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "PO", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "REQID", readOnly: true },
                        { columnKey: "TASK", readOnly: true },
                        { columnKey: "REQUESTER", readOnly: true },
                        { columnKey: "ASSIGNEE", readOnly: true },
                        { columnKey: "TIMEASSIGNED", readOnly: true },
                        { columnKey: "TSTART", readOnly: true },
                        { columnKey: "TEND", readOnly: true },
                        { columnKey: "COMMENTS", readOnly: true },
                        { columnKey: "NEWSPOT", readOnly: true },
                        { columnKey: "TRAILNUM", readOnly: true },
                        { columnKey: "NEWSPOT", readOnly: true },
                        { columnKey: "REJECT", readOnly: true },
                        { columnKey: "DUETIME", readOnly: true }
                    ]
            }
        ]

    }); //<% --end complete grid-- %>
      
}





function init_yardmuleRequestOverviewGrid_CompleteGridRegular() {
    $("#completedGrid").igGrid({
        dataSource: GLOBAL_COMPLETE_DATA,
        width: "100%",
        virtualization: false,
        autoGenerateColumns: false,
        renderCheckboxes: true,
        primaryKey: "REQID",
        columns:
            [
                {
                    headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                        "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                },
                { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0px" },
                { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true, readOnly: true },
                {
                    headerText: "MSID", key: "MSID", dataType: "string", width: "0px", template: "{{if(${MSID} == -1)}}" +
                        "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                },
                { headerText: "PO", key: "PO", dataType: "string", width: "75px" },
                { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "75px" },
                { headerText: "New Spot (If Applicable)", key: "NEWSPOT", dataType: "string", width: "75px" },
                { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "200px" },
                { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "125px" },
                { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "125px" },
                { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "100px" },
            ],
        features: [
            {
                name: 'Paging'
            },
            {
                name: 'Resizing'
            },
            {
                name: 'Updating',
                enableAddRow: false,
                editMode: "row",
                enableDeleteRow: false,
                showReadonlyEditors: false,
                enableDataDirtyException: false,
                autoCommit: false,
                editRowStarting: function (evt, ui) {
                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                    if (row.MSID != '(N/A)') {
                        //  PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);
                    }
                    else {
                        $("#tableLog").empty();
                        $("#cboxLogTruckList").igCombo("value", null);
                    }
                    var isStartEndBtnClicked = $("#yardmulegrid").data("data-STARTENDClick");
                    if (isStartEndBtnClicked) {
                        $("#yardmulegrid").data("data-STARTENDClick", false);
                                  return false;
                    }
                },
                editRowEnding: function (evt, ui) {
                    if (!ui.rowAdding) {
                        var origEvent = evt.originalEvent;
                        if (typeof origEvent === "undefined") {
                            ui.keepEditing = true;
                            return false;
                        }
                        if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                            var row = ui.owner.grid.findRecordByKey(ui.rowID);
                            PageMethods.updateRequest(row.REQID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                        }
                        else {
                            return false;
                        }
                    }
                },
                columnSettings:
                    [
                        { columnKey: "isOpenInCMS", readOnly: true },
                        { columnKey: "PO", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "REQID", readOnly: true },
                        { columnKey: "TASK", readOnly: true },
                        { columnKey: "REQUESTER", readOnly: true },
                        { columnKey: "ASSIGNEE", readOnly: true },
                        { columnKey: "TIMEASSIGNED", readOnly: true },
                        { columnKey: "TSTART", readOnly: true },
                        { columnKey: "TEND", readOnly: true },
                        { columnKey: "COMMENTS", readOnly: true },
                        { columnKey: "NEWSPOT", readOnly: true },
                        { columnKey: "TRAILNUM", readOnly: true },
                        { columnKey: "NEWSPOT", readOnly: true },
                        { columnKey: "REJECT", readOnly: true },
                        { columnKey: "DUETIME", readOnly: true },
                    ]
            }
        ]

    });// <% --end complete grid-- %>
}
