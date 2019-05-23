<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="yardMuleRequestOverview.aspx.cs" Inherits="TransportationProject.yardMuleRequestOverview" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Yard Mule Requests</h2>
    <h3>Shows open yard mule requests and all completed request for the day.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
     <script type="text/javascript">
         <%--TODO look into editingCellStarting ui.columnKey issue
         add moved to column
         --%>
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
         var GLOBAL_IS_MOBILE_VIEWING = false;
         var GLOBAL_LOG_OPTIONS = [];
         var GLOBAL_COMPLETE_DATA = [];
         var GLOBAL_SPOTS_OPTIONS = [];
         var GLOBAL_ISDIALOG_OPEN = false;

         <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>

         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
         function show_completeGrid() {
             $("#btn_hide_completeGrid").show();
             $("#btn_show_completeGrid").hide();
             $("#completeGridWrapper").show();
         }
         function hide_completeGrid() {
             $("#btn_show_completeGrid").show();
             $("#btn_hide_completeGrid").hide();
             $("#completeGridWrapper").hide();
         }

         function onclick_deleteFile(fid) {
             r = confirm("Continue removing this file from the truck data? This cannot be undone.")
             if (r) {
                 var msid = $('#dwFileUpload').data("data-MSID");
                 PageMethods.deleteFileDBEntry(fid, "OTHER", msid, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, fid);
             }
         }

         function OnClick_AddImage(evt, msid, reqid) {
             $('#igUploadIMAGE').data("MSID", msid);
             $("#igUploadIMAGE_ibb_fp").click();
         }
         function onSuccess_ImageUpload(reqid) {
             alert("Image Upload Successful ");
             $("#CameraUpload" + reqid).val("");
         }

         function onFailure_ImageUpload(reqid) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFailure_ImageUpload");
             $("#CameraUpload" + reqid).val("");
         }
         function chooseFile(reqid) {
             $("#CameraUpload" + reqid).click();
         }
         function onSuccess_getYardMuleRequestGridData(value, ctx, methodName) {
             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
             var newYardMuleRequestData = []; <%--values to bind grid--%>
             newYardMuleRequestData.length = 0; <%--make empty--%>
             for (i = 0; i < value.length; i++) {
                 var requester = value[i][13] + " " + value[i][14];
                 var MSID;
                 var isOpenInCMS;

                 <%-- replace spot labels - if spot value is null then it is a generic request --%>
                 var nspotDesc = formatValueToValueOrNA(value[i][9]);
                 var ospotDesc = formatValueToValueOrNoneWithParenthesis(value[i][10]);
                 var currentSpotDesc = formatValueToValueOrNoneWithParenthesis(value[i][25]);

                 <%-- replace POnumber labels - if MSID is -1 then it is a generic request and not linked to a trailer --%>
                 var poLabel, trailernum = '';
                 if (-1 === value[i][0]) { <%-- if MSID == 1 --%>
                     poLabel = "(N/A)";
                     MSID = "(N/A)";
                     isOpenInCMS = "(N/A)";
                 }
                 else {
                     poLabel = comboPOAndTrailer(value[i][1], value[i][20]);
                     isOpenInCMS = formatBoolAsYesOrNO(value[i][23]);
                 }

                 var location = formatValueToValueOrNA(value[i][21]);
                 var status = formatValueToValueOrNA(value[i][22]);

                 var assigneename = null;
                 if (!checkNullOrUndefined(value[i][11])) {
                     assigneename = value[i][11] + " " + value[i][12];
                 }

                 newYardMuleRequestData[i] = {
                     "MSID": value[i][0], "PO": poLabel, "REQID": value[i][2], "TASK": value[i][3], "ASSIGNEEID": value[i][4], "REQUESTERID": value[i][5],
                     "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "SPOT": value[i][8], "CURRENTSPOT": value[i][24], "NEWSPOTDESC": nspotDesc, "SPOTDESC": ospotDesc, "CURRENTSPOTDESC": currentSpotDesc, "ASSIGNEENAME": assigneename,
                     "REQUESTERNAME": requester, "TIMEASSIGNED": value[i][15], "TSTART": value[i][16],
                     "TEND": value[i][17], "TDUE": value[i][18], "REJECT": value[i][19], "LOCATIONTEXT": location, "STATUSTEXT": status,
                     "TRAILERNUM": trailernum, "isOpenInCMS": isOpenInCMS, "PRODCOUNT": value[i][26], "PRODID": value[i][27], "PRODDETAIL": value[i][28]
                 };
             }
             $("#yardmulegrid").igGrid("option", "dataSource", newYardMuleRequestData);
             $("#yardmulegrid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
             PageMethods.getCompletedRequestData(onSuccess_getCompletedRequestData, onFail_getCompletedRequestData);
         }
         function onFail_getYardMuleRequestGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_getYardMuleRequestGridData");
         }
         function onSuccess_startRequest(value, MSID, methodName) {
             if (value) {
                 $("#timeStartedUndoEditDialog").show();
                 $("#btnTimeStartedEditDialog").hide();
                 $("#btnTimeEndedEditDialog").show();
                 $("#timeStartedEditDialog").html(formatDate(value));
             }
             <%--refresh grid --%>
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);

             if (MSID != -1) {
                 PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
             }
             else {
                 $("#tableLog").empty();
                 $("#cboxLogTruckList").igCombo("value", null);
             }
         }
         function onFail_startRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_startRequest");
         }
         function onSuccess_completeRequest(value, MSID, methodName) {
             if (value) {
                 $("#btnTimeEndedEditDialog").hide();
                 $("#timeStartedUndoEditDialog").hide();
                 $("#timeEndedUndoEditDialog").show();
                 $("#timeEndedEditDialog").html(formatDate(value));
             }
             <%--refresh grid --%>
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
             if (MSID != -1) {
                 PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
             }
             else {
                 $("#tableLog").empty();
                 $("#cboxLogTruckList").igCombo("value", null);
             }
         }

         function onFail_completeRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_completeRequest");
         }
         function onSuccess_updateRequest(value, ctx, methodName) {
             <%--refresh grid --%>
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
         }

         function onFail_updateRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_updateRequest");
         }

         function onSuccess_undoStartRequest(value, MSID, methodName) {
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
             if (MSID != -1) {
                 PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
             }
             else {
                 $("#tableLog").empty();
                 $("#cboxLogTruckList").igCombo("value", null);
             }
         }
         function onFail_undoStartRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_undoStartRequest");
         }

         function onSuccess_undoCompleteRequest(value, MSID, methodName) {
             $("#undoEndRequestionLocationDialogBox").data("data-REQID", 0);
             $("#undoEndRequestionLocationDialogBox").data("data-MSID", 0);
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
             if (MSID != -1) {
                 PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
             }
             else {
                 $("#tableLog").empty();
                 $("#cboxLogTruckList").igCombo("value", null);
             }
         }
         function onFail_undoCompleteRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_undoCompleteRequest");
         }

         function onSuccess_getCompletedRequestData(gridData, ctx, methodName) {
             if (gridData) {
                 var requester = "";
                 var assignee = null;
                 var isOpenInCMS;
                 for (i = 0; i < gridData.length; i++) {
                     requester = gridData[i][4] + " " + gridData[i][5];
                     var nspotDesc = formatValueToValueOrNA(gridData[i][12]);
                     var trailernum = formatValueToValueOrNA(gridData[i][13]);

                     var poLabel, MSIDLabel = "";
                     if (-1 === gridData[i][0]) {
                         poLabel = "(N/A)";
                         MSIDLabel = "(N/A)";
                         isOpenInCMS = "(N/A)";
                     }
                     else {
                         poLabel = gridData[i][1];
                         MSIDLabel = gridData[i][0];
                         isOpenInCMS = formatBoolAsYesOrNO(gridData[i][17]);
                     }

                     if (!checkNullOrUndefined(gridData[i][6])) {
                         assignee = gridData[i][6] + " " + gridData[i][7];
                     }

                     GLOBAL_COMPLETE_DATA[i] = {
                         "MSID": MSIDLabel, "PO": poLabel, "REQID": gridData[i][2], "TASK": gridData[i][3], "REQUESTER": requester, "ASSIGNEE": assignee,
                         "TIMEASSIGNED": gridData[i][8], "TSTART": gridData[i][9], "TEND": gridData[i][10], "COMMENTS": gridData[i][11], "NEWSPOT": nspotDesc,
                         "TRAILNUM": gridData[i][13], "DUETIME": gridData[i][14], "REJECT": gridData[i][16], "isOpenInCMS": isOpenInCMS
                     };
                 }
                 $("#completedGrid").igGrid("option", "dataSource", GLOBAL_COMPLETE_DATA);
                 $("#completedGrid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
             }
         }

         function onFail_getCompletedRequestData(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_getCompletedRequestData");
         }


         function onSuccess_updateLocationAndUndoRequestComplete(value, MSIDofSelectedTruck, methodName) {//asd
             PageMethods.getLogDataByMSID(MSIDofSelectedTruck, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSIDofSelectedTruck);
             $("#undoEndRequestionLocationDialogBox").data("data-REQID", 0);
             $("#undoEndRequestionLocationDialogBox").data("data-MSID", 0);

             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
             $("#cboxLocations").igCombo("value", null);
             $("#cboxDockSpots").igCombo("value", null);
             $("#undoEndRequestionLocationDialogBox").igDialog("close");
         }

         function onFail_updateLocationAndUndoRequestComplete(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_updateLocationAndUndoRequestComplete");
         }

         function onSuccess_verifySpotIsCurrentlyAvailable(NumberOfTrucksScheduledInTimeBlock, MSID, methodName) {
             var MSID = $("#undoEndRequestionLocationDialogBox").data("data-MSID");
             var dSpotID = $("#cboxDockSpots").igCombo("value");
             var dSpotName = $("#cboxDockSpots").igCombo("text");
             if (NumberOfTrucksScheduledInTimeBlock > 0) {
                 alert("There is a truck currently in dock spot " + dSpotName + ". Please pick a new location and try again.");
             }
             else {
                 PageMethods.verifySpotIsAvailableInSchedule(MSID, dSpotID, onSuccess_verifySpotIsAvailableInSchedule, onFail_verifySpotIsAvailableInSchedule, MSID);
             }

         }
         function onFail_verifySpotIsCurrentlyAvailable(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_verifySpotIsCurrentlyAvailable");
         }


         function onSuccess_verifySpotIsAvailableInSchedule(returnData, MSID, methodName) {
             var MSID = $("#undoEndRequestionLocationDialogBox").data("data-MSID");
             var REQID = $("#undoEndRequestionLocationDialogBox").data("data-REQID");
             var newLocation = $("#cboxLocations").igCombo("value");
             var dSpot = $("#cboxDockSpots").igCombo("value");

             if (!checkNullOrUndefined(returnData)) {
                 if (returnData[0][4] == 'Not On Site') {
                     var c = confirm("The PO " + returnData[0][0] + " with trailer # " + returnData[0][1] + "is expected to arrive at " + formatDate(returnData[0][2]) + " and has the dock spot reserved till " + formatDate(returnData[0][3]) + ". Would you like to continue?");
                     if (c == true) {
                         PageMethods.updateLocationAndUndoRequestComplete(MSID, newLocation, dSpot, REQID, onSuccess_updateLocationAndUndoRequestComplete, onFail_updateLocationAndUndoRequestComplete, MSID);
                     }
                 }
                 else {
                     var c = confirm("The PO " + returnData[0][0] + " with trailer # " + returnData[0][1] + " has the dock spot reserved from " + formatDate(returnData[0][2]) + " to " + formatDate(returnData[0][3]) + ". It is currently on site at " + returnData[0][4] + " with a status of " + returnData[0][5] + ". Would you like to continue?");
                     if (c == true) {
                         PageMethods.updateLocationAndUndoRequestComplete(MSID, newLocation, dSpot, REQID, onSuccess_updateLocationAndUndoRequestComplete, onFail_updateLocationAndUndoRequestComplete, MSID);
                     }
                 }
             }
             else {
                 PageMethods.updateLocationAndUndoRequestComplete(MSID, newLocation, dSpot, REQID, onSuccess_updateLocationAndUndoRequestComplete, onFail_updateLocationAndUndoRequestComplete, MSID);
             }
         }
         function onFail_verifySpotIsAvailableInSchedule(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_verifySpotIsAvailableInSchedule");
         }
         function onSuccess_checkIfUserIsAssignee_Complete(isSignedInUserAssignee, completeRequestRequiredData, methodName) {
             if (isSignedInUserAssignee == true) {
                 var response = confirm("Are you sure you would like to complete the request for PO - Trailer: " + completeRequestRequiredData[2] + "?");<%--PO#--%>
                if (response) {
                    PageMethods.completeRequest(completeRequestRequiredData[0], completeRequestRequiredData[1], onSuccess_completeRequest, onFail_completeRequest, completeRequestRequiredData[1]); <%--arr reqID, MSID--%>
                }
            }
            else {
                alert("This request is not assigned to you so you can not complete it. Please have the Dock Manager re-assigned this request to you.");
            }
        }
        function onSuccess_checkIfUserIsAssignee_Start(isSignedInUserAssignee, startRequestRequiredData, methodName) {
            if (isSignedInUserAssignee == true) {
                PageMethods.startRequest(startRequestRequiredData[0], startRequestRequiredData[1], onSuccess_startRequest, onFail_startRequest, startRequestRequiredData[1]); <%--arr - reqID, MSID--%>
            }
            else {
                alert("This request is not assigned to you so you can not start it. Please have the Dock Manager re-assigned this request to you.");
            }
        }

        function onSuccess_checkIfUserIsAssignee_UndoStart(isSignedInUserAssignee, undoStartRequestRequiredData, methodName) {
            if (isSignedInUserAssignee == true) {
                $("#timeStartedUndoEditDialog").hide();
                $("#btnTimeEndedEditDialog").hide();
                $("#btnTimeStartedEditDialog").show();
                $("#timeStartedEditDialog").html("");
                PageMethods.undoStartRequest(undoStartRequestRequiredData[1], undoStartRequestRequiredData[0], onSuccess_undoStartRequest, onFail_undoStartRequest, undoStartRequestRequiredData[1]);
            }
            else {
                alert("This request is not assigned to you so you can not undo the start of it. Please have the Dock Manager re-assigned this request to you.");
            }
        }

        function onSuccess_checkIfUserIsAssignee_UndoComplete(isSignedInUserAssignee, undoCompleteRequestRequiredData, methodName) {
            if (isSignedInUserAssignee == true) {
                var MSID = $("#undoEndRequestionLocationDialogBox").data("data-MSID");
                var REQID = $("#undoEndRequestionLocationDialogBox").data("data-REQID");
                PageMethods.checkRequestTypeBeforeUndoComplete(REQID, onSuccess_checkRequestTypeBeforeUndoComplete, onFail_checkRequestTypeBeforeUndoComplete, MSID);
            }
            else {
                alert("This request is not assigned to you so you can not undo the complete of it. Please have the Dock Manager re-assigned this request to you.");
            }
        }
        function onFail_checkIfUserIsAssignee(value, ctx, methodName) {
            sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_checkIfUserIsAssignee");
        }

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
            sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_getPODetailsFromMSID");
        }

        function onSuccess_checkStatusOfRequest(value, startRequestRequiredData, methodName) {
            if (value) {
                if (value[1] == 1) { <%--isAvailableForUserToEdit--%>
                    PageMethods.startRequest(startRequestRequiredData[0], startRequestRequiredData[1], onSuccess_startRequest, onFail_startRequest, startRequestRequiredData[1]); //arr - reqID, MSID
                }
                else {
                    if (value[0] == 0) { <%--doesRequestExist--%>
                        alert("Request is no longer available.");
                    }
                    else {
                        alert("Request is assigned to another user.");
                    }
                }
            }
        }

        function onFail_checkStatusOfRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in yardMuleRequestOverview.aspx onFail_checkStatusOfRequest");
        }



         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>

         function openProductDetailDialog(MSID, rowID) {
             if (MSID != -1) {
                 var PO = $("#yardmulegrid").igGrid("getCellValue", rowID, "PO");
                 PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
                 if (PO) {
                     $("#dvProductDetailsPONUM").text(PO);
                 }
             }
         }
         function onclick_btnUpdateLocation() {
             var requestID = $("#undoEndRequestionLocationDialogBox").data("data-REQID");
             var MSIDofSelectedTruck = $("#undoEndRequestionLocationDialogBox").data("data-MSID");
             var newLocation = $("#cboxLocations").igCombo("value");
             var dSpot = $("#cboxDockSpots").igCombo("value");
             if ((newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') && checkNullOrUndefined(dSpot) == true) {
                 alert("You must specify which dock spot you want to move to. ");
             }
             else {
                 var newLocation = $("#cboxLocations").igCombo("value");
                 var dSpot = $("#cboxDockSpots").igCombo("value");
                 if (newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') {
                     PageMethods.verifySpotIsCurrentlyAvailable(MSIDofSelectedTruck, dSpot, onSuccess_verifySpotIsCurrentlyAvailable, onFail_verifySpotIsCurrentlyAvailable, MSIDofSelectedTruck);
                 }
                 else {
                     PageMethods.updateLocationAndUndoRequestComplete(MSIDofSelectedTruck, newLocation, 0, requestID, onSuccess_updateLocationAndUndoRequestComplete, onFail_updateLocationAndUndoRequestComplete, MSIDofSelectedTruck);
                 }
             }
         }
         function onclick_btnSaveEditDialog() {
             var reqID = $("#editDialog").data("data-ReqID");
             var comment = $("#yardMuleCommentsEditDialog").text();
             PageMethods.updateRequest(reqID, comment, onSuccess_updateRequest, onFail_updateRequest);
             $("#editDialog").igDialog("close")
         }

         function onclick_btnCancelEditDialog() {
             $("#editDialog").igDialog("close");
         }
         function onclick_startRequest(reqID, MSID) {
             var startRequestRequiredData = [reqID, MSID];
             PageMethods.checkStatusOfRequest(reqID, onSuccess_checkStatusOfRequest, onFail_checkStatusOfRequest, startRequestRequiredData);
         }
         function onclick_completeRequest(reqID, MSID, PO) {
             var completeRequestRequiredData = [reqID, MSID, PO];
             PageMethods.checkIfUserIsAssignee(reqID, onSuccess_checkIfUserIsAssignee_Complete, onFail_checkIfUserIsAssignee, completeRequestRequiredData);
         }

         function undoRequestStart(reqID, MSID) {
             var undoStartRequestRequiredData = [reqID, MSID];
             PageMethods.checkIfUserIsAssignee(reqID, onSuccess_checkIfUserIsAssignee_UndoStart, onFail_checkIfUserIsAssignee, undoStartRequestRequiredData);
         }

         function undoRequestComplete(MSID, REQID) {
             $("#undoEndRequestionLocationDialogBox").data("data-MSID", MSID);
             $("#undoEndRequestionLocationDialogBox").data("data-REQID", REQID);
             PageMethods.checkIfUserIsAssignee(REQID, onSuccess_checkIfUserIsAssignee_UndoComplete, onFail_checkIfUserIsAssignee);
         }
         function onclick_dialogButtonClick(buttonType, timeType) {
             var reqID = $("#editDialog").data("data-ReqID");
             var MSID = $("#yardmulegrid").igGrid("getCellValue", reqID, "MSID");
             var PO = $("#yardmulegrid").igGrid("getCellValue", reqID, "PO");
             switch (timeType) {
                 case "start":
                     if (buttonType == "undo") {
                         undoRequestStart(MSID);
                     }
                     else {
                         onclick_startRequest(reqID, MSID);
                     }
                     break;
                 case "complete":
                     if (buttonType == "undo") {
                         undoRequestComplete(MSID, reqID);
                     }
                     else {
                         onclick_completeRequest(reqID, MSID, PO);
                     }
                     break;
             }
         }
         function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }

         function onFail_getLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx onFail_getLogDataByMSID");
         }

         function onSuccess_getLogList(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);
                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                     $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                     $("#cboxLogTruckList").igCombo("dataBind");
                 }
             }
         }

         function onFail_getLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx onFail_getLogList");
         }
         function onSuccess_getAvailableDockSpots(value, MSID, methodName) {
             GLOBAL_SPOTS_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_SPOTS_OPTIONS[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
             }
             $("#cboxDockSpots").igCombo("option", "dataSource", GLOBAL_SPOTS_OPTIONS);
             $("#cboxDockSpots").igCombo("dataBind");
             $("#dockSpotOptionsWrapper").hide();
             $("#undoEndRequestionLocationDialogBox").igDialog("open");
         }
         function onFail_getAvailableDockSpots(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx onFail_getAvailableDockSpots");
         }
         function onSuccess_getCurrentDockSpot(currentOrAssignedSpot, ctx, methodName) {
            <%--clear selection--%>
             $("#cboxDockSpots").igCombo("value", null);
             <%-- 0 = no spot, 3015 = Yard, & 3017 = Wait Area--%>
             if (currentOrAssignedSpot != 0 && currentOrAssignedSpot != 3015 && currentOrAssignedSpot != 3017) {
                 $("#cboxDockSpots").igCombo("value", currentOrAssignedSpot);
             }
         }
         function onFail_getCurrentDockSpot(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx onFail_getCurrentDockSpot");
         }

         function onSuccess_getLocationOptions(returnValue, MSID, methodName) {
             GLOBAL_LOCATION_OPTIONS = [];
             for (i = 1; i < returnValue.length; i++) {<%--start at one to not add current location--%>
                 GLOBAL_LOCATION_OPTIONS.push({ "LOC": returnValue[i][0], "LOCTEXT": returnValue[i][1] });
             }
             $("#cboxLocations").igCombo("option", "dataSource", GLOBAL_LOCATION_OPTIONS);
             $("#cboxLocations").igCombo("dataBind");
             PageMethods.getAvailableDockSpots(MSID, onSuccess_getAvailableDockSpots, onFail_getAvailableDockSpots, MSID);
         }
         function onFail_getLocationOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_getLocationOptions");
         }

         function onSuccess_checkRequestTypeBeforeUndoComplete(doesUndoRequireNewLocation, MSID, methodName) {
             if (doesUndoRequireNewLocation == true) {
                 PageMethods.getLocationOptions(MSID, onSuccess_getLocationOptions, onFail_getLocationOptions, MSID);
             }
             else {
                 var REQID = $("#undoEndRequestionLocationDialogBox").data("data-REQID");
                 PageMethods.undoCompleteRequest(MSID, REQID, onSuccess_undoCompleteRequest, onFail_undoCompleteRequest, MSID);
                 $("#btnTimeEndedEditDialog").show();
                 $("#timeStartedUndoEditDialog").show();
                 $("#timeEndedUndoEditDialog").hide();
                 $("#timeEndedEditDialog").html(" ");
             }
         }

         function onFail_checkRequestTypeBeforeUndoComplete(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_checkRequestTypeBeforeUndoComplete");
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

         function onSuccess_getFileUploadsFromMSID(value, MSID, methodName) {
            <%--clear data from controls --%>
             $('#alinkBOL').text("");
             $('#alinkCOFA').text("");
             $('#dUpBOL').show();
             $('#dDelBOL').hide();
             $('#dUpCOFA').show();
             $('#dDelCOFA').hide();

             var rowID = $('#dwFileUpload').data("data-rowID");
             if (value.length > 0) {
                 var gridData = [];
                 var rowCount = 0;
                 for (var i = 0; i < value.length; i++) {
                     gridData[i] = { "FID": value[i][0], "MSID": value[i][1], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5], "FNAMEOLD": value[i][6], "FUPDEL": "" };
                 }
                 $("#gridFiles").igGrid("option", "dataSource", gridData);
                 $("#gridFiles").igGrid("dataBind");
             }

             var PO = $("#yardmulegrid").igGrid("getCellValue", rowID, "PO");
             if (PO) {
                 $("#POTrailer_dwFileUpload").text(PO);
             }
             $("#dwFileUpload").igDialog("open");
         }
         function onFail_getFileUploadsFromMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_getFileUploadsFromMSID");
         }
         function openUploadDialog(MSID, REQID) {
             $('#dwFileUpload').data("data-MSID", MSID);
             $('#dwFileUpload').data("data-rowID", REQID);
             PageMethods.getFileUploadsFromMSID(MSID, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, MSID);
         }
         function openUploadDialogMobile(MSID, REQID) {
             $("#gridFiles").igGridUpdating("option", "enableAddRow", false);
             $('#dwFileUpload').data("data-MSID", MSID);
             $('#dwFileUpload').data("data-rowID", REQID);
             PageMethods.getFileUploadsFromMSID(MSID, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, MSID);
         }
         function onSuccess_processFileAndData(value, FileInfo, methodName) {
             if (FileInfo) {
                 var fileuploadType = FileInfo[1];
                 if ("IMAGE" === fileuploadType) {
                    <%--Add entry into DB --%>
                    var timestamp = new Date().toLocaleDateString();
                    var imageDescription = "Yardmule Uploaded Image " + timestamp;
                    PageMethods.addFileDBEntry(FileInfo[2], "IMAGE", FileInfo[0], value[1], value[0], imageDescription, onSuccess_addFileDBEntry, onFail_addFileDBEntry, FileInfo)
                }
                else if ("OTHER" === fileuploadType) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                    $("#gridFiles").data("data-FPath", value[0]);
                    $("#gridFiles").data("data-FNameNew", value[1]);
                    $("#gridFiles").data("data-FNameOld", FileInfo[0]);
                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    $("#dwFileUpload tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(FileInfo[0]);
                }
        }
    }
    function onFail_processFileAndData(value, ctx, methodName) {
        sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_processFileAndData");
    }
    function onSuccess_addFileDBEntry(value, ctx, methodName) {
        var msid = $('#dwFileUpload').data("data-MSID");
        if (!checkNullOrUndefined(msid)) {
            PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
        }
    }
    function onFail_addFileDBEntry(value, ctx, methodName) {
        sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_addFileDBEntry");
    }
    function onSuccess_updateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>
            $("#gridFiles").igGrid("commit");
        }

        function onFail_updateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_updateFileUploadData");
        }

        function onSuccess_deleteFileDBEntry(value, rowID, methodName) {
            $("#gridFiles").igGridUpdating("deleteRow", rowID);
            $("#gridFiles").igGrid("commit");
            var msid = $('#dwFileUpload').data("data-MSID");
            PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
        }

        function onFail_deleteFileDBEntry(value, ctx, methodName) {
            sendtoErrorPage("Error in yardMuleRequestOverview.aspx, onFail_deleteFileDBEntry");
        }
        <%-------------------------------------------------------
        Initialize Infragistics IgniteUI Controls
        -------------------------------------------------------%>
         $(function () {
             $("#btnViewTruck").hide();
             var GLOBAL_IS_MOBILE_VIEWING = isOnMobile();
             if (GLOBAL_IS_MOBILE_VIEWING == false) {
                 $("#logButton").click(function () {
                     var logDisplay = $('#logTableWrapper').css('display');
                     truckLog_MiniMaxAndRemember(logDisplay);
                 });
             }

             var textAreaWidth = getWidthForTextAreaForMobilePopUp();
             $("#yardMuleCommentsEditDialog").css({ "width": textAreaWidth });


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
                     }
                 }
             });
             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
             <%--will change edit mode when in width is equal to or less than 850px. (for mobile) --%>
             if (GLOBAL_IS_MOBILE_VIEWING) {
                 hide_completeGrid();
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
                                headerText: "Image Upload", key: "IMGUP", dataType: "text", width: "10%", template:
                                "<img id = 'CameraImg' src ='Images/camera48x48.png' style='width:75%; height: auto;' onclick='OnClick_AddImage(event,${MSID}, ${REQID}); return false;'/>"
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
                             { headerText: "PO - Trailer", key: "PO", dataType: "string", width: "29%" },
                             { headerText: "Orginally Assigned Spot", key: "SPOTDESC", dataType: "string", hidden: true, width: "0%" },
                              { headerText: "Location", key: "LOCATIONTEXT", dataType: "string", width: "0%", hidden: true },
                             { headerText: "Status", key: "STATUSTEXT", dataType: "string", width: "0%", hidden: true },
                             { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", hidden: true, width: "0%" },
                             { headerText: "Move To Spot", key: "NEWSPOTDESC", dataType: "string", hidden: true, width: "0%" },
                             {
                                 headerText: "Product", key: "PRODID", dataType: "string", width: "18%",
                                 template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                                            "{{else}}Multiple{{/if}}"
                             },
                             { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0%", hidden: true },
                             {
                                 headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "18%",
                                 template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                                            "{{else}}<div><input type='button' value='Multiple' onclick='GLOBAL_ISDIALOG_OPEN = true; openProductDetailDialog(${MSID},${REQID}); return false;'></div>{{/if}}"
                             },
                             { headerText: "Task Comments", key: "TASK", dataType: "string", hidden: true, width: "0%" },
                             { headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", width: "29%" },
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
                                  if (!ui.rowAdding) {<%-- row edit --%>
                                      if (ui.columnKey == "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "IMGUP") {<%--disable timestamp column edits--%>
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
                                       PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                   }
                                   else {
                                       $("#tableLog").empty();
                                       $("#cboxLogTruckList").igCombo("value", null);
                                   }
                                   var isStartEndBtnClicked = $("#yardmulegrid").data("data-STARTENDClick");
                                   if (isStartEndBtnClicked) { <%-- end editing if start/end btns were clicked, continue edit mode only when other cells are clicked --%>
                                  $("#yardmulegrid").data("data-STARTENDClick", false); <%--reset--%>

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
                                      PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
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

                 }); <%--end complete grid--%>
                 
                 $("#gridPODetails").igGrid({
                     dataSource: null,
                     width: "100%",
                     virtualization: false,
                     autoGenerateColumns: false,
                     primaryKey: "PODETAILID",
                     columns:
                     [
                     { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                     { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "34%", },
                     { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "34%", },
                     { headerText: "QTY", key: "QTY", dataType: "number", width: "16%", },
                     { headerText: "Unit", key: "UNIT", dataType: "string", width: "16%", }
                     ]
                 });
             }
             else {
                 GLOBAL_IS_MOBILE_VIEWING = false;
                 $("#dvHideShowButtons").hide();
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
                                 headerText: "File Upload", key: "FUPLOAD", dataType: "string", width: "100px", template: "{{if(${MSID} !== -1)}} " +
                                     "<div><input type='button' value='View/Upload' onclick='openUploadDialog(${MSID}, ${REQID}); return false;'></div>" +
                                     "{{else}} <div>(N/A)</div>{{/if}}"
                             },
                             {
                                 headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                                   "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                             },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "50px" },
                             {
                                 headerText: "MSID", key: "MSID", dataType: "number", width: "50px", template: "{{if(${MSID} == -1)}}" +
                                        "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                             },
                             { headerText: "PO - Trailer", key: "PO", dataType: "string", width: "125px" },
                             { headerText: "Orginally Assigned Spot", key: "SPOTDESC", dataType: "string", width: "75px" },
                             { headerText: "Location", key: "LOCATIONTEXT", dataType: "string", width: "125px" },
                             { headerText: "Status", key: "STATUSTEXT", dataType: "string", width: "150px" },
                             { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", width: "75px" },
                             { headerText: "Move To Spot", key: "NEWSPOTDESC", dataType: "string", width: "50px" },
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
                             { headerText: "Task Comments", key: "TASK", dataType: "string", width: "250px" },
                             { headerText: "Assigned to", key: "ASSIGNEENAME", dataType: "string", width: "125px" },
                             { headerText: "Requested by", key: "REQUESTERNAME", dataType: "string", width: "125px" },
                             { headerText: "Time Due", key: "TDUE", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                             {
                                 headerText: "Time Started", key: "TSTART", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "150px",
                                 template: "{{if(checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'><input id='btnReqStart' type='button' value='Start' onclick='onclick_startRequest(${REQID}, ${MSID});' class='ColumnContentExtend'/></div>" +
                                     "{{elseif (checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'>${TSTART}<span class='Mi4_undoIcon' onclick='undoRequestStart(${REQID}, ${MSID})'></span></div>" +
                                     "{{else}}${TSTART}</div>{{/if}}"
                             },
                             {
                                 headerText: "Time End", key: "TEND", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "150px",
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
                                  if (!ui.rowAdding) {<%-- row edit --%>
                                      if (ui.columnKey == "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "IMGUP") { //disable timestamp column edits--%>
                                          return false;
                                      }
                                  }
                              },
                              editRowStarting: function (evt, ui) {
                                  var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                  if (row.MSID != -1) {
                                      PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  }
                                  else {
                                      $("#tableLog").empty();
                                      $("#cboxLogTruckList").igCombo("value", null);
                                  }
                                  var isStartEndBtnClicked = $("#yardmulegrid").data("data-STARTENDClick");
                                  if (isStartEndBtnClicked) { <%-- end editing if start/end btns were clicked, continue edit mode only when other cells are clicked --%>
                                      $("#yardmulegrid").data("data-STARTENDClick", false); <%--reset--%>
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
                                  {
                                      headerText: "MSID", key: "MSID", dataType: "string", width: "50px", template: "{{if(${MSID} == -1)}}" +
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
                                       PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                   }
                                   else {
                                       $("#tableLog").empty();
                                       $("#cboxLogTruckList").igCombo("value", null);
                                   }
                                   var isStartEndBtnClicked = $("#yardmulegrid").data("data-STARTENDClick");
                                   if (isStartEndBtnClicked) { <%-- end editing if start/end btns were clicked, continue edit mode only when other cells are clicked --%>
                                  $("#yardmulegrid").data("data-STARTENDClick", false); <%--reset--%>
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

                      }); <%--end complete grid--%>
                 

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
                     { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                     { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                     { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", }
                     ]
                 });
             }
             PageMethods.getYardMuleRequestGridData(onSuccess_getYardMuleRequestGridData, onFail_getYardMuleRequestGridData);
             

             <%-- add grid cell click handler --%>
             $(document).delegate("#yardmulegrid", "iggridcellclick", function (evt, ui) {

                 if (ui.colKey === 'TSTART' || ui.colKey === 'TEND') {
                     $("#yardmulegrid").data("data-STARTENDClick", true);
                 }
                 else {
                     $("#yardmulegrid").data("data-STARTENDClick", false);
                 }
             });

             $("#undoEndRequestionLocationDialogBox").igDialog({
                 width: "400px",
                 height: "250px",
                 state: "closed"
             }); //end of $("#deleteConfirmationDialogBox").igDialog({

             $("#cboxLocations").igCombo({
                 dataSource: null,
                 textKey: "LOCTEXT",
                 valueKey: "LOC",
                 width: "200px",
                 autoComplete: true,
                 enableClearButton: false,
                 selectionChanging: function (evt, ui) {
                     if (ui.items.length > 0) {
                         if (ui.items[0].data.LOC == 'DOCKVAN' || ui.items[0].data.LOC == 'DOCKBULK') {
                             $("#dockSpotOptionsWrapper").show();
                         }
                         else {
                             $("#dockSpotOptionsWrapper").hide();
                             $("#cboxDockSpots").igCombo("value", null);
                         }
                     }

                 }
             });

             $("#cboxDockSpots").igCombo({
                 dataSource: null,
                 textKey: "DOCKSPOT",
                 valueKey: "SPOTID",
                 width: "200px",
                 autoComplete: true,
                 enableClearButton: false
             });
             $("#dockSpotOptionsWrapper").hide();


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
                 { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                 { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                 { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", },

                 ]
             });
             $("#dwFileUpload").igDialog({
                 width: "600px",
                 height: "550px",
                 state: "closed",
                 modal: true,
                 draggable: false,
                 stateChanging: function (evt, ui) {
                     if (ui.action === "close") {
                        <%-- Delete attributes on controls --%>
                         $("#gridFiles").removeData("data-FPath");
                         $("#gridFiles").removeData("data-FNameNew");
                         $("#gridFiles").removeData("data-FNameOld");
                         $("#dwFileUpload").removeData("data-MSID");
                         $('#dBOLcontainer').removeData("data-fileID");
                         $('#dCOFAcontainer').removeData("data-fileID");

                         $("#dwFileUpload span.anr_t:contains('Add new file')").text("Add new row"); <%-- change back label on grid --%>
                         $('#dwFileUpload td[title="Click to start adding new file"]').attr('title', "Click to start adding new row");
                     }
                     else if (ui.action === "open") {
                     }
                 }
             });
             $("#gridFiles").igGrid({
                 dataSource: null,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 primaryKey: "FID",
                 columns:
                 [
                 { headerText: "", key: "FID", dataType: "number", width: "0%", hidden: true },
                 { headerText: "", key: "MSID", dataType: "number", width: "0%", hidden: true },
                 { headerText: "", key: "FPATH", dataType: "string", width: "0%", hidden: true },
                 { headerText: "", key: "FNAMENEW", dataType: "string", width: "0%", hidden: true },
                 { headerText: "Filename", key: "FNAMEOLD", dataType: "string", width: "30%", template: "<div><a href='${FPATH}\${FNAMENEW}'>${FNAMEOLD}</a></div>" },
                 { headerText: "Description", key: "DESC", dataType: "string", width: "60%" },
                 { headerText: "", key: "FUPDEL", dataType: "string", width: "10%", template: "<div><div><img src='Images/xclose.png' onclick='onclick_deleteFile(${FID});return false;' height='16' width='16'/></div></div>" },
                 ],
                 features:
                     [
                         {
                             name: "Updating",
                             enableAddRow: true,
                             editMode: "row",
                             enableDeleteRow: false, <%-- // use clickable image since this only shows on row hover --%>
                             rowEditDialogContainment: "owner",
                             showReadonlyEditors: false,
                             enableDataDirtyException: false,
                             autoCommit: false,
                             rowAdding: function (evt, ui) {
                                 if (ui.rowAdding) {
                                     var fpath = $("#gridFiles").data("data-FPath");
                                     var fnameNew = $("#gridFiles").data("data-FNameNew");
                                     var fnameOld = $("#gridFiles").data("data-FNameOld");
                                     if (fpath && fnameNew && fnameOld) {
                                        <%-- TODO: add code to insert new row with new file data --%>
                                        return true;
                                    }
                                    else {
                                        <%-- STOP Rowadded event --%>
                                        return false;
                                    }
                                }
                            },
                             rowAdded: function (evt, ui) {



                                 var fpath = $("#gridFiles").data("data-FPath");
                                 var fnameNew = $("#gridFiles").data("data-FNameNew");
                                 var fnameOld = $("#gridFiles").data("data-FNameOld");
                                 var msid = $("#dwFileUpload").data("data-MSID");
                                 var desc = ui.values.DESC;

                                 PageMethods.addFileDBEntry(msid, "OTHER", fnameOld, fnameNew, fpath, desc, onSuccess_addFileDBEntry, onFail_addFileDBEntry);


                             },
                             editRowStarted: function (evt, ui) {
                                 if (ui.rowAdding) {
                                     $("#igUploadOTHER_ibb_fp").click();
                                 }
                                 else { <%-- // do nothing; regular row is being edited --%>

                                }
                            },
                             editRowEnded: function (evt, ui) {
                                <%-- change add new row's filename col back to blank column --%>
                                $("#gridFiles tr").eq(2).find('td:first-child').text("");

                                if (ui.rowAdding) { <%-- //new row edited --%>
                                    if (!ui.update) {
                                        //do nothing 
                                    }
                                }
                                if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) { <%-- //regular row is being edited --%>
                                    //call update
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    PageMethods.updateFileUploadData(row.FID, ui.values.DESC, onSuccess_updateFileUploadData, onFail_updateFileUploadData);
                                }
                            },
                             columnSettings: [
                                 { columnKey: "FNAMEOLD", readOnly: true },
                                 { columnKey: "FUPDEL", readOnly: true },
                                 { columnKey: "DESC", editorType: "text" },

                             ]
                         },


                     ]
             });

             $("#igUploadOTHER").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) {
                     showProgress();
                 },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#dwFileUpload").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "OTHER";
                     ctxVal[2] = MSID;
                     PageMethods.processFileAndData(ui.filePath, "OTHER", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) {
                     hideProgress();
                     sendtoErrorPage("Error in yardMuleRequestOverview.aspx, igUploadOTHER");
                 },

             });

             $("#igUploadIMAGE").igUpload({
                 autostartupload: true,
                 allowedExtensions: ["tiff", "gif", "bmp", "png", "jpg", "jpeg", "webp", "bpg", "pdf"],
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) {
                 },
                 fileExtensionsValidating: function (evt, ui) {
                     var check = ui;
                 },
                 fileSelected: function (evt, ui) {
                     showProgress();
                 },
                 fileUploading: function (evt, ui) {
                 },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#igUploadIMAGE").data("MSID");

                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "IMAGE";
                     ctxVal[2] = MSID;
                     PageMethods.processFileAndData(ui.filePath, "IMAGE", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                     hideProgress();
                     $("#igUploadIMAGE").data("MSID", null);
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },

                 onError: function (evt, ui) {
                     $("#igUploadIMAGE").data("MSID", null);
                     hideProgress();
                     if (ui.errorType.toString().contains("clientside") && ui.errorCode === 2) {
                         alert("Invalid file type. Please make sure you are uploading an image.");
                     }
                     else {
                         sendtoErrorPage("Error in yardMuleRequestOverview.aspx, igUploadImage");
                     }
                 },
             });

             $(".ui-igdialog-headerbutton ui-corner-all ui-state-default ui-igdialog-buttonclose").click(function () {
                 var isEditDiaOpen = $('#editDialog').css('display');
                 if (isEditDiaOpen != 'none') {
                     $("#editDialog").igDialog("close");
                 }
             });
             var windowWidth = $(window).width();
             windowWidth = windowWidth - 10;
             $("#editDialog").igDialog({
                 width: windowWidth + 'px',
                 height: "500px",
                 state: "closed",
                 closeButtonTitle: "X"
             }); //end of $("#editDialog").igDialog({

             var igDiaHeight = ($(window).height() - ($(window).height() / 5))
             if (GLOBAL_IS_MOBILE_VIEWING == false) {
                 igDiaWidth = "650";
                 igDiaHeight = "650";
             }
             $("#dwProductDetails").igDialog({
                 width: windowWidth + 'px',
                 height: igDiaHeight + "px",
                 state: "closed",
                 modal: true,
                 draggable: false
             });


         }); <%--end of $(function () {--%>



         </script>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow" >
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display:none"><img src='Images/tLogMaxi.png' id="maxiIcon" /></div>
                <div id="tLogMini" ><img src='Images/tLogMini.png' id="miniIcon"/></div></div>
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
    <h2>Open Yard Mule Requests</h2>
    <table id="yardmulegrid"></table>
    <br /><br />
    <h2>Completed Yard Mule Requests</h2>
    <div class="dvHideShowButtons">
        <input type="button" id="btn_show_completeGrid" onclick="show_completeGrid(); return false;" value="Show" />
        <input type="button" id="btn_hide_completeGrid" onclick="hide_completeGrid(); return false;" value="Hide" />
    </div>
    <div id ="completeGridWrapper">
    <table id="completedGrid"></table></div>
    
     <div id ="editDialog">
        <table style="border: 0;">
            <tr><td><label class="mobileLbl">Rejected: </label></td><td><label class="mobileLbl" id="RejectEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">PO - Trailer: </label></td><td><label class="mobileLbl" id="POEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">Status: </label></td><td><label class="mobileLbl" id="statusEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Current Location: </label></td><td><label class="mobileLbl" id="locationEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Orginally Assigned Spot:  </label></td><td><label class="mobileLbl" id="originalSpotEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Current Spot: </label></td><td><label class="mobileLbl" id="currentSpotEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Move Spot: </label></td><td><label class="mobileLbl" id="newSpotEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Task Comments:  </label></td><td><label class="mobileLbl" id="taskCommentEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">Requested By: </label></td><td><label class="mobileLbl" id="requestedByEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Time Started: </label></td><td><label class="mobileLbl" id="timeStartedEditDialog"> </label>
                <input style="margin-top: 0; margin-bottom: 0; font-size: .75em;" id="btnTimeStartedEditDialog" type="button" value='Start Task' onclick="onclick_dialogButtonClick('moveFwd', 'start');"></td><td>
                <span id="timeStartedUndoEditDialog" class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','start')"></span></td></tr>
            
            <tr><td><label class="mobileLbl">Time Ended: </label></td><td><label class="mobileLbl" id="timeEndedEditDialog"></label>
                <input style="margin-top: 0; margin-bottom: 0; font-size: .75em;"  id="btnTimeEndedEditDialog" type="button" value='Task Ended' onclick="onclick_dialogButtonClick('moveFwd', 'complete');"></td><td>
                <span style="float: left" id="timeEndedUndoEditDialog"  class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','complete')"></span></td></tr>

            <tr><td>    </td></tr>
        </table>
        <table style="border: 0;">
            <tr><td><label class="mobileLbl">Yard Mule Comments:</label></td><td><textarea id="yardMuleCommentsEditDialog" maxlength="250"></textarea></td></tr>
            <tr><td></td><td><button type="button" style="margin-top: 0; margin-bottom: 0; font-size: .75em;" id="btnViewFiles" onclick=''>View Files</button>
            <button style="margin-top: 0; margin-bottom: 0; font-size: .75em;" type="button" id="btnSave" onclick='onclick_btnSaveEditDialog(); return false;'>Save</button>
            <button style="margin-top: 0; margin-bottom: 0; font-size: .75em;" type="button" id="btnCancel" onclick='onclick_btnCancelEditDialog(); return false;'>Cancel</button></td></tr>
        </table>
    </div>
    
    <div id ="undoEndRequestionLocationDialogBox">
        <h2>Update Location</h2>
        <input id="cboxLocations" />
        <button type="button" id="btn_updateLocation" onclick='onclick_btnUpdateLocation();'>Update Location</button>
        <div id="dockSpotOptionsWrapper">
            <h2>Dock Spot</h2>
            <input id="cboxDockSpots" />
        </div>
    </div>
    
    <%-- dialog for file upload--%>
    <div id="dwFileUpload">
        <h2><span>Files for PO - Trailer:  <span id="POTrailer_dwFileUpload"></span></span></h2>
        <div class="ContentExtend"><table id="gridFiles" class="ContentExtend"></table></div>
    </div>
    
    <%--<div id="igUploadIMAGE" style='display: none;' ></div>--%>
    <div id="dvUploadsContainer" style='display: none;'>
        <div id="igUploadOTHER" style='display: none;' ></div>
        <input type="file" id = "igUploadIMAGE"  class = "CameraUpload" accept="image/*" capture='camera'>
    </div>
</asp:Content>