function init_loaderGrid() {

    $("#loadergrid").igGrid({
        dataSource: GLOBAL_LOADER_DATA,
        width: "100%",
        virtualization: false,
        autoGenerateColumns: false,
        renderCheckboxes: true,
        primaryKey: "REQID",
        columns:
            [
                { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true },
                {
                    headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                        "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                },
                {
                    headerText: "Is open in CMS", key: "isOpenInCMS", width: "50px", template: "{{if(${MSIDTEXT} == '(N/A)')}}" +
                        "<div>(N/A)</div>{{else}}<div>${isOpenInCMS}</div>{{/if}}"
                },
                {
                    headerText: "MSID", key: "MSIDTEXT", dataType: "number", width: "0px", template: "{{if(${MSIDTEXT} == -1)}}" +
                        "<div>(N/A)</div>{{else}}<div>${MSIDTEXT}</div>{{/if}}"
                },
                { headerText: "PO - Trailer", key: "POANDTRAILERNUM", dataType: "string", width: "150px" },
                {
                    headerText: "", key: "MSID", unbound: true, dataType: "string", width: "0px", hidden: true, formula: function (row, grid) { return returnItemFromArray(GLOBAL_LOADER_PO_OPTIONS, "ID", row.MSIDTEXT, "LABEL"); }
                },
                {
                    headerText: "Product", key: "PRODID", dataType: "string", width: "150px",
                    template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                        "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                        "{{else}}Multiple{{/if}}"
                },
                { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                {
                    headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                    template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                        "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                        "{{else}}<div><input type='button' value='Multiple' onclick='GLOBAL_ISDIALOG_OPEN = true; openProductDetailDialogLoader(${REQID}); return false;'></div>{{/if}}"
                },
                { headerText: "", key: "SPOTID", dataType: "number", width: "0px", hidden: true },
                {
                    headerText: "Assigned Spot", key: "SPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.SPOTID, "LABEL"); }
                },
                { headerText: "", key: "CURRENTSPOTID", dataType: "number", width: "0px", hidden: true },
                {
                    headerText: "Current Spot", key: "CURRENTSPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.CURRENTSPOTID, "LABEL"); }
                },
                { headerText: "Request Type", key: "REQTYPEID", dataType: "number", width: "70px", formatter: formatRequestCombo },
                { headerText: "Task Comments", key: "TASK", dataType: "string", width: "175px" },
                { headerText: "", key: "LOADERID", dataType: "number", width: "0px" },
                {
                    headerText: "Assigned to", key: "LOADER", unbound: true, dataType: "string", width: "125px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_LOADER_OPTIONS, "VALUE", row.LOADERID, "TEXT"); },
                },
                { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Loader Comments", key: "COMMENTS", dataType: "string", width: "200px" },

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
                    if (ui.rowAdding) {
                        if (ui.columnKey == "SPOT" || ui.columnKey == "TRAILNUM") {
                            return false;
                        }
                    }
                    else {
                        if (ui.columnKey == "MSID" || ui.columnKey == "SPOT" || ui.columnKey == "TRAILNUM" || ui.columnKey == 'REQTYPEID' || "POANDTRAILERNUM" == ui.columnKey) {
                            return false;
                        }

                    }
                },
                rowAdding: function (evt, ui) {
                    var isInvalid = $("#loadergrid").data("data-invalidRequest");

                    var origEvent = evt.originalEvent;
                    if (typeof origEvent == "undefined") {
                        ui.keepEditing = true;
                        return false;
                    }
                    if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                            //<% --get new row data-- %>
                             //submit
                             var continueAdding = false;
                        if (isInvalid) {
                            continueAdding = confirm("This PO has an existing request that is currently not complete. Press Cancel to modify the existing request or OK to continue adding a new request.");
                            // return false;
                        }

                        if (!isInvalid || continueAdding) {
                            var currentLoader = null;
                            if (!checkNullOrUndefined(ui.values.LOADER)) {
                                currentLoader = ui.values.LOADER;
                            }
                            var trailer = null;
                            if (!checkNullOrUndefined(ui.values.TRAILNUM)) {
                                trailer = ui.values.TRAILNUM;
                            }
                            PageMethods.CreateRequest(ui.values.POANDTRAILERNUM, null,  currentLoader, null, globalPersonType.REQUESTPERSON_LOADER, ui.values.REQTYPEID, null, onSuccess_CreateRequestLoader, onFail_CreateRequest);
                            return false;
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        ui.keepEditing = true;
                        return false;
                    }
                },
                rowDeleting: function (evt, ui) {
                    PageMethods.checkStatusOfLoaderRequest(ui.rowID, onSuccess_checkStatusOfLoaderRequest, onFail_checkStatusOfLoaderRequest, 'delete');
                    return false;
                },
                editRowStarting: function (evt, ui) {
                    if (!ui.rowAdding) {
                        var row = ui.owner.grid.findRecordByKey(ui.rowID);
                        if (row.MSID != -1) {
                            //  PageMethods.GetLogDataByMSID(row.MSIDTEXT, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSIDTEXT);
                        }
                        else {
                            $("#tableLog").empty();
                            $("#cboxLogTruckList").igCombo("value", null);
                        }
                        var loader = $("#cboxLoader").igCombo("value");
                        $("#loadergrid").data("data-MSID", row.MSIDTEXT);
                    }
                },
                editRowStarted: function (evt, ui) {
                    if (!ui.rowAdding) {
                        var row = ui.owner.grid.findRecordByKey(ui.rowID);
                        $("#cboxLoader").igCombo("value", row.LOADERID);
                    }
                },
                editRowEnding: function (evt, ui) {
                    if (!ui.rowAdding) {// <% --handle rowAdds in the rowAdding event and not here-- %>
                        $("#loadergrid").data("data-invalidRequest", false);// <% --reset needs to happen inside the if (!ui.rowAdding)--%>
                             var origEvent = evt.originalEvent;
                        var requestStatus = $("#loadergrid").data("data-RequestStatus");
                        if (typeof origEvent == "undefined") {
                            ui.keepEditing = true;
                            return false;
                        }
                        if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                            if (requestStatus.toString() == 'created' || requestStatus.toString() == 'started') {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                var sReply = true;
                                if (requestStatus.toString() == 'started') {
                                    sReply = confirm("The request has been started. Continue?");
                                    if (!sReply) {
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                }
                                var currentLoader = null;
                                if (!checkNullOrUndefined(ui.values.LOADER)) {
                                    currentLoader = ui.values.LOADER;
                                }
                                PageMethods.updateRequest(row.REQID, ui.values.TASK, currentLoader, null, row.REQTYPEID, onSuccess_updateRequestLoader, onFail_updateRequest);//, DUEDATE.toUTCString()
                                return false;
                            }
                            else if (requestStatus.toString() == 'completed') {
                                alert("The request has been completed and can no longer be edited. Please refresh the page to get the update on requests");
                                return false;
                            }
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text(""); //<% --spot number-- %>
                         }
                },
                columnSettings:

                    [
                        { columnKey: "isOpenInCMS", readOnly: true },
                        { columnKey: "REJECT", readOnly: true, required: false },
                        { columnKey: "MSIDTEXT", readOnly: true, required: false },
                        {
                            columnKey: "POANDTRAILERNUM",
                            editorType: "combo",
                            required: true,
                            editorOptions: {
                                mode: "editable",
                                enableClearButton: false,
                                dataSource: GLOBAL_LOADER_PO_OPTIONS,
                                id: "cboxLoadMSID",
                                textKey: "LABEL",
                                valueKey: "ID",
                                autoSelectFirstMatch: true,
                                selectionChanged: function (evt, ui) {
                                    if (ui.items.length > 0) {
                                        $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text("");// <% --spot number-- %>
                                                 var MSID = ui.items[0].data.ID
                                        PageMethods.getRequestTypesBasedOnMSID(MSID, onSuccess_getRequestTypesBasedOnMSID, onFail_getRequestTypesBasedOnMSID, MSID);
                                    }
                                }
                            },
                        },
                        { columnKey: "TRAILNUM", readOnly: true, required: false },
                        { columnKey: "PRODUCT", readOnly: true, required: false },
                        { columnKey: "PRODCOUNT", readOnly: true },
                        { columnKey: "PRODID", readOnly: true },
                        { columnKey: "PRODDETAIL", readOnly: true },
                        { columnKey: "SPOT", readOnly: true, required: false },
                        { columnKey: "CURRENTSPOT", readOnly: true, required: false },
                        {
                            columnKey: "TIMEASSIGNED",
                            editorType: "datepicker",
                            editorOptions: {
                                button: 'spin,dropdown',
                                dateInputFormat: "MM/dd/yyyy HH:mm:ss"
                            }
                        },
                        {
                            columnKey: "LOADER", editorType: "combo",
                            required: false,
                            editorOptions: {
                                dataSource: GLOBAL_LOADER_OPTIONS,
                                mode: "editable",
                                enableClearButton: false,
                                id: "cboxLoader",
                                textKey: "TEXT",
                                valueKey: "VALUE",
                                autoSelectFirstMatch: true
                            }
                        },
                        {
                            columnKey: "REQTYPEID",
                            required: true,
                            editorType: "combo",
                            editorOptions: {
                                dataSource: GLOBAL_REQUEST_LOADER_OPTIONS,
                                mode: "editable",
                                enableClearButton: false,
                                id: "cboxReqTypes",
                                textKey: "LABEL",
                                valueKey: "ID",
                                autoSelectFirstMatch: true,
                                dropDownOpening: function (evt, ui) {
                                    var MSID = $("#cboxLoadMSID").igCombo("value");

                                    if (!MSID) {
                                        alert("Please select a PO/Trailer first.");
                                        return false;
                                    }

                                },
                                selectionChanged: function (evt, ui) {
                                    if (ui.items.length > 0) {
                                        var reqTypeID = ui.items[0].data.ID;
                                        if (reqTypeID != globalRequestType.REQUESTTYPE_OTHER) {
                                            var msidItems = $("#cboxLoadMSID").igCombo("selectedItems");
                                            if (!checkNullOrUndefined(msidItems[0])) {
                                                PageMethods.checkIfRequestTypeExists(msidItems[0].data.ID, reqTypeID, onSuccess_checkIfRequestTypeExists, onFail_checkIfRequestTypeExists);
                                            }
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
                                button: 'dropdown',
                                dateInputFormat: "MM/dd/yyyy",
                                id: "dpLoaderDUEDATE",
                            }
                        },
                        {
                            columnKey: "DUETIME",
                            editorType: "datepicker",
                            required: false,
                            editorOptions: {
                                id: "dpLoaderDueTime",
                                dateInputFormat: "HH:mm",
                                dateDisplayFormat: "HH:mm",
                                nullText: "Enter Time",
                                button: "spin",
                                value: new Date()

                            },
                        },
                        {
                            columnKey: "TASK",
                            editorType: "text",
                            editorOptions: {
                                id: "txtYMTASK",

                            }
                        },
                        { columnKey: "TIMEASSIGNED", readOnly: true, required: false },
                        { columnKey: "TSTART", readOnly: true, required: false },
                        { columnKey: "TEND", readOnly: true, required: false },
                        { columnKey: "COMMENTS", readOnly: true, required: false },
                    ],
            },
            {
                name: 'Sorting'
            }
        ]
    });// <% --end of $("#loadergrid").igGrid({-- %>
}