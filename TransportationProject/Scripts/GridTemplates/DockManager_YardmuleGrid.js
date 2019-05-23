function init_yardmuleGrid() {


$("#yardmulegrid").igGrid({
    dataSource: GLOBAL_YARDMULE_DATA,
    width: "100%",
    virtualization: false,
    autoGenerateColumns: false,
    renderCheckboxes: true,
    primaryKey: "REQID",
    columns:
        [
            { headerText: "PO", key: "PO", dataType: "number", width: "0px", hidden: true },
            { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true },
            { headerText: "", key: "DUE", dataType: "date", width: "0px", hidden: true },
            { headerText: "", key: "TRUCKTYPE", dataType: "number", width: "0px", hidden: true },
            {
                headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                    "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
            },
            {
                headerText: "Is open in CMS", key: "isOpenInCMS", width: "50px", template: "{{if(${MSIDTEXT} == '(N/A)')}}" +
                    "<div>(N/A)</div>{{else}}<div>${isOpenInCMS}</div>{{/if}}"
            },
            { headerText: "MSID", key: "MSIDTEXT", dataType: "string", width: "0px", hidden: true },
            { headerText: "PO - Trailer", key: "POANDTRAILERNUM", dataType: "string", width: "175px", template: "<div>${POANDTRAILERNUM}</div>" },
            {
                headerText: "", key: "MSID", unbound: true, dataType: "string", width: "0px", hidden: true, formula: function (row, grid) { return returnItemFromArray(GLOBAL_YARDMULE_PO_OPTIONS, "ID", parseInt(row.MSIDTEXT), "LABEL"); }
                //headerText: "PO", key: "MSID", unbound: true, dataType: "string", width: "100px", template: "{{if(${MSIDTEXT} == '(N/A)')}}" +
                //"<div>(N/A)</div>{{else}}<div>${PO}</div>{{/if}}"
            },
            { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "0px", hidden: true },
            {
                headerText: "Product", key: "PRODID", dataType: "string", width: "150px",
                template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                    "{{elseif (${PRODDETAIL} < 2)}}<div>${PRODID}</div>" +
                    "{{else}}Multiple{{/if}}"
            },
            { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
            {
                headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                    "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                    "{{else}}<div><input type='button' value='Multiple' onclick='GLOBAL_ISDIALOG_OPEN = true; openProductDetailDialogYM(${MSIDTEXT}, ${REQID}); return false;'></div>{{/if}}"
            },
            { headerText: "Request Type", key: "REQTYPEID", dataType: "number", width: "100px", formatter: formatRequestCombo },
            { headerText: "", key: "SPOTID", dataType: "number", width: "0px" },
            {
                headerText: "Originally Assigned Spot", key: "SPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.SPOTID, "LABEL"); }
            },
            { headerText: "", key: "CURRENTSPOTID", dataType: "number", width: "0px", hidden: true },
            {
                headerText: "Current Spot", key: "CURRENTSPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.CURRENTSPOTID, "LABEL"); }
            },
            { headerText: "", key: "NEWSPOTID", dataType: "number", width: "0px" },
            {
                headerText: "Move To Spot", key: "NEWSPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.NEWSPOTID, "LABEL"); }
            },
            { headerText: "Due Date", key: "DUEDATE", dataType: "date", format: "MM/dd/yyyy", width: "0px", hidden: true },
            { headerText: "Due Time (24HR)", key: "DUETIME", dataType: "string", width: "0px", hidden: true },
            { 
                           // <% --disabled as of 2018 / 10 / 19 for new layout-- %>
        headerText: "Task Comments", key: "TASK", dataType: "string", width: "0px", hidden: true
},
    { headerText: "", key: "YMID", dataType: "number", width: "0px" },
    {
                           // <% --disabled as of 2018 / 10 / 19 for new layout-- %>
    headerText: "Assigned to", key: "YM", unbound: true, dataType: "string", width: "0", hidden: true,
        formula: function (row, grid) {
            return returnItemFromArray(GLOBAL_YARDMULE_OPTIONS, "VALUE", row.YMID, "TEXT");
        } 
                        },

{ headerText: "", key: "SPOTETA", dataType: "date", width: "0px", hidden: true },
{ headerText: "Spot Date", key: "SPOTETADATE", dataType: "date", format: "MM/dd/yyyy", width: "100px" },
{ headerText: "Spot Time", key: "SPOTETATIME", dataType: "string", width: "100px" },


{ headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
{ headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
{ headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
{ headerText: "Yard Mule Comments", key: "COMMENTS", dataType: "string", width: "100px" }
                    ],
features: [


    {

        name: "Filtering",
        columnSettings: [
            { columnKey: "TIMEASSIGNED", condition: "after" },
            { columnKey: "TSTART", condition: "after" },
            { columnKey: "TEND", condition: "after" },
        ]
    },
    {
        name: 'Paging'
    },
    {
        name: 'Resizing'
    },
    {
        name: 'Updating',
        enableAddRow: true,
        editMode: "row",
        enableDeleteRow: true,
        showReadonlyEditors: false,
        enableDataDirtyException: false,
        autoCommit: false,
        editCellStarting: function (evt, ui) {
            var requestStatus = $("#yardmulegrid").data("data-RequestStatus");
            if (ui.rowAdding) {//<% --new row--%>
                             if (ui.columnKey == "SPOT") { //<% --disable--%>
                                 return false;
                }
            }
            else { //<% --row edit-- %>
                             if (ui.columnKey == "MSID" || ui.columnKey == "SPOT" || ui.columnKey == "TRAILNUM" || "POANDTRAILERNUM" == ui.columnKey) {
                    return false;
                }

                if ("ETADATE" == ui.columnKey) {
                    var ETAeditor = $("#yardmulegrid").igGridUpdating("editorForKey", "ETADATE");
                    var newDate = new Date(ui.value);
                    var ETADate = ETAeditor.igDatePicker("option", "value", newDate);
                }

                if ("SPOTETADATE" == ui.columnKey) {
                    var ETAeditor2 = $("#yardmulegrid").igGridUpdating("editorForKey", "SPOTETADATE");
                    var newDate2 = new Date(ui.value);
                    var ETADate2 = ETAeditor2.igDatePicker("option", "value", newDate);
                }


                
            }
        },

        rowAdding: function (evt, ui) {
            var origEvent = evt.originalEvent;
            if (typeof origEvent == "undefined") {
                ui.keepEditing = true;
                return false;
            }
            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                var spot = ui.values.NEWSPOT;
                var isInvalid = false; // $("#yardmulegrid").data("data-invalidSpot");
                var isExisting = $("#yardmulegrid").data("data-existingSpot");
                var shouldExitAdd = false;
                var reply2 = false;
                if (isInvalid) {
                    reply2 = confirm("The spot chosen is currently reserved or is occupied. Continue creating request?.");
                }

                if (!isInvalid || reply2) {
                    var continueAdding = false;
                    if (isExisting) {
                        continueAdding = confirm("This PO has a move request that is currently not complete. Press Cancel to modify the existing request or OK to continue adding a new request.");
                    }
                    if (!isExisting || continueAdding) {
                        var trailer = null;
                        if (!checkNullOrUndefined(ui.values.TRAILNUM)) {
                            trailer = ui.values.TRAILNUM;
                        }

                        var splitHr;
                        if (!checkNullOrUndefined(ui.values.SPOTETATIME) == true) {
                            splitHr = ui.values.SPOTETATIME.split(":");
                            var hr = splitHr[0];
                            var min = splitHr[1];
                            var ETA = new Date(ui.values.SPOTETADATE);
                            ETA.setHours(hr - ETA.getTimezoneOffset() / 60); //<% --this will appear wrong at this point.getTimezoneOffset is an adjustment for UTC that started happening on 3 / 15 -- %>
                                ETA.setMinutes(min);
                            var now = new Date();
                            now.setHours(now.getHours() - now.getTimezoneOffset() / 60);
                            var reply = true;
                            if (ETA < now) {
                                reply = confirm("The date-time you have selected already passed. Continue?");
                            }

                            if (!reply) {
                                ui.keepEditing = true;
                                return false;
                            }
                        }


                        var assignedYM = null;
                        if (!checkNullOrUndefined(ui.values.YM) == true) {
                            assignedYM = ui.values.YM;
                        }

                        if (ui.values.POANDTRAILERNUM > 0) {
                            //if (ui.values.POANDTRAILERNUM != GLOBAL_MSIDForRequestWithOutMSID) {
                            //var MSID = returnItemFromArray(GLOBAL_YARDMULE_PO_OPTIONS, "LABEL", ui.values.POANDTRAILERNUM, "ID")
                            if (ui.values.REQTYPEID == globalRequestType.REQUESTTYPE_MOVE) {
                                PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, trailer, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVE, ETA, onSuccess_CreateRequestYardMule, onFail_CreateRequest);
                                return false;
                            }
                            else if (ui.values.REQTYPEID == globalRequestType.REQUESTTYPE_MOVEDROPTRAILER) {
                                PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, trailer, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVEDROPTRAILER, ETA, onSuccess_CreateRequestYardMule, onFail_CreateRequest);
                                return false;
                            }
                            else {
                                PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, trailer, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_OTHER, ETA, onSuccess_CreateRequestYardMule, onFail_CreateRequest);
                                return false;
                            }

                        }
                        else {
                            if (ui.values.REQTYPEID == globalRequestType.REQUESTTYPE_MOVEDROPTRAILER) {
                                PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, trailer,  assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVEDROPTRAILER,  ETA,onSuccess_CreateRequestYardMule, onFail_CreateRequest);
                                return false;
                            }
                            else {
                                PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, trailer,  assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_OTHER, ETA, onSuccess_CreateRequestYardMule, onFail_CreateRequest);
                                return false;
                            }

                        }
                    }
                    else {
                        shouldExitAdd = true;
                    }
                }
                else {
                    shouldExitAdd = true;
                }
            }
            else {
                ui.keepEditing = true;
                return false;
            }

            $("#yardmulegrid").data("data-existingSpot", false);// <% --reset--%>
                $("#yardmulegrid").data("data-invalidSpot", false); //<% --reset--%>
                    $("#yardmulegrid").data("data-MSID", -1);
            $("#yardmulegrid").data("data-REQID", 0);
            $("#yardmulegrid").data("data-RequestStatus", "");

            if (shouldExitAdd) {
                return false;
            }
        },
        rowDeleting: function (evt, ui) {
            PageMethods.checkStatusOfYMRequest(ui.rowID, onSuccess_checkStatusOfYMRequest, onFail_checkStatusOfYMRequest, 'delete');
            return false;

        },
        editRowStarting: function (evt, ui) {
            if (!ui.rowAdding) {
                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                if (row.MSIDTEXT > 0) {
                    //  PageMethods.GetLogDataByMSID(row.MSIDTEXT, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSIDTEXT);

                    var msid = row.MSIDTEXT;
                    //PageMethods.CheckIfSpotIsAvailable(spot, msid, onSuccess_CheckIfSpotIsAvailableWAlert, onFail_CheckIfSpotIsAvailable, spot);


                    if ((row.SPOTID != null || -999 != row.SPOTID) && (row.REQTYPEID == globalRequestType.REQUESTTYPE_OTHER) && !checkNullOrUndefined(row.REQTYPEID)) {
                        var req = row.REQID;
                        if (req > 0) {
                            PageMethods.checkIfSpotChangeRequestExist_OnRowEdit(msid, req, onSuccess_checkIfSpotChangeRequestExist_OnEdit,
                                onFail_checkIfSpotChangeRequestExist);
                        }
                        else {
                            PageMethods.checkIfSpotChangeRequestExist(msid, onSuccess_checkIfSpotChangeRequestExist,
                                onFail_checkIfSpotChangeRequestExist);
                        }
                    }
                }
                else {
                    $("#tableLog").empty();
                    $("#cboxLogTruckList").igCombo("value", null);

                }
                if (checkNullOrUndefined(row.MSIDTEXT) == true || row.MSIDTEXT == GLOBAL_MSIDForRequestWithOutMSID) {
                    PageMethods.GetSpotsByType(0, onSuccess_GetSpotsByType, onFail_GetSpotsByType, row.NEWSPOTID);
                    $("#yardmulegrid").data("data-MSID", 0);
                }
                else {
                    PageMethods.GetSpotsByType(row.MSIDTEXT, onSuccess_GetSpotsByType, onFail_GetSpotsByType, row.NEWSPOTID);
                    $("#yardmulegrid").data("data-MSID", row.MSIDTEXT);
                }

                $("#cboxYM").igCombo("text", row.YMID);
                $("#yardmulegrid").data("data-YMID", row.YMID);

            }
            else {
                $("#yardmulegrid").data("data-MSID", -1);
                PageMethods.GetSpotsByType(-1, onSuccess_GetSpotsByType, onFail_GetSpotsByType);// <% --get spots as if PO is N / A-- %>
                    //$("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(3)").text(""); <%-- trailer number --%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text(""); //<% --spot number-- %>
                         }


        },
        editRowStarted: function (evt, ui) {

            if (!ui.rowAdding) {
                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                $("#cboxYM").igCombo("value", row.YMID);
            }
        },
        editRowEnding: function (evt, ui) {
            var isInvalid = false;// $("#yardmulegrid").data("data-invalidSpot");
            var origEvent = evt.originalEvent;
            if (!ui.rowAdding) { //<% -- //handle rowAdds in the rowAdding event and not here --%>
                             var requestStatus = $("#yardmulegrid").data("data-RequestStatus");
                if (typeof origEvent == "undefined") {
                    ui.keepEditing = true;
                    return false;
                }
                if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                    var spot = ui.values.NEWSPOT;
                    if (requestStatus.toString() == 'created' || requestStatus.toString() == 'started') {
                        if (isInvalid) {
                            alert("The spot chosen is currently reserved or is occupied. Please modify.");
                            ui.keepEditing = true;
                            return false;
                        }
                        else {

                            var isExisting = $("#yardmulegrid").data("data-existingSpot");
                            var continueEditing = false;
                            if (isExisting) {
                                continueEditing = confirm("Another request of this type exists. Press Cancel to modify the existing request or OK to continue editing.");
                            }
                            if (isExisting == false || continueEditing) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                var sReply = true;
                                if (requestStatus.toString() == 'started') {
                                    sReply = confirm("The request has been started. Continue?");
                                    if (!sReply) {
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                }
                                var assignedYM = null;
                                if (!checkNullOrUndefined(ui.values.YM) == true) {
                                    assignedYM = ui.values.YM;
                                }

                                if (ui.values.SPOTETATIME) {

                                    var splitHr = ui.values.SPOTETATIME.split(":");
                                    var hr = splitHr[0];
                                    var min = splitHr[1];
                                    var ETA = new Date(ui.values.SPOTETADATE);
                                    ETA.setHours(hr - ETA.getTimezoneOffset() / 60); 
                                    ETA.setMinutes(min);

                                    var now = new Date();
                                    now.setHours(now.getHours() - now.getTimezoneOffset() / 60);
                                    var reply = true;
                                    if (ETA < now) {
                                        reply = confirm("The date-time you have selected already passed. Continue?");
                                    }

                                    if (!reply) {
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                }
                                else {
                                    alert("Please select a valid time");
                                    ui.keepEditing = true;
                                    return false;
                                }

                                PageMethods.updateRequest(row.REQID, assignedYM, ui.values.NEWSPOT, ui.values.REQTYPEID, ETA, onSuccess_updateRequestYardMule, onFail_updateRequest);//, DUEDATE.toUTCString()
                                return false;
                            }
                            else {
                                return false;
                            }
                        }
                    }
                    else if (requestStatus.toString() == 'completed') {
                        alert("The request has been completed and can no longer be edited. Please refresh the page to get the update on requests");
                        return false;
                    }
                }
                else {
                    return false;
                }
                $("#yardmulegrid").data("data-existingSpot", false); 
                    $("#yardmulegrid").data("data-invalidSpot", false); 

                         }
            else {

                $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text(""); //spot number

                         }
        },
        columnSettings:
            [
                { columnKey: "isOpenInCMS", readOnly: true },
                { columnKey: "REJECT", readOnly: true },
                { columnKey: "MSIDTEXT", readOnly: true },
                {
                    columnKey: "POANDTRAILERNUM",
                    editorType: "combo",
                    required: true,
                    editorOptions: {
                        mode: "editable",
                        enableClearButton: false,
                        dataSource: GLOBAL_YARDMULE_PO_OPTIONS,
                        id: "cboxYMMSID",
                        textKey: "LABEL",
                        valueKey: "ID",
                        autoSelectFirstMatch: true,
                        selectionChanging: function (evt, ui) {
                        },
                        selectionChanged: function (evt, ui) {
                            if (ui.items.length > 0) {
                                var MSID = ui.items[0].data.ID
                                $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text(""); //<% --spot number //does not work if colum is declared as igcombo, igcombo will stop functioning --%>
                                $("#yardmulegrid").data("data-MSID", MSID);
                                PageMethods.getDataForAddNewRow(MSID, onSuccess_getDataForAddNewRowForYM, onFail_getDataForAddNewRow);

                            }
                        }
                    },
                },
                           /*     <% --{
                    columnKey: "TRAILNUM",
                    editorType: "combo",
                    required: false,
                    editorOptions: {
                        mode: "editable",
                        enableClearButton: false,
                        initialSelectedItems: [{ value: -1 }],
                        dataSource: GLOBAL_AVAILABLE_TRAILERS,
                        id: "cboxYMTrailerNum",
                        textKey: "TEXT",
                        valueKey: "VALUE",
                        autoSelectFirstMatch: false,
                        selectionChanging: function (evt, ui) {
                            var MSID = $("#yardmulegrid").data("data-MSID");
                            $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text("");//spot number does not work if colum is declared as igcombo, igcombo will stop functioning 
                            if (!checkNullOrUndefined(ui.items) || ui.items.length > 0) {
                                var trailer = ui.items[0].data.VALUE;
                                PageMethods.getDataForAddNewRowUsingTrailerNum(trailer, onSuccess_getDataForAddNewRowUsingTrailerNum, onFail_getDataForAddNewRowUsingTrailerNum);
                            }
                        }
                    }
                }, --%>*/
                { columnKey: "CURRENTSPOT", readOnly: true },
                { columnKey: "SPOT", readOnly: true },
                {
                    columnKey: "NEWSPOT",
                    editorType: "combo",
                    required: true,
                    editorOptions: {
                        mode: "editable",
                        enableClearButton: false,
                        dataSource: GLOBAL_SPOT_OPTIONS,
                        id: "cboxYMNewSpot",
                        textKey: "LABEL",
                        valueKey: "ID",
                        autoSelectFirstMatch: true,
                        selectionChanging: function (evt, ui) {
                            var spot;
                            if (ui.items.length > 0) {
                                spot = ui.items[0].data.ID;
                                                //<% --Check if spot available-- %>
                                                if (!checkNullOrUndefined(spot) && spot != -999) {
                                    var msid = $("#yardmulegrid").data("data-MSID");
                                    //PageMethods.CheckIfSpotIsAvailable(spot, msid, onSuccess_CheckIfSpotIsAvailableWAlert, onFail_CheckIfSpotIsAvailable, spot);
                                    var reqTypeID = $("#cboxYMReqTypes").igCombo("value");

                                    if ((spot != null || -999 != spot) && (reqTypeID != globalRequestType.REQUESTTYPE_OTHER) && !checkNullOrUndefined(reqTypeID)) {
                                        var req = $("#yardmulegrid").data("data-REQID");
                                        if (req > 0) {
                                            PageMethods.checkIfSpotChangeRequestExist_OnRowEdit(msid, req, onSuccess_checkIfSpotChangeRequestExist_OnEdit,
                                                onFail_checkIfSpotChangeRequestExist);
                                        }
                                        else {
                                            PageMethods.checkIfSpotChangeRequestExist(msid, onSuccess_checkIfSpotChangeRequestExist,
                                                onFail_checkIfSpotChangeRequestExist);
                                        }
                                    }
                                }
                            }
                            else {
                                spot = $("#cboxYMNewSpot").igCombo("value");
                                if (checkNullOrUndefined(spot)) {
                                    alert("spot was undefined");
                                }

                            }
                        },
                        selectionChanged: function (evt, ui) {
                            var editor = $("#yardmulegrid").igGridUpdating("editorForKey", "SPOTETADATE");
                            $(editor).igEditor("value", "");
                            editor = $("#yardmulegrid").igGridUpdating("editorForKey", "SPOTETATIME");
                            $(editor).igEditor("value", "");
                        },
                        dropDownOpening: function (evt, ui) {
                            var PONumber = $("#cboxYMMSID").igCombo("value");
                            if (!PONumber) {
                                alert("Select a PO first.");
                                return false;
                            }
                            var reqTypeID = $("#cboxYMReqTypes").igCombo("value");
                            if (checkNullOrUndefined(reqTypeID)) {
                                alert("Select a Request Type first.");
                                return false;
                            }
                            var trailerNum = $("#cboxYMTrailerNum").igCombo("value");
                            if (-999 == trailerNum && reqTypeID == globalRequestType.REQUESTTYPE_OTHER) {
                                $("#cboxYMNewSpot").igCombo("value", -999);// <% --select 'None' option-- %>
                                $('#cboxYMNewSpot').igCombo('option', 'disabled', true);
                            }
                            else {
                                $('#cboxYMNewSpot').igCombo('option', 'disabled', false)
                            }

                        }
                    },
                },
                {
                    columnKey: "REQTYPEID",
                    required: true,
                    editorType: "combo",
                    editorOptions: {
                        dataSource: GLOBAL_REQUEST_YM_OPTIONS,
                        mode: "editable",
                        enableClearButton: false,
                        id: "cboxYMReqTypes",
                        textKey: "LABEL",
                        valueKey: "ID",
                        autoSelectFirstMatch: true,
                        dropDownOpening: function (evt, ui) {
                            var MSID = $("#cboxYMMSID").igCombo("value");

                            if (!MSID || checkNullOrUndefined(MSID)) {
                                alert("Please select a PO/Trailer first.");
                                return false;
                            }
                        },
                        selectionChanged: function (evt, ui) {
                            if (ui.items.length > 0) {
                                var reqTypeID = ui.items[0].data.ID;
                                if (reqTypeID != globalRequestType.REQUESTTYPE_OTHER) {
                                    var msidItems = $("#cboxYMMSID").igCombo("selectedItems");
                                    //if (!checkNullOrUndefined(msidItems[0])) {
                                    //    PageMethods.checkIfRequestTypeExists(msidItems[0].data.ID, reqTypeID, onSuccess_checkIfRequestTypeExists, onFail_checkIfRequestTypeExists);
                                    //}
                                }
                                else {
                                    $("#cboxYMNewSpot").igCombo("index", 0);
                                }
                            }
                        }
                    }
                },
                {
                    columnKey: "DUEDATE",
                    editorType: "datepicker",
                    required: false,
                    editorOptions: {
                        mode: "editable",
                        dateInputFormat: "MM/dd/yyyy",
                        id: "dpDUEDATE",
                        textChanged: function (evt, ui) {
                            var editor = $("#yardmulegrid").igGridUpdating("editorForKey", "DUETIME");
                            $(editor).igEditor("value", "");// <% --empty out the cell-- %>
                                        }
                    }
                },
                {
                    columnKey: "DUETIME",
                    editorType: "text",
                    editorOptions: {
                        id: "txtDUETIME",
                        readOnly: true,
                        mousedown: function (evt, ui) {

                            var DUEeditor = $("#yardmulegrid").igGridUpdating("editorForKey", "DUEDATE");
                            var DUEDate = DUEeditor.igEditor("value");
                            var strDate = null;
                            if (DUEDate) {
                                strDate = String(DUEDate.getMonth() + 1) + "/" + String(DUEDate.getDate()) + "/" + String(DUEDate.getFullYear())
                            }

                            var MSID = $("#yardmulegrid").data("data-MSID");
                            var trucktype = returnItemFromArray(GLOBAL_YARDMULE_DATA, "MSID", MSID, "TRUCKTYPE");
                            if (!trucktype) {
                                trucktype = returnItemFromArray(GLOBAL_YARDMULE_PO_OPTIONS, "ID", MSID, "TRUCKTYPE");
                            }
                            var spot = $("#cboxYMNewSpot").igCombo("value");

                            if (trucktype && strDate && !checkNullOrUndefined(spot)) {
                                PageMethods.GetTimeslotsData(strDate, trucktype, spot, MSID, onSuccess_GetTimeslotsData, onFail_GetTimeslotsData);
                            }
                            else {
                                alert("Please make sure you have selected Appt Date, and Spot");
                            }
                        }
                    }
                },
                {
                    columnKey: "TASK",
                    editorType: "text",
                    editorOptions: {
                        id: "txtYMTASK"
                    }
                },

                {
                    columnKey: "SPOTETADATE",
                    editorType: "datepicker",
                    //required: true,
                    editorOptions: {
                        mode: "editable",
                        dateInputFormat: "MM/dd/yyyy",
                        id: "dpETADATE",
                        textChanged: function (evt, ui) {
                            var editor = $("#yardmulegrid").igGridUpdating("editorForKey", "SPOTETATIME");
                            $(editor).igEditor("value", "");
                        }
                    }
                },
                {
                    columnKey: "SPOTETATIME",
                    editorType: "text",
                    editorOptions: {
                        id: "txtETATIME",
                        readOnly: true,
                        mousedown: function (evt, ui) {
                            var ETAeditor = $("#yardmulegrid").igGridUpdating("editorForKey", "SPOTETADATE");
                            var ETADate = ETAeditor.igEditor("value");
                            var strDate = null;
                            if (ETADate) {
                                strDate = String(ETADate.getMonth() + 1) + "/" + String(ETADate.getDate()) + "/" + String(ETADate.getFullYear());
                            }
                            var MSID = $("#yardmulegrid").data("data-MSID");
                            var trucktype = returnItemFromArray(GLOBAL_YARDMULE_DATA, "MSID", MSID, "TRUCKTYPE");
                            if (!trucktype) {
                                trucktype = returnItemFromArray(GLOBAL_YARDMULE_PO_OPTIONS, "ID", MSID, "TRUCKTYPE");
                            }
                            var spot = $("#cboxYMNewSpot").igCombo("value");

                            if (trucktype && strDate && !checkNullOrUndefined(spot)) {
                                PageMethods.GetTimeslotsData(strDate, trucktype, spot, MSID, onSuccess_GetTimeslotsData, onFail_GetTimeslotsData);
                            }
                            else {
                                alert("Please make sure you have selected Appt Date, and Spot");
                            }
                        }
                    },
                },
                {
                    columnKey: "YM",
                    required: false,
                    editorType: "combo",
                    editorOptions: {
                        dataSource: GLOBAL_YARDMULE_OPTIONS,
                        mode: "editable",
                        enableClearButton: false,
                        id: "cboxYM",
                        textKey: "TEXT",
                        valueKey: "VALUE",
                        autoSelectFirstMatch: true,
                        dropDownOpening: function (evt, ui) {
                            var YMID = $("#yardmulegrid").data("data-YMID");
                            $("#cboxYM").igCombo("value", YMID);
                        }
                    }
                },
                { columnKey: "PRODCOUNT", readOnly: true },
                { columnKey: "PRODID", readOnly: true },
                { columnKey: "PRODDETAIL", readOnly: true },
                { columnKey: "TIMEASSIGNED", readOnly: true },
                { columnKey: "TSTART", readOnly: true },
                { columnKey: "TEND", readOnly: true },
                { columnKey: "COMMENTS", readOnly: true },
            ],
    },
    {
        name: 'Sorting'
    }
]

        });


}