<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="dockManager.aspx.cs" Inherits="TransportationProject.dockManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="Scripts/gridCreator.js"></script>
    <link href="Content/scheduleGrid.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Dock Manager</h2>
    <h3>Create, edit, and view current requests for loaders and yard mule. Shows the status of open requests and all completed requests for the day.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
        <Scripts>
            <asp:ScriptReference Name="MicrosoftAjax.js" Path="Scripts/WebForms/MSAjax/MicrosoftAjax.js" />
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_ASSIGNEES_OPTIONS = [];
        var GLOBAL_LOADER_OPTIONS = [];
        var GLOBAL_REQUEST_LOADER_OPTIONS = [];
        var GLOBAL_REQUEST_YM_OPTIONS = [];
        var GLOBAL_REQUEST_OPTIONS = [];
        var GLOBAL_REQUEST_OPTIONS_FORMATTER = [];
        var GLOBAL_YARDMULE_OPTIONS = [];
        var GLOBAL_LOADER_PO_OPTIONS = [];
        var GLOBAL_YARDMULE_PO_OPTIONS = [];
        var GLOBAL_SPOT_OPTIONS = [];
        var GLOBAL_SPOT_OPTIONS_FORMATTER = [];
        var GLOBAL_LOADER_DATA = [];
        var GLOBAL_YARDMULE_DATA = [];
        var GLOBAL_COMPLETE_DATA = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_PERSON_OPTIONS = [];
        var GLOBAL_AVAILABLE_TRAILERS = [];
        var GLOBAL_ISDIALOG_OPEN = false;


        <%--Keep synced with table RequestPersonTypes--%>
        var globalPersonType = (function () {
            var g =
            {
                <%--key for RequestPersonType: value of RequestPersonTypeID--%>
                REQUESTPERSON_LOADER: 1,
                REQUESTPERSON_YARDMULE: 2,
            }
            return g;
        })();

        <%--Keep synced with table RequestTypes--%>
        var globalRequestType = (function () {
            var g =
            {
                <%--key for RequestType: value of RequestTypeID--%>
                REQUESTTYPE_LOAD: 1,
                REQUESTTYPE_UNLOAD: 2,
                REQUESTTYPE_OTHER: 3,
                REQUESTTYPE_MOVE: 4,
                REQUESTTYPE_MOVEDROPTRAILER: 5,
            }
            return g;
        })();


        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>

        $(window).resize(function () {

            $("#dwSchedule").dialog("option", "position", "center");

        });

        function openProductDetailDialogYM(MSID, rowID) {
            if (MSID != -1) {
                var PO = $("#yardmulegrid").igGrid("getCellValue", rowID, "PO");
                var trailerNum = $("#yardmulegrid").igGrid("getCellValue", rowID, "TRAILNUM");
                var POTrailerCombo = comboPOAndTrailer(PO, trailerNum);
                PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
                if (PO) {
                    $("#dvProductDetailsPONUM").text(POAndTrailer);
                }

            }
        }
        function openProductDetailDialogLoader(rowID) {
            var POAndTrailer = $("#loadergrid").igGrid("getCellValue", rowID, "MSID");
            var MSID = $("#loadergrid").igGrid("getCellValue", rowID, "MSIDTEXT");
            if (MSID) {
                PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
                if (POAndTrailer) {
                    $("#dvProductDetailsPONUM").text(POAndTrailer);
                }
            }
        }

        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        <%-- turns MSID to associated PO --%>
        function formatYardmulePOCombo(val) {
            var i, temp;
            for (i = 0; i < GLOBAL_YARDMULE_PO_OPTIONS.length; i++) {
                temp = GLOBAL_YARDMULE_PO_OPTIONS[i];
                if (temp.ID == val) {
                    val = temp.LABEL;
                    return val;
                }
            }
        }
        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        <%-- turns MSID to associated PO --%>
        function formatLoaderPOCombo(val) {
            var i, temp;
            for (i = 0; i < GLOBAL_LOADER_PO_OPTIONS.length; i++) {
                temp = GLOBAL_LOADER_PO_OPTIONS[i];
                if (temp.ID == val) {
                    val = temp.LABEL;
                    return val;
                }
            }
        }

        //Formatting for igGrid cells to display igCombo text as opposed to igCombo value
        function formatYardmuleCombo(val) {
            var i, ym;
            for (i = 0; i < GLOBAL_YARDMULE_OPTIONS.length; i++) {
                ym = GLOBAL_YARDMULE_OPTIONS[i];
                if (ym.VALUE == val) {
                    val = ym.TEXT;
                    return val;
                }
            }
        }
        //Formatting for igGrid cells to display igCombo text as opposed to igCombo value
        function formatLoaderCombo(val) {
            var i, loader;
            for (i = 0; i < GLOBAL_LOADER_OPTIONS.length; i++) {
                loader = GLOBAL_LOADER_OPTIONS[i];
                if (loader.VALUE == val) {
                    val = loader.TEXT;
                    return val;
                }
            }
        }

        function formatSpotCombo(val) {
            var i, spot;
            for (i = 0; i < GLOBAL_SPOT_OPTIONS_FORMATTER.length; i++) {
                spot = GLOBAL_SPOT_OPTIONS_FORMATTER[i];
                if (spot.ID == val) {
                    val = spot.LABEL;
                    return val;

                }
            }

            return val;
        }

        function formatRequestCombo(val) {
            var i, req;
            for (i = 0; i < GLOBAL_REQUEST_OPTIONS_FORMATTER.length; i++) {
                req = GLOBAL_REQUEST_OPTIONS_FORMATTER[i];
                if (req.ID == val) {
                    val = req.LABEL;
                    return val;
                }
            }
        }


        function init_grid() {
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
                        { headerText: "MSID", key: "MSIDTEXT", dataType: "string", width: "100px" },
                        {
                            headerText: "PO", key: "MSID", unbound: true, dataType: "string", width: "100px", template: "{{if(${MSIDTEXT} == '(N/A)')}}" +
                                          "<div>(N/A)</div>{{else}}<div>${PO}</div>{{/if}}"
                        },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "100px" },
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
                            headerText: "Orginally Assigned Spot", key: "SPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.SPOTID, "LABEL"); }
                        },
                        { headerText: "", key: "CURRENTSPOTID", dataType: "number", width: "0px", hidden: true },
                        {
                            headerText: "Current Spot", key: "CURRENTSPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.CURRENTSPOTID, "LABEL"); }
                        },
                        { headerText: "", key: "NEWSPOTID", dataType: "number", width: "0px", },
                        {
                            headerText: "Move To Spot", key: "NEWSPOT", unbound: true, dataType: "string", width: "100px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS_FORMATTER, "ID", row.NEWSPOTID, "LABEL"); }
                        },
                        { headerText: "Due Date", key: "DUEDATE", dataType: "date", format: "MM/dd/yyyy", width: "0px", hidden: true },
                        { headerText: "Due Time (24HR)", key: "DUETIME", dataType: "string", width: "0px", hidden: true },
                        { headerText: "Task Comments", key: "TASK", dataType: "string", width: "150px" },
                        { headerText: "", key: "YMID", dataType: "number", width: "0px" },
                        {
                            headerText: "Assigned to", key: "YM", unbound: true, dataType: "string", width: "100px",
                            formula: function (row, grid) {
                                return returnItemFromArray(GLOBAL_YARDMULE_OPTIONS, "VALUE", row.YMID, "TEXT");
                            },
                        },
                        { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                        { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                        { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "100px" },
                        { headerText: "Yard Mule Comments", key: "COMMENTS", dataType: "string", width: "100px" },
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
                         if (ui.rowAdding) {<%-- new row--%>
                             if (ui.columnKey === "SPOT") { <%-- disable--%>
                                 return false;
                             }
                         }
                         else { <%-- row edit --%>
                             if (ui.columnKey == "MSID" || ui.columnKey === "SPOT" || ui.columnKey === "TRAILNUM") {
                                 return false;
                             }
                         }
                     },
                     rowAdding: function (evt, ui) {
                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
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
                                 if (!isExisting) {
                                     var trailer = null;
                                     if (!checkNullOrUndefined(ui.values.TRAILNUM)) {
                                         trailer = ui.values.TRAILNUM;
                                     }
                                     var assignedYM = null;
                                     if (!checkNullOrUndefined(ui.values.YM) == true) {
                                         assignedYM = ui.values.YM;
                                     }

                                     if (ui.values.MSID > 0) {
                                         if (ui.values.REQTYPEID === globalRequestType.REQUESTTYPE_MOVE) {
                                             PageMethods.createRequest(ui.values.MSID, trailer, ui.values.TASK, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVE, onSuccess_createRequestYardMule, onFail_createRequest);
                                             return false;
                                         }
                                         else if (ui.values.REQTYPEID === globalRequestType.REQUESTTYPE_MOVEDROPTRAILER) {
                                             PageMethods.createRequest(ui.values.MSID, trailer, ui.values.TASK, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVEDROPTRAILER, onSuccess_createRequestYardMule, onFail_createRequest);
                                             return false;
                                         }
                                         else {
                                             PageMethods.createRequest(ui.values.MSID, trailer, ui.values.TASK, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_OTHER, onSuccess_createRequestYardMule, onFail_createRequest);
                                             return false;
                                         }

                                     }
                                     else {
                                         if (ui.values.REQTYPEID === globalRequestType.REQUESTTYPE_MOVEDROPTRAILER) {
                                             PageMethods.createRequest(ui.values.MSID, trailer, ui.values.TASK, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_MOVEDROPTRAILER, onSuccess_createRequestYardMule, onFail_createRequest);
                                             return false;
                                         }
                                         else {
                                             PageMethods.createRequest(ui.values.MSID, trailer, ui.values.TASK, assignedYM, ui.values.NEWSPOT, globalPersonType.REQUESTPERSON_YARDMULE, globalRequestType.REQUESTTYPE_OTHER, onSuccess_createRequestYardMule, onFail_createRequest);
                                             return false;
                                         }

                                     }
                                 }
                                 else {
                                     alert("This PO has a move request that is currently not complete. Please modify the orginal request.");
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

                         $("#yardmulegrid").data("data-existingSpot", false); <%--reset--%>
                         $("#yardmulegrid").data("data-invalidSpot", false); <%--reset--%>
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
                             if (row.MSID > 0) {
                                 PageMethods.getLogDataByMSID(row.MSIDTEXT, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSIDTEXT);
                             }
                             else {
                                 $("#tableLog").empty();
                                 $("#cboxLogTruckList").igCombo("value", null);
                             }
                             if (checkNullOrUndefined(row.MSID) == true) {
                                 PageMethods.getSpotsByType(0, onSuccess_getSpotsByType, onFail_getSpotsByType, row.NEWSPOTID);
                                 $("#yardmulegrid").data("data-MSID", 0);
                             }
                             else {
                                 PageMethods.getSpotsByType(row.MSID, onSuccess_getSpotsByType, onFail_getSpotsByType, row.NEWSPOTID);
                                 $("#yardmulegrid").data("data-MSID", row.MSID);
                             }

                             $("#cboxYM").igCombo("text", row.YMID);
                             $("#yardmulegrid").data("data-YMID", row.YMID);

                         }
                         else {
                             $("#yardmulegrid").data("data-MSID", -1);
                             PageMethods.getSpotsByType(-1, onSuccess_getSpotsByType, onFail_getSpotsByType); <%--get spots as if PO is N/A--%>
                             //$("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(3)").text(""); <%-- trailer number --%>
                             $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(""); <%-- spot number --%>
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
                         if (!ui.rowAdding) { <%-- //handle rowAdds in the rowAdding event and not here --%>
                             var requestStatus = $("#yardmulegrid").data("data-RequestStatus");
                             if (typeof origEvent === "undefined") {
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
                                         if (isExisting == false) {
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
                                             PageMethods.updateRequest(row.REQID, ui.values.TASK, assignedYM, ui.values.NEWSPOT, row.REQTYPEID, onSuccess_updateRequestYardMule, onFail_updateRequest);//, DUEDATE.toUTCString()
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
                             $("#yardmulegrid").data("data-existingSpot", false); <%--reset--%>
                             $("#yardmulegrid").data("data-invalidSpot", false); <%--reset--%>

                         }
                         else {

                             $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(""); <%-- spot number --%>

                         }
                     },
                     columnSettings:
                          [
                                { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "REJECT", readOnly: true },
                                 { columnKey: "MSIDTEXT", readOnly: true },
                                 {
                                     columnKey: "MSID",
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
                                                 $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(""); <%-- spot number //does not work if colum is declared as igcombo, igcombo will stop functioning --%>
                                                 $("#yardmulegrid").data("data-MSID", MSID);
                                                 PageMethods.getDataForAddNewRow(MSID, onSuccess_getDataForAddNewRowForYM, onFail_getDataForAddNewRow);
                                                 
                                             }
                                         }
                                     },
                                 },
                                {
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
                                            $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(""); <%-- spot number //does not work if colum is declared as igcombo, igcombo will stop functioning --%>
                                            if (!checkNullOrUndefined(ui.items) || ui.items.length > 0) { 
                                                var trailer = ui.items[0].data.VALUE;
                                                PageMethods.getDataForAddNewRowUsingTrailerNum(trailer, onSuccess_getDataForAddNewRowUsingTrailerNum, onFail_getDataForAddNewRowUsingTrailerNum);
                                            }
                                        }
                                    }
                                },
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
                                            if (ui.items.length > 0) {
                                                var spot = ui.items[0].data.ID;
                                                <%--Check if spot available --%>
                                                if (!checkNullOrUndefined(spot) && spot != -999) {
                                                    var msid = $("#yardmulegrid").data("data-MSID");
                                                    //PageMethods.checkIfSpotIsAvailable(spot, msid, onSuccess_checkIfSpotIsAvailableWAlert, onFail_checkIfSpotIsAvailable, spot);
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
                                                var spot = $("#cboxYMNewSpot").igCombo("value");
                                                if (checkNullOrUndefined(spot)) {
                                                    alert("spot was undefined");
                                                }

                                            }
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
                                            if (-999 === trailerNum && reqTypeID === globalRequestType.REQUESTTYPE_OTHER) {
                                                $("#cboxYMNewSpot").igCombo("value", -999); <%--select 'None' option --%>
                                                $('#cboxYMNewSpot').igCombo('option', 'disabled', true)
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
                                                    if (!checkNullOrUndefined(msidItems[0])) {
                                                        PageMethods.checkIfRequestTypeExists(msidItems[0].data.ID, reqTypeID, onSuccess_checkIfRequestTypeExists, onFail_checkIfRequestTypeExists);
                                                    }
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
                                            $(editor).igEditor("value", ""); <%--empty out the cell--%>
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
                                                PageMethods.getTimeslotsData(strDate, trucktype, spot, MSID, onSuccess_getTimeslotsData, onFail_getTimeslotsData);
                                            }
                                            else {
                                                alert("Please make sure you have selected Appt Date, and Spot");
                                            }
                                        }
                                    },
                                },
                                {
                                    columnKey: "TASK",
                                    editorType: "text",
                                    editorOptions: {
                                        id: "txtYMTASK"
                                    }
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
                                         },
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

            }); <%--end yard mule grid--%>


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
                            headerText: "MSID", key: "MSIDTEXT", dataType: "number", width: "45px", template: "{{if(${MSIDTEXT} == -1)}}" +
                                  "<div>(N/A)</div>{{else}}<div>${MSIDTEXT}</div>{{/if}}"
                        },
                        {
                            headerText: "PO - Trailer", key: "MSID", unbound: true, dataType: "string", width: "150px", formula: function (row, grid) { return returnItemFromArray(GLOBAL_LOADER_PO_OPTIONS, "ID", row.MSIDTEXT, "LABEL"); }
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
                        { headerText: "Task Comments", key: "TASK", dataType: "string", width: "450px" },
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
                             if (ui.columnKey === "SPOT" || ui.columnKey === "TRAILNUM") {
                                 return false;
                             }
                         }
                         else {
                             if (ui.columnKey === "MSID" || ui.columnKey === "SPOT" || ui.columnKey === "TRAILNUM" || ui.columnKey === 'REQTYPEID') {
                                 return false;
                             }

                         }
                     },
                     rowAdding: function (evt, ui) {
                         var isInvalid = $("#loadergrid").data("data-invalidRequest");

                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
                             ui.keepEditing = true;
                             return false;
                         }
                         if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                            <%--get new row data--%>
                             //submit
                             if (isInvalid) {
                                 alert("Cannot create new request because there is already an existing request open. Please modify that instead.");
                                 return false;
                             }
                             else {
                                 var currentLoader = null;
                                 if (!checkNullOrUndefined(ui.values.LOADER)) {
                                     currentLoader = ui.values.LOADER;
                                 }
                                 PageMethods.createRequest(ui.values.MSID, null, ui.values.TASK, currentLoader, null, globalPersonType.REQUESTPERSON_LOADER, ui.values.REQTYPEID, onSuccess_createRequestLoader, onFail_createRequest);
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
                                 PageMethods.getLogDataByMSID(row.MSIDTEXT, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSIDTEXT);
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
                         if (!ui.rowAdding) { <%--handle rowAdds in the rowAdding event and not here--%>
                             $("#loadergrid").data("data-invalidRequest", false); <%--reset needs to happen inside the if(!ui.rowAdding)--%>
                             var origEvent = evt.originalEvent;
                             var requestStatus = $("#loadergrid").data("data-RequestStatus");
                             if (typeof origEvent === "undefined") {
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
                             $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text(""); <%-- spot number --%>
                         }
                     },
                     columnSettings:

                    [
                                { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "REJECT", readOnly: true, required: false },
                                 { columnKey: "MSIDTEXT", readOnly: true, required: false },
                                 {
                                     columnKey: "MSID",
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
                                                 $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text(""); <%-- spot number --%>
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
            }); <%--end of $("#loadergrid").igGrid({--%>






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
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "50px" },
                        { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true, readOnly: true },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "75px" },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "150px" },
                        { headerText: "New Spot (If Applicable)", key: "NEWSPOT", dataType: "number", width: "100px", formatter: formatSpotCombo },
                        { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "200px" },
                        { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "125px" },
                        { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                        { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "125px" },
                        { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "200px" },
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
                     columnSettings:
					 [
                         { columnKey: "isOpenInCMS", readOnly: true },
                         { columnKey: "REJECT", readOnly: true },
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
						{ columnKey: "REJECT", readOnly: true },
						{ columnKey: "DUETIME", readOnly: true }
					 ]
                 }
                ]

            }); <%--end complete grid--%>

        }
        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
        function onSuccess_getPODetailsFromMSID(value, ctx, methodName) {

            var gridData = [];
            for (i = 0; i < value.length; i++) {
                gridData[i] = {
                    "PODETAILID": value[i][0], "CMSPROD": value[i][1], "QTY": value[i][2], "LOT": value[i][3], "UNIT": value[i][4], "CMSPRODNAME": value[i][5]
                };
            }
            $("#gridPODetails").igGrid("option", "dataSource", gridData);
            $("#gridPODetails").igGrid("dataBind");
            $("#dwProductDetails").igDialog("open");

        }

        function onFail_getPODetailsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getPODetailsFromMSID");
        }
        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }

        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx onFail_getLogDataByMSID");
        }

        function onSuccess_getRequestTypesBasedOnMSID(value, MSID, methodName) {
            if (value) {
                GLOBAL_REQUEST_OPTIONS = [];

                for (i = 0; i < value.length; i++) {
                    GLOBAL_REQUEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                }
                $("#cboxReqTypes").igCombo('option', 'dataSource', GLOBAL_REQUEST_OPTIONS);
                $("#cboxReqTypes").igCombo("dataBind");
            }
            PageMethods.getDataForAddNewRow(MSID, onSuccess_getDataForAddNewRowForLoader, onFail_getDataForAddNewRow);
        }

        function onFail_getRequestTypesBasedOnMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestTypeBasedOnMSID");
        }

        function onSuccess_getLogList(value, ctx, methodName) {
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);
                    GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                }
                $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                $("#cboxLogTruckList").igCombo("dataBind");
            }
        }

        function onFail_getLogList(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx onFail_getLogList");
        }

        function onSuccess_checkStatusOfYMRequest(value, updateType, methodName) {
            <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
            if (value.length) {
                var reqID = value[0][0];
                var eventType = value[0][1];
                var date = formatDate(value[0][2]);
                var assigneeName = value[0][3];
                var MSID = $("#yardmulegrid").igGrid("getCellValue", reqID, "MSIDTEXT");
                var PONUM = formatYardmulePOCombo(MSID);
                if (updateType == 'delete') {
                    if (eventType == 17) {<%--Request has been created.--%>
                        var r = confirm("Continue deleting request for " + PONUM + "? Deletion cannot be undone.");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 21) { <%--Request has been started.--%>
                        var r = confirm(assigneeName + " has started the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 18) { <%--Request has been completed.--%>
                        var r = confirm(assigneeName + " has completed the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
            }

            else if (updateType == 'update') {
                if (eventType == 17) {<%--Request has been created.--%>
                    $("#yardmulegrid").data("data-RequestStatus", 'created');
                }
                else if (eventType == 21) { <%--Request has been started.--%>
                    alert("You can no longer edit this request because " + assigneeName + " has started it " + date + ".");
                    $("#yardmulegrid").data("data-RequestStatus", 'started');
                }
                else if (eventType == 18) { <%--Request has been completed.--%>
                    alert("You can no longer edit this request because " + assigneeName + " has completed it " + date + ".");
                    $("#yardmulegrid").data("data-RequestStatus", 'completed');
                }
        }
}
else {
                <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
                alert("The request you are attempting to update has been deleted or has been completed. Please refresh the page to get the current status of all request.");
            }
        }
        function onFail_checkStatusOfYMRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkStatusOfYMRequest");
        }


        function onSuccess_checkStatusOfLoaderRequest(value, updateType, methodName) {
            <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
            if (value.length) {
                var reqID = value[0][0];
                var eventType = value[0][1];
                var date = formatDate(value[0][2]);
                var assigneeName = value[0][3];
                var MSID = $("#loadergrid").igGrid("getCellValue", reqID, "MSIDTEXT");

                var PONUM = formatYardmulePOCombo(MSID);
                if (updateType == 'delete') {
                    if (eventType == 2027) { <%--Request has been created.--%>
                        var r = confirm("Continue deleting request for " + PONUM + "? Deletion cannot be undone.");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 2030 || eventType == 13 || eventType == 15) { <%--Request has been updated.--%>
                        var r = confirm(assigneeName + " has started the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 2031 || eventType == 14 || eventType == 16) { <%--Request has been completed.--%>
                        var r = confirm(assigneeName + " has completed the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
            }
            else if (updateType == 'update') {
                if (eventType == 2027) {<%--Request has been created.--%>
                    $("#loadergrid").data("data-RequestStatus", 'created');
                }
                else if (eventType == 2030 || eventType == 13 || eventType == 15) { <%--Request has been updated.--%>
                    alert("You can no longer edit this request because " + assigneeName + " has started it " + date + ".");
                    $("#loadergrid").data("data-RequestStatus", 'started');
                }
                else if (eventType == 2031 || eventType == 14 || eventType == 16) { <%--Request has been completed.--%>
                    alert("You can no longer edit this request because " + assigneeName + " has completed it " + date + ".");
                    $("#loadergrid").data("data-RequestStatus", 'completed');
                }
        }
}
else {
                <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
                alert("The request you are attempting to update has been deleted or has been completed. Please refresh the page to get the current status of all request.");
            }
        }
        function onFail_checkStatusOfLoaderRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkStatusOfLoaderRequest");
        }
        function onSuccess_createRequestYardMule(value, ctx, methodName) {
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }
        function onSuccess_createRequestLoader(value, ctx, methodName) {
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }
        function onFail_createRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_createRequest");
        }

        function onSuccess_checkIfSpotIsAvailableWAlert(value, ctx, methodName) {
            if (value != 0) {
                alert("The spot chosen is currently reserved or is occupied. Please modify or proceed with caution.");
                $("#yardmulegrid").data("data-invalidSpot", true);
                return false;
            }
            else if (value == 0) {
                $("#yardmulegrid").data("data-invalidSpot", false);
            }
        }

        function onSuccess_checkIfRequestTypeExists(value, ctx, methodName) {
            if (value != 0) {
                alert("Cannot create new request because there is already an existing request open. Please modify that instead.")
                $("#loadergrid").data("data-invalidRequest", true);
            }
            else { <%-- valid spot --%>
                $("#loadergrid").data("data-invalidRequest", false);
            }
        }

        function onFail_checkIfRequestTypeExists(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkIfRequestTypeExists");
        }


        function onSuccess_checkIfSpotIsAvailableWConfirm(value, ctx, methodName) {
            if (value != 0) {
                alert("Cannot update. The spot is currently reserved or is occupied. Please modify or proceed with caution.")
                $("#yardmulegrid").data("data-invalidSpot", true);
                return false;
            }
            else { <%-- valid spot --%>
                var row = ctx.owner.grid.findRecordByKey(ctx.rowID);
                $("#yardmulegrid").data("data-invalidSpot", false);
                var assignedYM = null;
                if (!checkNullOrUndefined(ctx.values.YM) == true) {
                    assignedYM = ctx.values.YM;
                }

                PageMethods.updateRequest(row.REQID, ctx.values.TASK, assignedYM, ctx.values.NEWSPOT, row.REQTYPEID, onSuccess_updateRequestYardMule, onFail_updateRequest);//, DUE.toUTCString()
            }

        }

        function onFail_checkIfSpotIsAvailable(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkIfSpotIsAvailable");
        }

        function onSuccess_deleteRequestYardmule(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }

        function onSuccess_deleteRequestLoader(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }
        function onFail_deleteRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_deleteRequest");
        }

        function onSuccess_updateRequestYardMule(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }

        function onSuccess_updateRequestLoader(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }

        function onFail_updateRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_updateRequest");
        }

        function onSuccess_getYardMules(value, ctx, methodName) {
            GLOBAL_YARDMULE_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var fullname = value[i][2] + " " + value[i][3];
                GLOBAL_YARDMULE_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": fullname };
            }
            PageMethods.getLoaders(onSuccess_getLoaders, onFail_getLoaders);
        }
        function onFail_getYardMules(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getYardMules");
        }



        function onSuccess_getLoaders(value, ctx, methodName) {
            GLOBAL_LOADER_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var fullname = value[i][2] + " " + value[i][3];
                GLOBAL_LOADER_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": fullname };
            }
            PageMethods.getCurrentAvailableTrailers(onSuccess_getCurrentAvailableTrailers, onFail_getCurrentAvailableTrailers);

        }

        function onFail_getLoaders(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getLoaders");
        }

        function onSuccess_getCurrentAvailableTrailers(value, ctx, methodName) {
            GLOBAL_AVAILABLE_TRAILERS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_AVAILABLE_TRAILERS[i] = { "MSID": value[i][0], "VALUE": value[i][1], "TEXT": value[i][1] };
            }
            PageMethods.getRequestPersonTypes(onSuccess_getRequestPersonTypes, onFail_getRequestPersonTypes);

        }

        function onFail_getCurrentAvailableTrailers(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getCurrentAvailableTrailers");
        }


        function onSuccess_getRequestPersonTypes(value, ctx, methodName) {
            GLOBAL_PERSON_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_PERSON_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            PageMethods.getRequestTypes(null, onSuccess_getRequestTypes, onFail_getRequestTypes);

        }

        function onFail_getRequestPersonTypes(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestPersonTypes");
        }



        function onSuccess_getRequestTypes(value, ctx, methodName) {
            GLOBAL_REQUEST_OPTIONS.length = 0;
            GLOBAL_REQUEST_OPTIONS_FORMATTER.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                GLOBAL_REQUEST_OPTIONS_FORMATTER[i] = { "ID": value[i][0], "LABEL": value[i][1] };

            }
            var requestpersontype = 2;
            PageMethods.getRequestTypes(requestpersontype, onSuccess_getRequestTypesYardmule, onFail_getRequestTypes);

        }

        function onSuccess_getRequestTypesYardmule(value, ctx, methodName) {
            GLOBAL_REQUEST_YM_OPTIONS.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_YM_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            var requestpersontype = 1;
            PageMethods.getRequestTypes(requestpersontype, onSuccess_getRequestTypesLoaders, onFail_getRequestTypes);

        }
        function onSuccess_getRequestTypesLoaders(value, ctx, methodName) {
            GLOBAL_REQUEST_LOADER_OPTIONS.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_LOADER_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }

            PageMethods.getSpots(onSuccess_getSpots, onFail_getSpots);

        }

        function onFail_getRequestTypes(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestTypes");
        }

        function onSuccess_getSpots(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                GLOBAL_SPOT_OPTIONS_FORMATTER[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            GLOBAL_SPOT_OPTIONS_FORMATTER.unshift({ "ID": null, "LABEL": "(NONE)" });
            PageMethods.getAvailablePONumberForYardmuleRequests(onSuccess_getAvailablePONumberForYardmuleRequests, onFail_getAvailablePONumberForYardmuleRequests);
        }

        function onFail_getSpots(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getSpots");
        }

        function onSuccess_getSpotsByType(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            $("#cboxYMNewSpot").igCombo("option", "dataSource", GLOBAL_SPOT_OPTIONS);
            $("#cboxYMNewSpot").igCombo("dataBind");

            if (ctx) {
                $("#cboxYMNewSpot").igCombo("value", ctx);
            }
        }

        function onFail_getSpotsByType(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getSpotsByType");
        }
        function onSuccess_getAvailablePONumberForYardmuleRequests(value, ctx, methodName) {
            GLOBAL_YARDMULE_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_YARDMULE_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1], "TRUCKTYPE": value[i][2] };
            }
            PageMethods.getAvailablePONumberForLoaderRequests(onSuccess_getAvailablePONumberForLoaderRequests, onFail_getAvailablePONumberForLoaderRequests);
        }
        function onFail_getAvailablePONumberForYardmuleRequests(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getAvailablePONumberForYardmuleRequests");
        }
        function onSuccess_getAvailablePONumberForLoaderRequests(value, ctx, methodName) {
            GLOBAL_LOADER_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOADER_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1], "TRUCKTYPE": value[i][2] };
            }
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridData, onFail_getLoaderRequestsGridData);
        }

        function onFail_getAvailablePONumberForLoaderRequests(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getAvailablePONumberForYardmuleRequests");
        }
        function onSuccess_getLoaderRequestsGridData(value, ctx, methodName) {
            GLOBAL_LOADER_DATA.length = 0;
            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                var MSID;
                var strDUETime = "";
                if (value[i][14]) {
                    var strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }
                if (value[i][0] == -1) {
                    isOpenInCMS = formatValueToValueOrNA(value[i][16]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][16]);
                }

                var trailNumber = value[i][12].toString();
                GLOBAL_LOADER_DATA[i] =
                {
                    "MSID": value[i][0], "MSIDTEXT": value[i][0], "PO": value[i][1], "REQID": value[i][2], "TASK": value[i][3], "LOADER": value[i][4], "LOADERID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": trailNumber, "REQTYPEID": value[i][13], "DUE": value[i][14], "DUEDATE": value[i][14],
                    "DUETIME": strDUETime, "REJECT": value[i][15], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][17], "CURRENTSPOT": value[i][17], //, "PRODUCT": value[i][18]
                    "PRODCOUNT": value[i][18], "PRODID": value[i][19], "PRODDETAIL": value[i][20]
                };
            }

            <%--Call Function to retrieve yard mule grid data--%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridData, onFail_getYardMuleRequestsGridData);
        }
        function onSuccess_getLoaderRequestsGridDataReload(value, ctx, methodName) {
            var MSID = $("#loadergrid").data("data-MSID");
            if (MSID > 0) {
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            }
            else {
                $("#tableLog").empty();
                $("#cboxLogTruckList").igCombo("value", null);
            }
            $("#loadergrid").data("data-MSID", "");
            GLOBAL_LOADER_DATA.length = 0;

            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                var MSID;
                var strDUETime = "";
                if (value[i][14]) {
                    var strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }

                if (value[i][0] == -1) {
                    isOpenInCMS = formatValueToValueOrNA(value[i][16]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][16]);
                }
                GLOBAL_LOADER_DATA[i] =
                {
                    "MSID": value[i][0], "MSIDTEXT": value[i][0], "PO": value[i][1], "REQID": value[i][2], "TASK": value[i][3], "LOADER": value[i][4], "LOADERID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": value[i][12], "REQTYPEID": value[i][13], "DUE": value[i][14], "DUEDATE": value[i][14],
                    "DUETIME": strDUETime, "REJECT": value[i][15], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][17], "CURRENTSPOT": value[i][17], //, "PRODUCT": value[i][18]
                    "PRODCOUNT": value[i][18], "PRODID": value[i][19], "PRODDETAIL": value[i][20]
                };
            }
            $("#loadergrid").igGrid("option", "dataSource", GLOBAL_LOADER_DATA);
            $("#loadergrid").igGrid("dataBind");
        }

        function onFail_getLoaderRequestsGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getLoaderRequestsGridData");
        }

        function onSuccess_checkIfSpotChangeRequestExist(value, ctx, methodName) {
            if (value != 0) {
                alert("This PO has a move request that is currently not complete. Please modify the orginal request");
                $("#yardmulegrid").data("data-existingSpot", true);
            }
            else { $("#yardmulegrid").data("data-existingSpot", false); }
        }
        function onSuccess_checkIfSpotChangeRequestExist_OnEdit(value, ctx, methodName) {
            if (value != 0) {
                alert("This PO has a move request that is currently not complete. Please modify the orginal request");
                $("#yardmulegrid").data("data-existingSpot", true);
            }
            else { $("#yardmulegrid").data("data-existingSpot", false); }
        }

        function onFail_checkIfSpotChangeRequestExist(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkIfSpotChangeRequestExist");
        }
        function onSuccess_getYardMuleRequestsGridData(value, ctx, methodName) {
            GLOBAL_YARDMULE_DATA.length = 0;
            for (i = 0; i < value.length; i++) {
                var strDUETime = "";
                if (value[i][14]) {
                    var strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }

                var isOpenInCMS;
                var MSID;
                var PO
                if (value[i][0] == -1) {
                    isOpenInCMS = formatNegativeOneMSIDToNA(value[i][17]);
                    MSID = formatNegativeOneMSIDToNA(value[i][0]);
                    PO = formatNegativeOneMSIDToNA(value[i][1]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][17]);
                    MSID = value[i][0];
                    PO = value[i][1];
                }
                
                var trailNum;
                if(checkNullOrUndefined(value[i][12]))
                {
                    trailNum = "";
                }
                else{
                    trailNum = value[i][12].toString();
                }
                GLOBAL_YARDMULE_DATA[i] = {
                    "MSID": value[i][0], "MSIDTEXT": MSID, "PO": PO, "REQID": value[i][2], "TASK": value[i][3], "YM": value[i][4], "YMID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": trailNum, "REQTYPEID": value[i][13],
                    "DUE": value[i][14], "DUEDATE": value[i][14], "DUETIME": strDUETime, "TRUCKTYPE": value[i][15],
                    "REJECT": value[i][16], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][18], //"PRODUCT": products,
                    "CURRENTSPOT": value[i][18], "PRODCOUNT": value[i][20], "PRODID": value[i][21], "PRODDETAIL": value[i][22]
                };
            }
            PageMethods.getCompletedRequestData(onSuccess_getCompletedRequestData, onFail_getCompletedRequestData);
        }

        <%--Needs same data as onSuccess_getYardMuleRequestsGridData--%>
        function onSuccess_getYardMuleRequestsGridDataReload(value, ctx, methodName) {
            var MSID = $("#yardmulegrid").data("data-MSID");
            if (MSID > 0) {
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            }
            else {
                $("#tableLog").empty();
                $("#cboxLogTruckList").igCombo("value", null);
            }
            $("#yardmulegrid").data("data-MSID", "");
            GLOBAL_YARDMULE_DATA.length = 0;

            for (i = 0; i < value.length; i++) {
                var strDUETime = "";
                if (value[i][14]) {
                    var strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }

                var isOpenInCMS;
                var MSID;
                var PO
                if (value[i][0] == -1) {
                    isOpenInCMS = formatNegativeOneMSIDToNA(value[i][17]);
                    MSID = formatNegativeOneMSIDToNA(value[i][0]);
                    PO = formatNegativeOneMSIDToNA(value[i][1]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][17]);
                    MSID = value[i][0];
                    PO = value[i][1];
                }
                GLOBAL_YARDMULE_DATA[i] = {
                    "MSID": value[i][0], "MSIDTEXT": MSID, "PO": PO, "REQID": value[i][2], "TASK": value[i][3], "YM": value[i][4], "YMID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": value[i][12], "REQTYPEID": value[i][13],
                    "DUE": value[i][14], "DUEDATE": value[i][14], "DUETIME": strDUETime, "TRUCKTYPE": value[i][15],
                    "REJECT": value[i][16], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][18], //"PRODUCT": products,
                    "CURRENTSPOT": value[i][18], "PRODCOUNT": value[i][20], "PRODID": value[i][21], "PRODDETAIL": value[i][22]
                };

            }

            $("#yardmulegrid").igGrid("option", "dataSource", GLOBAL_YARDMULE_DATA);
            $("#yardmulegrid").igGrid("dataBind");
        }


        function onFail_getYardMuleRequestsGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getYardMuleRequestsGridData");
        }


        function onSuccess_getDataForAddNewRowForYM(value, ctx, methodName) {
            var MSID = $("#yardmulegrid").data("data-MSID");
            $("#cboxYMTrailerNum").igCombo("value", null);
            var defaultSpot = null;
            var trailerValue = null;
            if (value.length > 0) {
                if (value[0][0]) {

                    trailerValue = returnItemFromArray(GLOBAL_AVAILABLE_TRAILERS, "TEXT", value[0][0], "VALUE");
                    if (trailerValue) {
                        $("#cboxYMTrailerNum").igCombo("value", trailerValue);
                    }
                }

                if (value[0][1]) {<%--assigned spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(value[0][1]); <%-- spot number --%>
                    defaultSpot = value[0][2];
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(11)").text(value[0][9]); <%-- spot number --%>
                    defaultSpot = value[0][7];
                }
            }
            if (checkNullOrUndefined(trailerValue)) {
                trailerValue = returnItemFromArray(GLOBAL_AVAILABLE_TRAILERS, "MSID", -1, "VALUE");
                $("#cboxYMTrailerNum").igCombo("value", trailerValue);
            }
            PageMethods.getSpotsByType(MSID, onSuccess_getSpotsByType, onFail_getSpotsByType, defaultSpot);
        }

        function onSuccess_getDataForAddNewRowUsingTrailerNum(value, ctx, methodName) {
            if (value.length) {
                var defaultSpot = null;
                if (value[0][1]) {<%--assigned spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(value[0][1]); <%-- spot number --%>
                    defaultSpot = value[0][2];
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(11)").text(value[0][9]); <%-- spot number --%>
                    defaultSpot = value[0][7];
                }
                if (!checkNullOrUndefined(value[0][3])) {
                    $("#cboxYMMSID").igCombo("value", value[0][3]);
                    $("#yardmulegrid").data("data-MSID", value[0][3]);
                    PageMethods.getSpotsByType(value[0][3], onSuccess_getSpotsByType, onFail_getSpotsByType, defaultSpot);
                }
                else {
                    $("#cboxYMMSID").igCombo("value", -1);
                    $("#yardmulegrid").data("data-MSID", -1);
                    PageMethods.getSpotsByType(-1, onSuccess_getSpotsByType, onFail_getSpotsByType, defaultSpot);
                }

            }
            else {
                $("#cboxYMMSID").igCombo("value", -1);
                $("#yardmulegrid").data("data-MSID", -1);
                PageMethods.getSpotsByType(-1, onSuccess_getSpotsByType, onFail_getSpotsByType, defaultSpot);
            }
        }

        function onFail_getDataForAddNewRowUsingTrailerNum(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getDataForAddNewRowUsingTrailerNum");

        }

        function onSuccess_getDataForAddNewRowForLoader(value, ctx, methodName) {
            if (value.length) {
                if (value[0][1]) {<%--assigned spot--%>
                    $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text(value[0][1]); <%-- spot number --%>
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(7)").text(value[0][9]);
                }

                <%--Load Type--%>
                if (value[0][5]) {
                    if (value[0][5] == "LOADIN") {<%--load--%>
                        $("#cboxReqTypes").igCombo("value", 1);
                    }
                    else {<%--unload--%>
                        $("#cboxReqTypes").igCombo("value", 2);
                    }
                }

                <%--if not drop trailer--%>
                if (checkNullOrUndefined(value[0][4]) == true || value[0][4] == false) {
                    var today = new Date();
                    $("#dpLoaderDUEDATE").igDatePicker("value", today);
                    var dTime = new Date(value[1]);
                    var dueTime = ("00" + dTime.getHours()).slice(-2) + ":" + ("00" + dTime.getMinutes()).slice(-2);
                    $("#dpLoaderDueTime").igDatePicker("value", dueTime);
                }
            }
            else {
                $("#cboxReqTypes").igCombo("value", 3);
            }
        }

        function onFail_getDataForAddNewRow(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getDataForAddNewRow");
        }


        function onSuccess_getTimeslotsData(value, ctx, methodName) {
            var check = value;
            var colCount = value[0] + 1; <%--+1 for time column--%>
            var headerData = value[1];
            headerData.splice(0, 0, [-1, "Time"]); <%--add time column header--%>
            var data = value[2];
            var schedGridData = [];

            for (i = 0; i < data.length; i++) {
                schedGridData[i] = {
                    "SPOTID": data[i][0], "FROMTIME": data[i][1], "TOTIME": data[i][2], "ISOPEN": data[i][3], "TRUCKTYPE": data[i][4],
                    "ISDISABLED": data[i][5], "DAYOFWEEK": data[i][6], "ISAPPT": data[i][7], "HRSBLOCK": data[i][8], "PONUM": data[i][9]
                }
            };

            var newHeader = createScheduleGridHeader(colCount, headerData, schedGridData);
            var dvTableHeader = $("#dwScheduleTableHeader");
            dvTableHeader.html("");
            dvTableHeader.append(newHeader);

            var newtable = createScheduleGrid(colCount, headerData, schedGridData, true);
            var dvTable = $("#dwScheduleTable");
            dvTable.html("");
            dvTable.append(newtable);

            <%--setup for highlighting selected--%>
            var selSpot = $("#cboxYMNewSpot").igCombo("value");
            if (!selSpot) {
                selSpot = -999; <%--set to -999 for no spot column--%>
            }
            var newTime = $("#txtDUETIME").igEditor("option", "value");
            $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').removeClass(); <%--remove all classes on cell--%>
            $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').addClass("cell_Selected").addClass("cell_Available")
            var MSID = $("#yardmulegrid").data("data-MSID"); <%--MSID FROM editted grid--%>
            var selDateText = $("#dpDUEDATE").igEditor("text");
            var po = formatYardmulePOCombo(MSID);
            $("#dwSchedulePOLabel").text(" PO: " + po + " DATE: " + selDateText);


            $(dwSchedule).igDialog("open");
        }

        function onFail_getTimeslotsData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getTimeslotsData");
        }

        function onSuccess_getCompletedRequestData(gridData, ctx, methodName) {
            if (gridData) {
                var requester = "";
                var assignee = "";
                for (i = 0; i < gridData.length; i++) {
                    var isOpenInCMS;
                    requester = gridData[i][4] + " " + gridData[i][5];
                    assignee = gridData[i][6] + " " + gridData[i][7];
                    isOpenInCMS = formatBoolAsYesOrNO(gridData[i][17]);

                    GLOBAL_COMPLETE_DATA[i] = {
                        "MSID": gridData[i][0], "PO": gridData[i][1], "REQID": gridData[i][2], "TASK": gridData[i][3], "REQUESTER": requester, "ASSIGNEE": assignee,
                        "TIMEASSIGNED": gridData[i][8], "TSTART": gridData[i][9], "TEND": gridData[i][10], "COMMENTS": gridData[i][11], "NEWSPOT": gridData[i][12],
                        "TRAILNUM": gridData[i][13], "DUETIME": gridData[i][14], "REJECT": gridData[i][16], "isOpenInCMS": isOpenInCMS // truck type =  gridData[i][15] not sure why its here but didnt want to remove it
                    };
                }
            }
            <%--Call init grid to setup grids --%>
            init_grid();
        }

        function onFail_getCompletedRequestData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getCompletedRequestData");
        }

        <%-------------------------------------------------------
        Click Handlers
        -------------------------------------------------------%>

        function onclick_ShowYardMule() {
            $("#yardMuleGridWrapper").show();
            $("#btn_ShowYM").hide();
            $("#btn_HideYM").show();
        }
        function onclick_HideYardMule() {
            $("#yardMuleGridWrapper").hide();
            $("#btn_ShowYM").show();
            $("#btn_HideYM").hide();
        }
        function onclick_ShowLoader() {
            $("#loadergridWrapper").show();
            $("#btn_ShowLoader").hide();
            $("#btn_HideLoader").show();
        }
        function onclick_HideLoader() {
            $("#loadergridWrapper").hide();
            $("#btn_ShowLoader").show();
            $("#btn_HideLoader").hide();
        }
        function onclick_ShowComplete() {
            $("#completedGridWrapper").show();
            $("#btn_ShowComplete").hide();
            $("#btn_HideComplete").show();
        }
        function onclick_HideComplete() {
            $("#completedGridWrapper").hide();
            $("#btn_ShowComplete").show();
            $("#btn_HideComplete").hide();
        }

        function onclick_availableCellClick(evt, ui) {
            var spotTime = $(this).data("hour");
            var spotID = $(this).data("spotid");

            var spotName = "";
            if (spotID !== -999) {
                spotName = formatSpotCombo(spotID);
            }
            var timeblock = $(this).data("timeblock");
            if (timeblock) {
                timeblock = timeblock * 60 <%--convert to min--%>
            }
            else {
                timeblock = 0;
            }

            var splitHr = spotTime.split(":");
            var hr = splitHr[0];
            var min = splitHr[1];

            var cellDate = new Date(1900, 0, 1, hr, min, 0);
            var startHour = ("00" + cellDate.getHours()).slice(-2) + ":" + ("00" + cellDate.getMinutes()).slice(-2);
            var endDate = new Date(cellDate.getTime() + timeblock * 60000);
            var isValidBlock = true;

            <%--iterate from starttime to endtime and get cells within that range and spotid and check for class cell_notAvailable--%>
            while (cellDate <= endDate) {
                var newtime = ("00" + cellDate.getHours()).slice(-2) + ":" + ("00" + cellDate.getMinutes()).slice(-2);
                var isNotAvailable = $('td[data-hour="' + newtime + '"][data-spotID="' + spotID + '"]').hasClass("cell_notAvailable");
                if (isNotAvailable) {
                    isValidBlock = false;
                }
                cellDate = new Date(cellDate.getTime() + 30 * 60000); <%--add 30 min--%>

            }
            if (isValidBlock) {
                var response
                if (checkNullOrUndefined(spotName)) {

                    response = confirm("Select " + startHour + " for task? ")
                }
                else {

                    response = confirm("Select " + startHour + " at spot " + spotName + " for task? ")
                }

                if (response) {

                    var selSpot = $("#cboxYMNewSpot").igCombo("value", spotID);
                    var newTime = $("#txtDUETIME").igEditor("option", "value", startHour);

                    $(dwSchedule).igDialog("close");

                }
            }
            else {
                alert("Not a valid time block. Please select a different time.");
            }
        }
        <%-------------------------------------------------------
         Initialize page components
         -------------------------------------------------------%>
        $(function () {
            $("#btn_ShowYM").hide();
            $("#btn_ShowLoader").hide();
            $("#btn_ShowComplete").hide();

            $("#dwSchedule").igDialog({
                minWidth: "300px",
                minHeight: "300px",
                maxHeight: "75%",
                state: "closed",
                resizable: false,
                modal: true,
                draggable: false,
                showCloseButton: true
            });
            $("#dwProductDetails").igDialog({
                width: "650px",
                height: "550px",
                state: "closed",
                modal: true,
                draggable: false
            });

            $("#gridPODetails").igGrid({
                dataSource: null,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                primaryKey: "PODETAILID",
                columns:
                [
                { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "150px", },
                { headerText: "CMS Product ID", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", },

                ]
            });

            <%--Start call; will cascade and call other pagemethods--%>
            PageMethods.getYardMules(onSuccess_getYardMules, onFail_getYardMules);

            <%-- Add click handler: --%>
            $(dwSchedule).on("click", "td.cell_Available", onclick_availableCellClick);
            $(dwSchedule).on("click", "td.cell_Available.cell_ScheduledButOverWritable", onclick_availableCellClick);

            <%--set data attributes--%>
            $("#yardmulegrid").data("data-existingSpot", false);
            $("#yardmulegrid").data("data-invalidSpot", false);
            $("#yardmulegrid").data("data-MSID", -1);
            $("#yardmulegrid").data("data-REQID", 0);

            var isMobile = isOnMobile();
            $("#logButton").click(function () {
                var logDisplay = $('#logTableWrapper').css('display');
                truckLog_MiniMaxAndRemember(logDisplay);
            });

            $("#cboxLogTruckList").igCombo({
                dataSource: GLOBAL_LOG_OPTIONS,
                textKey: "PO",
                valueKey: "MSID",
                width: "100%",
                virtualization: true,
                selectionChanged: function (evt, ui) {
                    if (ui.items.length == 1) {
                        PageMethods.getLogDataByMSID(ui.items[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, ui.items[0].data.MSID);
                    }
                    else if (ui.items.length == 0) {
                        $("#tableLog").empty();
                        $("#cboxLogTruckList").igCombo("value", null);
                    }
                }
            });
            PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);

            $(document).delegate("#yardmulegrid", "iggridcellclick", function (evt, ui) {
                if (GLOBAL_ISDIALOG_OPEN === false) {
                    PageMethods.checkStatusOfYMRequest(ui.rowKey, onSuccess_checkStatusOfYMRequest, onFail_checkStatusOfYMRequest, 'update');
                }
                else {
                    GLOBAL_ISDIALOG_OPEN = false;
                }
            });

            $(document).delegate("#loadergrid", "iggridcellclick", function (evt, ui) {
                if (GLOBAL_ISDIALOG_OPEN === false) {
                    PageMethods.checkStatusOfLoaderRequest(ui.rowKey, onSuccess_checkStatusOfLoaderRequest, onFail_checkStatusOfLoaderRequest, 'update');
                }
                else {
                    GLOBAL_ISDIALOG_OPEN = false;
                }
            });
        }); <%-- $(function () {  --%>

    </script>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow">
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display: none">
                    <img src='Images/tLogMaxi.png' id="maxiIcon" /></div>
                <div id="tLogMini">
                    <img src='Images/tLogMini.png' id="miniIcon" /></div>
            </div>
            Truck Log
        </div>
        <div id="logTableWrapper">
            <input id="cboxLogTruckList" />
            <div id="tableLog"></div>
        </div>
    </div>
    <div id="dwProductDetails">
        <h2><span>PO - Trailer:     <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>

    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideYardMule()" value="Hide Grid" id="btn_HideYM" />
            <input type="button" onclick="    onclick_ShowYardMule()" value="Show Grid" id="btn_ShowYM" /></div>
        <h2>Assign Tasks to Yardmule</h2>
    </div>
    <br />
    <br />
    <div id="yardMuleGridWrapper">
        <table id="yardmulegrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideLoader()" value="Hide Grid" id="btn_HideLoader" />
            <input type="button" onclick="    onclick_ShowLoader()" value="Show Grid" id="btn_ShowLoader" /></div>
        <h2>Assign Trucks to Loader</h2>
    </div>
    <br />
    <br />
    <div id="loadergridWrapper">
        <table id="loadergrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideComplete()" value="Hide Grid" id="btn_HideComplete" />
            <input type="button" onclick="    onclick_ShowComplete()" value="Show Grid" id="btn_ShowComplete" /></div>
        <h2>Completed Loader & Yard Mule Requests</h2>
    </div>
    <br />
    <br />
    <div id="completedGridWrapper">
        <table id="completedGrid"></table>
    </div>
    <%-- dialog for schedule selection--%>
    <div id="dwSchedule" style="position: relative">
        <div id="dwScheduleDiv1">Click a cell to choose a time and spot for
            <div id="dwSchedulePOLabel"></div>
        </div>
        <div id="dwScheduleTableHeader"></div>
        <div id="dwScheduleTable"></div>
    </div>

</asp:Content>
