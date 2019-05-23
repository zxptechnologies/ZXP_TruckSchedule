function init_yardmuleRequestOverviewGrid_Mobile() {

     // <% --will change edit mode when in width is equal to or less than 850px. (for mobile)--%>

        $("#yardmulegrid").igGrid({
            dataSource: [],
            width: "100%",
            virtualization: false,
            autoGenerateColumns: false,
            renderCheckboxes: true,
            primaryKey: "REQID",
            autofitLastColumn: true,
            columns:
                [
                    { headerText: "", key: "REQID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "SPOT", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "NEWSPOT", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "CURRENTSPOT", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "TRAILERNUM", dataType: "string", width: "0%", hidden: true },
                    {
                        headerText: "Image Upload", key: "IMGUP", dataType: "text", width: "15%", template:
                            "<img id = 'CameraImg' src ='Images/camera48x48.png' style='width:75%; height: auto;' onclick='GLOBAL_ISDIALOG_OPEN = true; OnClick_AddImage(event,${MSID}, ${REQID}); return false;'/>"
                    },
                    {
                        headerText: "Files", key: "FUPLOAD", dataType: "string", template: "{{if(${MSID} !== -1)}} " +
                            "<div><input type='button' value='View' onclick='GLOBAL_ISDIALOG_OPEN = true; openUploadDialogMobile(${MSID}, ${REQID}); return false;'></div>" +
                            "{{else}} <div>(N/A)</div>{{/if}}", width: "0%", hidden: true
                    },
                    {
                        headerText: "Rejected", key: "REJECT", dataType: "boolean", template: "{{if(${REJECT})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "0%", hidden: true
                    },
                    { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0%", hidden: true },
                    {
                        headerText: "MSID", key: "MSID", dataType: "number", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}", width: "0%", hidden: true
                    },
                    { headerText: "PO - Trailer", key: "PO", dataType: "string", width: "35%" },
                    { headerText: "Originally Assigned Spot", key: "SPOTDESC", dataType: "string", hidden: true, width: "0%" },
                    { headerText: "Location", key: "LOCATIONTEXT", dataType: "string", width: "0%", hidden: true },
                    { headerText: "Status", key: "STATUSTEXT", dataType: "string", width: "0%", hidden: true },
                    { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", hidden: true, width: "0%" },
                    { headerText: "Move To Spot", key: "NEWSPOTDESC", dataType: "string", hidden: true, width: "0%" },
                    { headerText: "Spot ETA", key: "SPOTETA", dataType: "string", hidden: true, width: "0%"},
                    {
                        headerText: "Product", key: "PRODID", dataType: "string", width: "25%",
                        template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                            "{{else}}Multiple{{/if}}"
                    },
                    { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0%", hidden: true },
                    {
                        headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "25%",
                        template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                            "{{else}}<div><input type='button' value='Multiple' onclick='GLOBAL_ISDIALOG_OPEN = true; openProductDetailDialog(${MSID},${REQID}); return false;'></div>{{/if}}"
                    },
                    { headerText: "Task Comments", key: "TASK", dataType: "string", hidden: true, width: "0%" },
                    { headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", hidden: true, width: "0%" },
                    //{ headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", width: "29%" },
                    { headerText: "Requested by", key: "REQUESTERNAME", dataType: "string", hidden: true, width: "0%" },
                    { headerText: "Time Due", key: "TDUE", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                    { headerText: "Time Started", key: "TSTART", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", hidden: true, width: "0%" },
                    { headerText: "Time End", key: "TEND", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", hidden: true, width: "0%" },
                    { headerText: "Yard Mule Comments", key: "COMMENTS", dataType: "string", hidden: true, width: "0%" },

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
                    editCellStarting: function (evt, ui) {
                        if (!ui.rowAdding) {
                                      if (ui.columnKey == "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "IMGUP") {
                                          return false;
                            }
                        }
                    },
                    editRowStarting: function (evt, ui) {
                        $("#editDialog").data("data-ReqID", ui.rowID);
                        if (!ui.rowAdding) {
                            var row = ui.owner.grid.findRecordByKey(ui.rowID);
                            if (row.MSID !== -1) {
                                $("#btnViewFiles").removeAttr('disabled');
                                $("#btnViewFiles").click(function () { GLOBAL_ISDIALOG_OPEN = true; openUploadDialogMobile(row.MSID, row.REQID); });
                            }
                            else {
                                $("#btnViewFiles").attr("disabled", "disabled");
                            }


                            if (row.REJECT) {
                                $("#RejectEditDialog").html(" Rejected");
                            }
                            else {
                                $("#RejectEditDialog").html(" ");
                            }
                            $("#POEditDialog").html(" " + row.PO);
                            //input type='button' value='View' onclick='GLOBAL_ISDIALOG_OPEN = true; openUploadDialogMobile(${MSID}, ${REQID}); return false;'

                            if (!checkNullOrUndefined(row.STATUSTEXT)) {
                                $("#statusEditDialog").html(row.STATUSTEXT);
                            }
                            else { $("#statusEditDialog").html("N/A"); }
                            if (!checkNullOrUndefined(row.LOCATIONTEXT)) {
                                $("#locationEditDialog").html(row.LOCATIONTEXT);
                            }
                            else { $("#locationEditDialog").html("N/A"); }


                            if (!checkNullOrUndefined(row.SPOTDESC)) {
                                $("#originalSpotEditDialog").html(row.SPOTDESC);
                            }
                            else { $("#originalSpotEditDialog").html("N/A"); }

                            if (!checkNullOrUndefined(row.NEWSPOTDESC)) {
                                $("#newSpotEditDialog").html(row.NEWSPOTDESC);
                            }
                            else { $("#newSpotEditDialog").html("N/A"); }

                            if (!checkNullOrUndefined(row.CURRENTSPOTDESC)) {
                                $("#currentSpotEditDialog").html(row.CURRENTSPOTDESC);
                            }
                            else { $("#currentSpotEditDialog").html("N/A"); }
                            if (row.TASK != null) {
                                $("#taskCommentEditDialog").html(row.TASK);
                            }
                            else { $("#taskCommentEditDialog").html(" "); }

                            $("#requestedByEditDialog").html(row.REQUESTERNAME);
                            if (row.TSTART == null && row.TEND == null) {
                                $("#timeStartedEditDialog").html(" ");
                                $("#btnTimeStartedEditDialog").show();
                                $("#timeStartedUndoEditDialog").hide();

                                $("#timeEndedEditDialog").html(" ");
                                $("#btnTimeEndedEditDialog").hide();
                                $("#timeEndedUndoEditDialog").hide();

                                $("#yardMuleCommentsEditDialog").html(row.COMMENTS);
                                if (GLOBAL_ISDIALOG_OPEN === false) {
                                    $("#editDialog").igDialog("open");
                                }
                                else {
                                    GLOBAL_ISDIALOG_OPEN = false;
                                }
                                return false;

                            }
                            else if (row.TSTART != null && row.TEND == null) {
                                $("#timeStartedEditDialog").html(formatDate(row.TSTART));
                                $("#btnTimeStartedEditDialog").hide();
                                $("#timeStartedUndoEditDialog").show();

                                $("#timeEndedEditDialog").html(" ");
                                $("#btnTimeEndedEditDialog").show();
                                $("#timeEndedUndoEditDialog").hide();

                                $("#yardMuleCommentsEditDialog").html(row.COMMENTS);
                                if (GLOBAL_ISDIALOG_OPEN === false) {
                                    $("#editDialog").igDialog("open");
                                }
                                else {
                                    GLOBAL_ISDIALOG_OPEN = false;
                                }
                                return false;
                            }
                            else if (row.TSTART != null && row.TEND != null) {
                                $("#timeStartedEditDialog").html(formatDate(row.TSTART));
                                $("#btnTimeStartedEditDialog").hide();
                                $("#timeStartedUndoEditDialog").hide();

                                $("#timeEndedEditDialog").html(formatDate(row.TEND));
                                $("#btnTimeEndedEditDialog").hide();
                                $("#timeEndedUndoEditDialog").show();

                                $("#yardMuleCommentsEditDialog").html(row.COMMENTS);
                                if (GLOBAL_ISDIALOG_OPEN === false) {
                                    $("#editDialog").igDialog("open");
                                }
                                else {
                                    GLOBAL_ISDIALOG_OPEN = false;
                                }
                                return false;
                            }
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
                                PageMethods.updateRequest(ui.rowID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                            }

                            else {
                                return false;
                            }
                        }
                    },
                    columnSettings:
                        [
                            { columnKey: "FUPLOAD", readOnly: true },
                            { columnKey: "MSID", readOnly: true },
                            { columnKey: "PO", readOnly: true },
                            { columnKey: "PRODCOUNT", readOnly: true },
                            { columnKey: "PRODID", readOnly: true },
                            { columnKey: "PRODDETAIL", readOnly: true },
                            { columnKey: "SPOTDESC", readOnly: true },
                            { columnKey: "NEWSPOTDESC", readOnly: true },
                            { columnKey: "IMGUP", readOnly: true },
                            { columnKey: "REJECT", readOnly: true },
                            { columnKey: "isOpenInCMS", readOnly: true },
                            { columnKey: "TASK", readOnly: true },
                            { columnKey: "REQUESTERNAME", readOnly: true },
                            { columnKey: "ASSIGNEENAME", readOnly: true },
                            { columnKey: "TDUE", readOnly: true },
                            { columnKey: "TSTART" },
                            { columnKey: "TEND" },
                            {
                                columnKey: "COMMENTS",
                                editorType: "text"
                            },
                            { columnKey: "LOCATIONTEXT", readOnly: true },
                            { columnKey: "STATUSTEXT", readOnly: true }
                        ]
                },
                {
                    name: 'Sorting'
                }
            ]
        });
}





function init_yardmuleRequestOverviewGrid_Regular() {
    $("#yardmulegrid").igGrid({
        dataSource: [],
        width: "100%",
        virtualization: false,
        autoGenerateColumns: false,
        renderCheckboxes: true,
        primaryKey: "REQID",
        columns:
            [
                { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true },
                { headerText: "", key: "SPOT", dataType: "number", width: "0px", hidden: true },
                { headerText: "", key: "NEWSPOT", dataType: "number", width: "0px", hidden: true },
                { headerText: "", key: "CURRENTSPOT", dataType: "number", width: "0px", hidden: true },
                { headerText: "", key: "TRAILERNUM", dataType: "string", width: "0px", hidden: true },
                {
                    headerText: "Image Upload", key: "IMGUP", dataType: "text", width: "60px", template:
                        "<img id = 'CameraImg' src ='Images/camera48x48.png' onclick='OnClick_AddImage(event,${MSID}, ${REQID}); return false;'/>"
                },
                {
                    headerText: "File Upload", key: "FUPLOAD", dataType: "string", width: "85px", template: "{{if(${MSID} !== -1)}} " +
                        "<div><input type='button' value='View/Upload' onclick='openUploadDialog(${MSID}, ${REQID}); return false;'></div>" +
                        "{{else}} <div>(N/A)</div>{{/if}}"
                },
                {
                    headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "85px", template: "{{if(${REJECT})}}" +
                        "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                },
                { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0px" },
                {
                    headerText: "MSID", key: "MSID", dataType: "number", width: "0px", template: "{{if(${MSID} == -1)}}" +
                        "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                },
                { headerText: "PO - Trailer", key: "PO", dataType: "string", width: "150px" },
                { headerText: "Originally Assigned Spot", key: "SPOTDESC", dataType: "string", width: "90px" },
                { headerText: "Location", key: "LOCATIONTEXT", dataType: "string", width: "125px" },
                { headerText: "Status", key: "STATUSTEXT", dataType: "string", width: "150px" },
                { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", width: "90px" },
                { headerText: "Move To Spot", key: "NEWSPOTDESC", dataType: "string", width: "90px" },

                { headerText: "Spot ETA", key: "SPOTETA", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "125px" },
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
                        "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID},${REQID}); return false;'></div>{{/if}}"
                },
                { headerText: "Task Comments", key: "TASK", dataType: "string", hidden: true, width: "0px" },
                //{ headerText: "Task Comments", key: "TASK", dataType: "string", width: "250px" },
                //{ headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", width: "125px" },
                { headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", hidden: true, width: "0px" },
                { headerText: "Requested by", key: "REQUESTERNAME", dataType: "string", width: "125px" },
                { headerText: "Time Due", key: "TDUE", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                {
                    headerText: "Time Started", key: "TSTART", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                    template: "{{if(checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'><input id='btnReqStart' type='button' value='Start' onclick='onclick_startRequest(${REQID}, ${MSID});' class='ColumnContentExtend'/></div>" +
                        "{{elseif (checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'>${TSTART}<span class='Mi4_undoIcon' onclick='undoRequestStart(${REQID}, ${MSID})'></span></div>" +
                        "{{else}}${TSTART}</div>{{/if}}"
                },
                {
                    headerText: "Time End", key: "TEND", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                    template: "<div class ='ColumnContentExtend'>{{if(checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'><input id='btnReqEnd' type='button' value='End' onclick='onclick_completeRequest(${REQID}, ${MSID}, \"${PO}\");' class='ColumnContentExtend'/></div>" +
                        "{{elseif (!checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) ===true}}<div class ='ColumnContentExtend'>${TEND}<span class='Mi4_undoIcon' onclick='undoRequestComplete(${MSID}, ${REQID})'></span></div>" + // <!-- TODO work on undo function, currently disabling until final design--!>
                        "{{elseif (!checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) ===true}}<div class ='ColumnContentExtend'>${TEND}</div>" +
                        "{{else}}<div class ='ColumnContentExtend'></div>{{/if}}"
                },
                { headerText: "Yard Mule Comments", key: "COMMENTS", dataType: "string", width: "250px" },

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
                editCellStarting: function (evt, ui) {
                    if (!ui.rowAdding) {
                                      if (ui.columnKey == "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "IMGUP") { //disable timestamp column edits--%>
                            return false;
                        }
                    }
                },
                editRowStarting: function (evt, ui) {
                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                    if (row.MSID != -1) {
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
                        { columnKey: "FUPLOAD", readOnly: true },
                        { columnKey: "isOpenInCMS", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "PO", readOnly: true },
                        { columnKey: "SPOTDESC", readOnly: true },
                        { columnKey: "NEWSPOTDESC", readOnly: true },
                        { columnKey: "CURRENTSPOTDESC", readOnly: true },
                        { columnKey: "SPOTETA", readOnly: true },
                        { columnKey: "IMGUP", readOnly: true },
                        { columnKey: "REJECT", readOnly: true },
                        { columnKey: "TASK", readOnly: true },
                        { columnKey: "REQUESTERNAME", readOnly: true },
                        { columnKey: "ASSIGNEENAME", readOnly: true },
                        { columnKey: "TDUE", readOnly: true },
                        { columnKey: "TSTART" },
                        { columnKey: "TEND" },
                        {
                            columnKey: "COMMENTS",
                            editorType: "text",
                            editorOptions: {
                                maxLength: 250
                            }
                        },

                        { columnKey: "PRODCOUNT", readOnly: true },
                        { columnKey: "PRODID", readOnly: true },
                        { columnKey: "PRODDETAIL", readOnly: true },
                        { columnKey: "LOCATIONTEXT", readOnly: true },
                        { columnKey: "STATUSTEXT", readOnly: true }

                    ]
            },
            {
                name: 'Sorting'
            }
        ]

    });
}
